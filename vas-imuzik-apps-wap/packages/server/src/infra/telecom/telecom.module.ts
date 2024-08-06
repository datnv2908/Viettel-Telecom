import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { ExternalRbtService } from './external-rbt/external-rbt.service';
import { CrbtRewardEntity } from './models/crbt-reward.entity';
import { KpiLogEntity } from './models/kpi-log.entity';
import { PhoneNumberService } from './phone-number/phone-number.service';
import { SoapFactory } from './soap.factory';
import { TelecomSettings } from './telecom.settings';

@Module({
  imports: [
    TypeOrmModule.forFeature([KpiLogEntity], 'log_db'),
    TypeOrmModule.forFeature([CrbtRewardEntity]),
  ],
  providers: [PhoneNumberService, SoapFactory, ExternalRbtService, TelecomSettings],
  exports: [PhoneNumberService, ExternalRbtService],
})
export class TelecomModule {}
