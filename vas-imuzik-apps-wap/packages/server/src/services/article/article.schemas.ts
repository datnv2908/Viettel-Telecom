import { ArgsType, Field, ID, InputType, ObjectType } from '@nestjs/graphql';

import {
  ConnectionArgs,
  ConnectionType,
  EdgeType,
} from '../../api/paging/connection-paging.schemas';
import { Article } from './models/article.entity';

@ObjectType()
export class ArticleEdge extends EdgeType(Article) {}

@ObjectType()
export class ArticleConnection extends ConnectionType(Article, ArticleEdge) {
  @Field()
  totalCount: number;
}

@ArgsType()
export class ArticleConnectionArgs extends ConnectionArgs {
  // @Field(type => SongWhereInput, { nullable: true })
  // where?: SongWhereInput;
  // @Field(type => SongOrderByInput, { nullable: true })
  // orderBy?: SongOrderByInput;
}




