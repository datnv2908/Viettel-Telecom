import { Injectable } from '@nestjs/common';

import { Config } from './../../config/config';

@Injectable()
export class UrlService {
  constructor(private config: Config) {}

  mediaUrl(imagePath?: string | null) {
    return /http/.test(imagePath ?? '')
      ? imagePath
      : (imagePath && 'http://imedia.imuzik.com.vn' + imagePath) ||
          `https://source.unsplash.com/random/${512}x${Math.round(256 + 256 * Math.random())}`;
  }
  memberAvatarUrl(fileName?: string | null) {
    return (
      (fileName && `${this.config.MEDIA_MEMBER_HOST}/${fileName}`) ||
      `https://source.unsplash.com/random/${512}x${Math.round(256 + 256 * Math.random())}`
    );
  }
}
