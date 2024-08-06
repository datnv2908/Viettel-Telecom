import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UtilModule } from '../../infra';
import { ArticleService } from './article.service';
import { Article } from './models/article.entity';
import { ArticleResolver } from './resolvers/article.resolver';
import { ArticleLoaderService } from './loader-services/article.loader-service';
import { ApiHelperModule } from '../../api/api-helper.module';
import {SongLoaderService } from '../music/loader-services/song.loader-service';
import { MusicModule, Song } from '../music';

@Module({
  imports: [
    TypeOrmModule.forFeature([
        Article,
        Song
    ]),
    UtilModule,
    ApiHelperModule,
    MusicModule
  ],
  providers: [
    ArticleService,
    ArticleLoaderService,
    ArticleResolver,
    SongLoaderService
  ],
})
export class ArticleModule {}
