import { NestFactory } from '@nestjs/core';
import bodyParser = require('body-parser');
import cookieParser = require('cookie-parser');
import dotenv = require('dotenv');
import helmet = require('helmet');

import { AppModule } from './app.module';
import { Config } from './infra/config';

async function bootstrap() {
  dotenv.config();
  const app = await NestFactory.create(AppModule);
  app.use(bodyParser.json({ limit: '1mb' }));
  app.use(cookieParser());
  app.use(helmet());
  app.enableCors({
    origin: true,
    credentials: true,
  });
  const config = app.get(Config);
  await app.listen(config.PORT);
}
bootstrap();
