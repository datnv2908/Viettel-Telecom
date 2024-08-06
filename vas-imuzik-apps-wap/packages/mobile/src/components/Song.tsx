import React from 'react';
import { Image, TouchableOpacity } from 'react-native';

import { useShareSong } from '../hooks';
import { NavLink, useAlert, useNavigationLink } from '../platform/links';
import { Box, Flex, Text } from '../rebass';
import { AnimatedEq } from './Animation';
import { formatSongDuration } from './Player';
import { Icon, ICON_GRADIENT_1, IconColor, IconName } from './svg-icon';
import { useMeQuery } from '../queries';

interface BasicSongProps {
  slug?: string | null;
  image?: string | null;
  title?: string | null;
  artist?: string;
}
interface ChartSongProps extends BasicSongProps {
  title: string;
  artist: string;
  image?: string | null;
  download?: number | null;
  showEq?: boolean;
  animated?: boolean;
  index?: number | null;
  liked?: boolean | null;
  timeCreate?: string;
  onPlayClick?: () => void;
  hideDownload?: boolean;
  hideGift?: boolean;
}

function formatDownload(d: number) {
  return d > 1000 ? `${Math.floor(d / 1000)}K` : d;
}

enum ToneStatue {
  PENDING = 1,
  APPROVED,
  REJECTED,
}

const ChartSongAction = (props: { icon: IconName; onPress?: () => void }) => {
  return (
    <TouchableOpacity onPress={props.onPress}>
      <Flex flexDirection="column" alignItems="center" p={2}>
        <Icon name={props.icon} size={20} />
      </Flex>
    </TouchableOpacity>
  );
};

export const ChartSong = (props: ChartSongProps) => {
  const { data: dataMe } = useMeQuery();
  const showPopup = useAlert({ type: 'requireLogin' });
  const requireLogin = () => {
    showPopup({ content: 'Vui lòng đăng nhập để sử dụng 3!' });
  };
  const showDownload = useNavigationLink(props.slug ? 'rbt' : '#', {
    type: 'download',
    songSlug: props.slug,
    timeCreate: props.timeCreate,
  });
  const showGift = useNavigationLink(props.slug ? 'rbt' : '#', {
    type: 'gift',
    songSlug: props.slug,
    timeCreate: props.timeCreate,
  });

  return (
    <Flex
      flexDirection="row"
      alignItems="center"
      css={{
        height: 80,
      }}>
      {props.index && (
        <Flex ml={1} mr={1} width={25} alignItems="center">
          <Box ml={1} mr={1} width={25} alignItems="center">
            <Text fontSize={2} color="lightText">
              {props.index}
            </Text>
          </Box>
        </Flex>
      )}
      <Flex alignItems="center" flexDirection="row" flex={1}>
        <TouchableOpacity onPress={props.onPlayClick}>
          <Flex
            bg="#C4C4C4"
            overflow="hidden"
            position="relative"
            borderRadius={4}
            justifyContent="center"
            alignItems="center"
            width={56}
            height={56}>
            {!!props.image && (
              <Image source={{ uri: props.image }} style={{ width: '100%', height: '100%' }} />
            )}
            <Box position="absolute">
              {props.showEq ? (
                <Flex ml={1} mr={1} width={25} alignItems="center">
                  <AnimatedEq size={20} animated={props.animated} />
                </Flex>
              ) : (
                <Box ml={1} mr={1} width={25} alignItems="center">
                  <Icon name="play" size={24} color="white" />
                </Box>
              )}
            </Box>
          </Flex>
        </TouchableOpacity>
        <Flex flex={1}>
          <NavLink route="/bai-hat/[slug]" params={{ slug: props.slug }}>
            <Flex flexDirection="column" ml={3}>
              <Text color="normalText" fontSize={2} fontWeight="bold" numberOfLines={1}>
                {props.title}
              </Text>
              <Text color="lightText" fontSize={1} mb={2.5} fontWeight="bold" numberOfLines={1}>
                {props.artist}
              </Text>
              {props.download ? (
                <Flex alignItems="center" flexDirection="row">
                  <Icon name="download" size={8} />
                  <Text color="lightText" fontSize={1} pl="3px">
                    {formatDownload(props.download)}
                  </Text>
                </Flex>
              ) : (
                <Flex alignItems="center" flexDirection="row">
                  <Icon name="download" size={8} />
                  <Text color="lightText" fontSize={1} pl="3px">
                    0
                  </Text>
                </Flex>
              )}
            </Flex>
          </NavLink>
        </Flex>
      </Flex>
      <Flex alignItems="flex-end" flexDirection="row">
        {!props.hideDownload && (
          <ChartSongAction
            icon="download-tune"
            onPress={dataMe?.me ? showDownload : requireLogin}
          />
        )}
        {!props.hideGift && (
          <ChartSongAction icon="gift" onPress={dataMe?.me ? showGift : requireLogin} />
        )}
      </Flex>
    </Flex>
  );
};

interface PlaylistSongProps extends BasicSongProps {
  download?: number | null;
  index: number;
  duration?: number | null;
  toneName?: string | null;
  toneCode?: string;
  cp?: string;
  contentProvider?: string | null;
  available_datetime?: string;
  liked?: boolean | null;
  isPlaying?: boolean;
  disableSongLink?: boolean;
  showEq?: boolean;
  tone?: any;
  tone_price_rbt?: number;
  reason_refuse?: string;
  expanded?: boolean;
  status?: number;
  highlighted?: boolean;
  animated?: boolean;
  hideDownload?: boolean;
  hideToneCode?: boolean;
  hideShare?: boolean;
  timeCreate?: string;
  hideLike?: boolean;
  showInfo?: boolean;
  showDelete?: boolean;
  showExpandedDownload?: boolean;
  singerName?: string;
  composer?: string;
  showExpandedGift?: boolean;
  showExpandedInvited?: boolean;
  onPlayClick?: () => void;
  onImageClick?: () => void;
  onLikeClick?: () => void;
  onShareClick?: () => void;
  onDeleteClick?: () => void;
}
const PlaylistSongExpandedAction = (props: {
  icon: IconName;
  iconColor?: IconColor;
  title: string;
  onPress?: () => void;
}) => {
  return (
    <TouchableOpacity onPress={props.onPress}>
      <Flex flexDirection="row" alignItems="center" p={1}>
        <Icon name={props.icon} size={20} color={props.iconColor || ICON_GRADIENT_1} />
        <Text ml={2} fontSize={1} fontWeight="bold">
          {props.title}
        </Text>
      </Flex>
    </TouchableOpacity>
  );
};

export const PlaylistSong = (props: PlaylistSongProps) => {
  const { data: dataMe } = useMeQuery();
  const showPopup = useAlert({ type: 'requireLogin' });
  const showCancelPopup = useAlert({ type: 'cancel1stack' });
  const showInvited = useAlert({ type: 'invite-download' });
  const showPopupInvite = (phone: any) => {
    showInvited({ content: phone });
  };
  const requireLogin = () => {
    showPopup({ content: 'Vui lòng đăng nhập để sử dụng!' });
  };

  const requireApprove = () => {
    showCancelPopup({ content: 'Nhạc chờ chưa được phê duyệt, vui lòng thử lại sau!' });
  };
  const showDownload = useNavigationLink(props.slug ? 'rbt' : '#', {
    type: 'download',
    songSlug: props.slug,
    toneCode: props.toneCode,
  });

  const showInfo = useNavigationLink(props.slug ? 'rbt' : '#', {
    type: 'info',
    songSlug: props.slug,
    toneCode: props.toneCode,
    timeCreate: props.timeCreate,
    downloadNumber: props.download ? props.download.toString : '0',
  });

  const showInfoRbt = useNavigationLink('rbt', {
    type: 'info',
    title: props.title,
    toneCode: props.toneCode,
    timeCreate: props.timeCreate,
    composer: props.composer,
    singerName: props.singerName,
    downloadNumber: props.download ? props.download + '' : '0',
    tone: props.tone,
    tone_price_rbt: props.tone?.price ? props.tone?.price + '' : props.tone_price_rbt + '',
    contentProvider: props.contentProvider,
    available_datetime: props.available_datetime,
  });

  const showGift = useNavigationLink(props.slug ? 'rbt' : '#', {
    type: 'gift',
    songSlug: props.slug,
    toneCode: props.toneCode,
  });
  const shareAction = useNavigationLink(props.slug ? 'popup' : '#', {
    title: 'Chia sẻ',
    type: 'share',
    songSlug: props.slug,
  });
  const share = useShareSong(props.slug, shareAction);
  const titleSection = (
    <Flex flexDirection="column" mr={3}>
      {!!props.toneCode ? (
        <Text color="normalText" fontSize={2} fontWeight="bold" numberOfLines={1}>
          {props.toneCode}
        </Text>
      ) : props.slug ? (
        <Text color="normalText" fontSize={2} fontWeight="bold" numberOfLines={1}>
          {props.title}
        </Text>
      ) : (
        <Text color="normalText" fontSize={2} fontWeight="bold" numberOfLines={1}></Text>
      )}
      {!!props.artist && (
        <Text color={props.highlighted ? 'normalText' : 'lightText'} fontSize={1} numberOfLines={1}>
          {props.artist}
        </Text>
      )}
    </Flex>
  );

  const status =
    props.status === ToneStatue.APPROVED &&
    props?.tone?.huawei_status === 1 &&
    props?.tone?.vt_status === 3
      ? 'Đã phê duyệt'
      : props?.tone?.vt_status === 4 || props.status === ToneStatue.REJECTED
      ? 'Từ chối'
      : 'Chờ phê duyệt';

  // const status = props.status === ToneStatue.APPROVED && props?.tone?.huawei_status == 1 && props?.tone?.vt_status == 3 ?
  //   'Đã phê duyệt' : props.status === ToneStatue.PENDING || (props.status === ToneStatue.APPROVED && !props?.tone) ?
  //     'Chờ phê duyệt' : props.status === ToneStatue.APPROVED && props?.tone?.huawei_status === 4 ? 'Từ chối' : 'Từ chối'

  // if (rbtCreation.tone_status === ToneStatue.APPROVED && rbtCreation?.tone?.huawei_status === 1 && rbtCreation?.tone?.vt_status === 3) {
  //   status = 'Đã phê duyệt'
  // }
  // else if (rbtCreation?.tone?.vt_status === 4 || rbtCreation.tone_status === ToneStatue.REJECTED) {
  //   status = 'Từ chối'
  // } else {
  //   status = 'Chờ phê duyệt'
  // }
  // let status: string;

  // if (props?.status === ToneStatue.APPROVED && props?.tone?.huawei_status === 1 && props?.tone?.vt_status === 3) {
  //   status = 'Đã phê duyệt'
  // }
  // else if (props?.tone?.vt_status === 4) {
  //   status = 'Từ chối'
  // } else {
  //   status = 'Chờ phê duyệt'

  // }

  return (
    <Flex
      borderRadius={8}
      bg="rgba(0, 0, 0, 0.4)"
      css={{
        overflow: 'hidden',
      }}>
      <Flex
        borderRadius={8}
        flexDirection="row"
        alignItems="center"
        px={3}
        height={64}
        pl={0}
        css={{
          height: 80,
          overflow: 'hidden',
          position: 'relative',
        }}
        bg={props.highlighted ? ' #3D3D3F' : 'transparent'}>
        {!!props.download && props.slug && (
          <Flex
            alignItems="center"
            flexDirection="row"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Icon name="download" size={8} />
            <Text color="lightText" fontSize={8} pl="3px">
              {formatDownload(props.download)}
            </Text>
          </Flex>
        )}

        {props.status && (
          <Flex
            alignItems="center"
            flexDirection="row"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text
              color={
                status == 'Chờ phê duyệt'
                  ? 'primary'
                  : status == 'Từ chối'
                  ? 'red'
                  : status == 'Đã phê duyệt'
                  ? 'secondary'
                  : undefined
              }
              fontSize={8}
              pl="3px">
              {status}
            </Text>
          </Flex>
        )}

        {/* {props.status === ToneStatue.PENDING || (props.status === ToneStatue.APPROVED && !props.tone) ? (
          <Flex
            alignItems="center"
            flexDirection="row"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text color="primary" fontSize={8} pl="3px">
              Chờ phê duyệt
            </Text>
          </Flex>
        ) : props.tone !== null && props.status === ToneStatue.APPROVED && props.tone?.huawei_status == 1 && props.tone?.vt_status == 3 ? (
          <Flex
            alignItems="center"
            flexDirection="row"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text color="secondary" fontSize={8} pl="3px">
              Đã duyệt
            </Text>
          </Flex>
        ) : props.status === ToneStatue.APPROVED && props.tone?.huawei_status == 4 ? (
          <Flex
            alignItems="center"
            flexDirection="column"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text color="red" fontSize={8} pl="3px">
              Từ chối
            </Text>
          </Flex>
        ) : (
          <Flex
            alignItems="center"
            flexDirection="column"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text color="red" fontSize={8} pl="3px">
              Từ chối
            </Text>
          </Flex>
        )
        } */}
        {/* {props.tone === null && (
          <Flex
            alignItems="center"
            flexDirection="row"
            px={2} 
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text color="primary" fontSize={8} pl="3px">
              Chờ phê duyệt
            </Text>
          </Flex>
        )}
        {props.status === 3 && (
          <Flex
            alignItems="center"
            flexDirection="row"
            px={2}
            py={1}
            position="absolute"
            top={0}
            right={0}>
            <Text color="red" fontSize={8} pl="3px">
              Từ chối
            </Text>
          </Flex>
        )} */}
        {props.showEq ? (
          <Flex ml={1} mr={1} width={25} alignItems="center">
            <AnimatedEq size={14} animated={props.animated} />
          </Flex>
        ) : !props.toneName ? (
          <Box ml={1} mr={1} width={25} alignItems="center">
            <Text fontSize={2} color="lightText">
              {props.index}
            </Text>
          </Box>
        ) : (
          <Box ml={1} mr={1} width={25} alignItems="center">
            <Text fontSize={2} color="lightText"></Text>
          </Box>
        )}
        <Flex flex={1} alignItems="center" flexDirection="row">
          {!!props.image && (
            <TouchableOpacity onPress={props.onImageClick}>
              <Flex
                bg="#C4C4C4"
                overflow="hidden"
                position="relative"
                borderRadius={20}
                justifyContent="center"
                alignItems="center"
                mr={3}>
                <Image source={{ uri: props.image }} style={{ width: 40, height: 40 }} />
              </Flex>
            </TouchableOpacity>
          )}
          {!!(props.title || props.artist) && (
            <Flex flex={1}>
              {props.slug && !props.disableSongLink ? (
                <NavLink route="/bai-hat/[slug]" params={{ slug: props.slug }}>
                  {titleSection}
                </NavLink>
              ) : (
                titleSection
              )}
            </Flex>
          )}
          {!!props.toneName ? (
            <Text
              color={props.highlighted ? 'normalText' : 'normalText'}
              fontSize={2}
              width={0.4}
              numberOfLines={1}
              mr={3}
              fontWeight="bold">
              {props.toneName}
            </Text>
          ) : props.toneCode ? (
            <Text
              color={props.highlighted ? 'normalText' : 'lightText'}
              fontSize={2}
              width={0.4}
              numberOfLines={1}>
              {props.toneCode}
            </Text>
          ) : undefined}
          {!!props.cp && (
            <Text color="normalText" fontSize={2} fontWeight="bold" numberOfLines={1}>
              {props.cp}
            </Text>
          )}
        </Flex>
        {!!props.duration && (
          <Text color="lightText" fontSize={1} pr={6}>
            {formatSongDuration(props.duration)}
          </Text>
        )}
        <Flex alignItems="center" flexDirection="row">
          {!props.hideDownload && (
            <ChartSongAction
              icon="download-tune"
              onPress={dataMe?.me ? showDownload : requireLogin}
            />
          )}
          {props.tone !== null ? (
            <ChartSongAction
              icon={props.isPlaying ? 'player-pause' : 'player-play'}
              onPress={props.onPlayClick}
            />
          ) : (
            <Flex flexDirection="column" alignItems="center" p={4}>
              <Text fontSize={5} color="lightText"></Text>
            </Flex>
          )}
        </Flex>
      </Flex>
      {props.expanded && (
        <Flex flexDirection="row" justifyContent="space-around" height={60} alignItems="center">
          {props.showInfo && (
            <PlaylistSongExpandedAction
              title="Thông tin"
              icon="info"
              onPress={props.slug ? showInfo : showInfoRbt}
            />
          )}
          {props.slug
            ? props.showExpandedDownload &&
              (props.tone ? (
                <PlaylistSongExpandedAction
                  title="Cài đặt"
                  icon="download-tune"
                  onPress={dataMe?.me ? showDownload : requireLogin}
                />
              ) : (
                <PlaylistSongExpandedAction
                  title="Cài đặt"
                  icon="download-tune"
                  onPress={requireApprove}
                />
              ))
            : undefined}
          {props.slug
            ? props.showExpandedGift &&
              (props.tone ? (
                <PlaylistSongExpandedAction
                  title="Tặng quà"
                  icon="gift"
                  onPress={dataMe?.me ? showGift : requireLogin}
                />
              ) : (
                <PlaylistSongExpandedAction title="Tặng quà" icon="gift" onPress={requireApprove} />
              ))
            : undefined}
          {/* {props.showExpandedInvited && (
            props.tone ?
            <PlaylistSongExpandedAction
              title="Mời tải"
              icon="invite"
              onPress={ ()=> showPopupInvite(props.toneCode)}
            /> :
              <PlaylistSongExpandedAction
                title="Mời tải"
                icon="invite"
                onPress={requireApprove}
              />
          )} */}
          {!props.hideLike && (
            <PlaylistSongExpandedAction
              title="Yêu thích"
              icon={props.liked ? 'heartlove' : 'heart'}
              onPress={props.onLikeClick}
            />
          )}
          {!props.hideShare && (
            <PlaylistSongExpandedAction title="Chia sẻ" icon="share" onPress={share} />
          )}
          {props.showDelete && (
            <PlaylistSongExpandedAction
              title="Xóa"
              icon="cross"
              iconColor="red"
              onPress={props.onDeleteClick}
            />
          )}
        </Flex>
      )}
    </Flex>
  );
};
