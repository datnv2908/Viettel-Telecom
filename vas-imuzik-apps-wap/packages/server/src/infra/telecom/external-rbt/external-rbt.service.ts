import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { format } from 'date-fns';
import { MoreThan, Repository } from 'typeorm';

import { DEFAULT_GROUP } from '../../../services/rbt/constants';
import { LoggingService } from '../../logging';
import {
  DEFAULT_TONE,
  PLUS_BRAND_ID,
  PORTAL_TYPE,
  RbtStatus,
  SMS_TYPE,
  USER_STATUS_TO_RBT_STATUS,
  UserInfo,
} from '../constants';
import { CrbtRewardEntity } from '../models/crbt-reward.entity';
import { isSuccess } from '../return-code';
import { SoapFactory } from '../soap.factory';
import { Config } from './../../config/config';

interface TimeSettings {
  loopType: string;
  timeType: string;
  startTime: string | null;
  endTime: string | null;
  // When the value of timeType is 2, the time format:
  // HH:mm:ss
  // When the value of timeType is 3, 4, 5, or 6, the time format:
  // yyyy-MM-dd HH:mm:ss
}

@Injectable()
export class ExternalRbtService {
  constructor(
    private soapFactory: SoapFactory,
    private config: Config,
    protected loggingService: LoggingService,
    @InjectRepository(CrbtRewardEntity) private crbtRewardRepository: Repository<CrbtRewardEntity>
  ) {}

  async getUserInfo(msisdn: string) {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    return await client.query({
      startRecordNum: '1',
      endRecordNum: '1',
      queryType: '2',
      phoneNumber: msisdn,
    });
  }

  async getStatus(msisdn: string): Promise<{ status: RbtStatus; userInfos?: UserInfo[] }> {
    const crbtLogger = this.loggingService.getLogger('crbt');
    try {
      const userInfoRes = await this.getUserInfo(msisdn);

      let status: RbtStatus = 'unregistered';

      // const result: T = rawResult[0];
      // crbtLogger.info(`${method}: response=${JSON.stringify(result)}`);

      crbtLogger.info(`LOG-external-rbt.service.ts[01]:${JSON.stringify(userInfoRes?.userInfos)}`);
      crbtLogger.info(`LOG-external-rbt.service.ts[02]:${JSON.stringify(userInfoRes)}`);
      const response_result = JSON.stringify(userInfoRes);
      var jsonParsed = JSON.parse(response_result);

      if (!userInfoRes.success) {
        status = 'error';
        //} else if (userInfoRes.userInfos?.length) {
      } else if (jsonParsed?.userInfos?.length) {
          status = USER_STATUS_TO_RBT_STATUS[jsonParsed?.userInfos[0]?.status.$value??"unregistered"];    //Code cũ CuongDT
          crbtLogger.info(`LOG-external-rbt.service.ts[03]:msisdn=${msisdn};status=${status}`);
      }
      let userInf: UserInfo;
      crbtLogger.info(`LOG-external-rbt.service.ts[04]:${JSON.stringify(jsonParsed?.userInfos[0])}`);
      userInf={
        serviceOrders:jsonParsed?.userInfos[0]?.serviceOrders.$value,
        status:jsonParsed?.userInfos[0]?.status.$value,
        brand:jsonParsed?.userInfos[0]?.brand.$value
      };
      return {
        status,
        userInfos: [userInf],
      };
    } catch (e) {
      crbtLogger.error(`LOG-external-rbt.service.ts[06]:${JSON.stringify(e)}`);
      return {
        status: 'error',
      };
    }
  }

  async getUserTones(msisdn: string, resourceType = '1') {
    const crbtLogger = this.loggingService.getLogger('crbt');
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.queryInboxTone({
      startRecordNum: '1',
      endRecordNum: '100',
      // doanhpv1 thêm vào cho phép lấy disc hoặc song
      resourceType, //resource = 1 : rbt, =2: tbr group
      phoneNumber: msisdn,
    });
    crbtLogger.info(`LOG-external-rbt.service.ts[getUserTones-01]:${JSON.stringify(res)}`);
    return (
      (res.toneInfos?.length && res.toneInfos) ||
      (res.toneBoxInfos?.length && res.toneBoxInfos) ||
      []
    );
  }
  async editToneBox(msisdn: string, toneBoxName: string, toneCodes: string[], toneBoxId: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    return client.editToneBox({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      name: toneBoxName,
      type: '1',
      toneBoxID: toneBoxId,
      toneCode: toneCodes, // TODO: test array of strings as input
    });
  }
  async addToneBox(msisdn: string, toneBoxName: string, toneCodes: string[]) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.addToneBox({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      name: toneBoxName,
      objectRole: '1',
      objectCode: msisdn,
      toneCode: toneCodes, // TODO: test array of strings as input
    });
    res.success = res.success && parseInt(res.toneBoxID ?? '', 10) > 0;
    return res;
  }
  async editSetting(
    msisdn: string,
    settingId: string,
    setType: string,
    timeSettings: TimeSettings,
    resourceType = '1'
  ) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    return client.editSetting({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      settingID: settingId,
      calledUserID: msisdn,
      setType,
      resourceType, // TODO: check if this is needed for creating default tone box
      ...timeSettings,
    });
  }
  async setTone(
    msisdn: string,
    toneBoxId: string,
    setType: string,
    callerNumber?: string, // accept group code
    timeSettings?: TimeSettings,
    resourceType = '1'
  ) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    return client.setTone({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      toneBoxID: toneBoxId,
      calledUserType: '1',
      calledUserID: msisdn,
      setType,
      resourceType,
      ...timeSettings,
      ...(callerNumber ? { callerNumber } : null),
    });
  }
  async queryGroup(msisdn: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.queryGroup({
      startRecordNum: '1',
      endRecordNum: '1000',
      queryType: '2', //kieu lay du lieu
      phoneNumber: msisdn,
    });
    
        console.log("Log-13:"+JSON.stringify(res));
        let items: { groupCode: any; groupName: any; }[] = []
        if(res.groupInfos?.length)
        {
          res.groupInfos?.forEach(((cloud: any) =>
          items.push({groupCode:cloud?.groupCode.$value, groupName:cloud?.groupName.$value})
        ));
        }
    return (res.groupInfos?.length && items) || [];
  }

  async addGroup(msisdn: string, groupCode: string, groupName: string, description = 'default') {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.addGroup({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      groupCode,
      groupName,
      description,
    });
    res.success = res.success && parseInt(res.groupID ?? '', 10) > 0;
    return res;
  }

  async delGroup(msisdn: string, groupCode: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    return client.delGroup({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      groupCode,
    });
  }

  async addGroupMember(
    msisdn: string,
    groupCode: string,
    memberNumber: string,
    memberName: string,
    memberDetails = ''
  ) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    return client.addGroupMember({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      groupCode,
      memberNumber,
      memberName,
      memberDetails,
    });
  }

  async delGroupMember(msisdn: string, groupCode: string, memberNumber: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    console.log("Log-delGroupMember[groupCode]:"+groupCode+":"+memberNumber+":"+msisdn);
    return  await client.delGroupMember({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      groupCode,
      memberNumber: {
        item: memberNumber
      },
    });
  }

  async querySetting(msisdn: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.querySetting({
      portalType: PORTAL_TYPE,
      calledUserType: '1',
      calledUserID: msisdn,
    });
    return (res.querySettingInfos?.length && res.querySettingInfos) || [];
  }
  async queryTbTone(msisdn: string, toneBoxID: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.queryTbTone({
      portalType: PORTAL_TYPE,
      type: '1', //Subscribers set RBT groups
      approveType: '2', //RBT groups in the working table
      toneBoxID,
    });
    return (res.queryToneInfos?.length && res.queryToneInfos) || [];
  }

  async queryGroupMember(msisdn: string, groupCode: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    const res = await client.queryGroupMember({
      portalType: PORTAL_TYPE,
      phoneNumber: msisdn,
      groupCode,
    });
    console.log("Log-client.queryGroupMember:"+JSON.stringify(res));
        let items: { memberName: any; memberNumber: any; }[] = []
        if(res.groupMemberInfos?.length)
        {
          res.groupMemberInfos?.forEach(((member: any) =>
          items.push({memberName:member?.memberName.$value, memberNumber:member?.memberNumber.$value})
        ));
        }
    console.log("Log-client.queryGroupMember[items]:"+JSON.stringify(items));
    return (items?.length && items) || [];
  }

  async activateOrPause(msisdn: string, type: 'activate' | 'pause') {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    return client.activateAndPause({
      portalType: SMS_TYPE,
      role: '1',
      roleCode: msisdn,
      type: type === 'activate' ? '1' : '2',
      phoneNumber: msisdn,
    });
  }
  async cancel(msisdn: string) {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    //return client.csUnSubscribe({
    return client.unSubscribe({
      portalType: SMS_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
    });
  }

  async deleteTone(msisdn: string, personId: string) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);
    return client.delInboxTone({
      portalType: SMS_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      personId,
    });
  }
  private async addDefaultToneBox(msisdn: string, toneCodes: string[]) {
    return this.addToneBox(msisdn, 'userToneBox', toneCodes);
  }

  private async addRbtDefault(msisdn: string, toneCode: string) {
    const defaultSetting = (await this.querySetting(msisdn)).find(
      (s) => s.setType === DEFAULT_TONE
    );
    if (defaultSetting) {
      if (defaultSetting.resourceType === '1') {
        // Neu nhac cho mac dinh hien tai la songs, them bai hat nay vao danh sach do
        return this.editToneBox(
          msisdn,
          DEFAULT_GROUP.groupName,
          [
            ...(await this.queryTbTone(msisdn, defaultSetting.toneBoxID)).map((t) => t.toneCode),
            toneCode,
          ],
          defaultSetting.toneBoxID
        );
      } else {
        // Neu nhac cho mac dinh hien tai la disc, set bai hat nay lam nhac cho mac dinh
        const res = await this.addDefaultToneBox(msisdn, [toneCode]);
        if (res.success) {
          const { loopType, timeType, startTime, endTime } = defaultSetting;
          return this.editSetting(
            msisdn,
            defaultSetting.settingID,
            defaultSetting.setType,
            { loopType, timeType, startTime, endTime },
            '1'
          );
        }
        return res;
      }
    } else {
      // Neu chua co box nhac mac dinh thi tao 1 box nhac roi set mac dinh
      const res = await this.addDefaultToneBox(msisdn, [toneCode]);
      if (res.success) {
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        return this.setTone(msisdn, res.toneBoxID!, DEFAULT_TONE);
      }
      return res;
    }
  }

  private async hasCrbtReward(msisdn: string) {
    return (
      (await this.crbtRewardRepository.count({
        where: {
          msisdn,
          expriedTime: MoreThan(new Date()),
        },
      })) > 0
    );
  }

  private async isFreeDownload(msisdn: string) {
    const now = format(new Date(), 'yyyy-MM-dd');
    const freeDownloadByPhoneNumber = this.config.FREE_DOWNLOAD_PHONE_NUMBERS.includes(msisdn);
    const freeDownloadByTime =
      [1, 2].includes(this.config.FREE_ORDER_TONE_TYPE) &&
      (this.config.FREE_ORDER_TONE_TYPE === 2
        ? this.config.FREE_ORDER_TONE_FROM.split(',').includes(now)
        : this.config.FREE_ORDER_TONE_TYPE === 1
        ? this.config.FREE_ORDER_TONE_FROM <= now && now <= this.config.FREE_ORDER_TONE_TO
        : false);
    return freeDownloadByPhoneNumber || freeDownloadByTime || (await this.hasCrbtReward(msisdn));
  }

  async orderTone(
    msisdn: string,
    toneCode: string,
    resourceType = '1',
    rbtId: string,
    isFree = false
  ) {
    const client = await this.soapFactory.getUserToneManageClient(msisdn);

    const res = await client.orderTone({
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      resourceCode: toneCode,
      resourceType: resourceType, // doanhpv1 sửa, mặc giá trị mặc định là 1
      portalType: '12', //khanhnqthem vao
      moduleCode: '00IMUZIKweb',
      discount: isFree || (await this.isFreeDownload(msisdn)) ? '1' : '0',
    });
    res.success = isSuccess(res.returnCode);
    if (res.success) {
      if (resourceType === '1') {
        return this.addRbtDefault(msisdn, toneCode);
      } else {
        throw Error('not implemented');
      }
    }
    return res;
  }
  async presentTone(msisdn: string, toUserPhoneNumber: string, toneCode: string) {
    const client = await this.soapFactory.getCrbtPresentClient(msisdn);
    return client.presentTone({
      role: '1',
      roleCode: msisdn,
      fromUserPhoneNumber: msisdn,
      toUserPhoneNumber,
      resourceType: '1',
      resourceCode: toneCode,
    });
  }
  async subscribe(msisdn: string, brandId: string) {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    if (brandId === PLUS_BRAND_ID)
      return client.subscribePlus({
        serviceID: '2',
        role: '1',
        roleCode: msisdn,
        phoneNumber: msisdn,
        validateCode: '',
        tradeMark: brandId,
      });
    return client.subscribe({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      validateCode: '',
      tradeMark: brandId,
    });
  }
  async addSubscribeReverse(msisdn: string) {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    return client.addSubscribeReverse({
      serviceID: '2',
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
    });
  }
  async unSubscribeReverse(msisdn: string) {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    return client.unSubscribeReverse({
      serviceID: '2',
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
    });
  }
  async editBrand(msisdn: string, brandId: string) {
    const client = await this.soapFactory.getUserManageClient(msisdn);
    return client.edit({
      portalType: PORTAL_TYPE,
      role: '1',
      roleCode: msisdn,
      phoneNumber: msisdn,
      tradeMark: brandId,
    });
  }
}
