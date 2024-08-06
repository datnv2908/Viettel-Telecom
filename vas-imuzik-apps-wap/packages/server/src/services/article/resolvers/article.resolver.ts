import { Args, Parent, Query, ResolveField, Resolver } from '@nestjs/graphql';
import { Raw } from 'typeorm';
import { Config } from '../../../infra/config/config';
import { Article,ARTICLE_ACTIVE } from '../models/article.entity';
import { ArticleLoaderService } from './../loader-services/article.loader-service';
import { ConnectionPagingService } from '../../../api/paging/connection-paging.service';
import {SongLoaderService } from '../../music/loader-services/song.loader-service';
import ms = require('ms');
import {
    ArticleConnection,
    ArticleConnectionArgs,
  } from '../article.schemas';
import { Song } from '../../music';

@Resolver(() => Article)
export class ArticleResolver {
  constructor(
    private articleLoaderService: ArticleLoaderService,
    private connectionPagingService: ConnectionPagingService,
    private songLoaderService: SongLoaderService,
    private config: Config
    
  ) {}

  @Query(() => Article, { nullable: true })
  async article(@Args('slug') slug: string): Promise<Article | null> {
    return this.articleLoaderService.loadBy('slug', slug);
  }

  @Query(() => ArticleConnection)
  async articles(@Args() connArgs: ArticleConnectionArgs) {
    return this.connectionPagingService.findAndPaginate(
      connArgs,
      (skip, take) =>
        this.articleLoaderService.cachedPaginatedList(
          `articles:${skip}:${take}}`,
          (articleRepository) =>
          articleRepository.findAndCount({
              where: { status: ARTICLE_ACTIVE },
              take,
              skip,
            }),
          ms(this.config.CACHE_LONG_TIMEOUT)
        ),
      { extraFields: ({ count: totalCount }) => ({ totalCount }) }
    );
  }

  @ResolveField('song', () => Song, { nullable: true })
  async song(@Parent() artice: Article) {
    return this.songLoaderService.loadBy("id",artice.song_id);
  }
  @ResolveField('image_path', () => String, { nullable: true })
  async image_path(@Parent() artice: Article) {
    return "http://imedia.imuzik.com.vn"+artice.image_path
  }
  
  @ResolveField(() => ArticleConnection)
  async articlesRelation(@Parent() artice: Article, @Args() connArgs: ArticleConnectionArgs) {
    return this.connectionPagingService.findAndPaginate(
      connArgs,
      async (skip, take) => {
        const relatedIds = artice.inner_related_article?.split(',')??[];
        return this.articleLoaderService.cachedPaginatedList(
          `relatedArticles:${relatedIds.join('|')}:${skip}:${take}`,
          (articleRepository) =>
          articleRepository
              .createQueryBuilder('s')
              .where('s.status = :active', { active: ARTICLE_ACTIVE })
              .andWhere('s.id in (:relatedIds)', {
                relatedIds: relatedIds,
              })
              // .andWhere('sg.song_id <> :songId', { songId: song.id })
              .orderBy({ 's.id': 'DESC' })
              .take(take)
              .skip(skip)
              .getManyAndCount()
        );
      },
      { extraFields: ({ count: totalCount }) => ({ totalCount }) }
    );
  }
}
