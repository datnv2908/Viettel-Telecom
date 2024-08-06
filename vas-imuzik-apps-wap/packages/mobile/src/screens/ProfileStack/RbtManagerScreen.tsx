import React, { useEffect, useState } from 'react';
import { ScrollView, TouchableOpacity } from 'react-native';
import { useRouter } from 'next/router';

import { Header, PlaylistSong } from '../../components';
import {
  ContentProvider,
  Genre,
  Maybe,
  RingBackTone,
  RingBackToneCreation,
  Song,
  useGetMyToneCreationsQuery,
} from '../../queries';
import { Box, Flex, Button, Text } from '../../rebass';
import { useTonePlayer } from '../../platform/tone-player';
import { useFetchMoreEdges } from '../../hooks';
import { useNavigationLink } from '../../platform/links';

type RbtCreate = Pick<
  RingBackToneCreation,
  | 'id'
  | 'duration'
  | 'tone_code'
  | 'created_at'
  | 'tone_name'
  | 'type_creation'
  | 'member_id'
  | 'local_file'
  | 'tone_status'
  | 'tone_price'
  | 'singer_name'
  | 'composer'
  | 'reason_refuse'
  | 'available_datetime'
> & {
  song?: Maybe<
    { __typename?: 'Song' } & Pick<Song, 'slug' | 'id' | 'name' | 'fileUrl'> & {
      genres: Array<{ __typename?: 'Genre' } & Pick<Genre, 'name'>>;
    }
  >;
  contentProvider?: Maybe<
    { __typename?: 'ContentProvider' } & Pick<ContentProvider, 'name' | 'id'>
  >;
  tone?: Maybe<
    { __typename?: 'RingBackTone' } & Pick<RingBackTone, 'name' | 'fileUrl' | 'orderTimes' | 'huawei_status' | 'vt_status' | 'price' | 'availableAt'>
  >;
};

const CollectionItem = (props: {
  idx: number;
  selected: boolean;
  playedCallback?: () => void;
  songData: RbtCreate;
}) => {

  const { songData, selected, idx } = props;
  const { audio, isPlaying, remain, duration, onPlayClick } = useTonePlayer(
    songData?.tone?.fileUrl ?? '',
    selected,
    props.playedCallback
  );
  return (
    <Box>
      <PlaylistSong
        index={idx}
        slug={songData?.song?.slug}
        disableSongLink
        toneName={songData?.tone_name}
        toneCode={songData?.tone_code}
        title={songData?.song?.name ? songData?.song?.name : songData?.tone_name}
        status={songData?.tone_status}
        download={songData?.tone_status === 2 ? songData?.tone?.orderTimes : 0}
        duration={isPlaying ? remain : duration || songData?.duration}
        highlighted={selected}
        expanded={selected}
        timeCreate={songData?.created_at}
        tone={songData?.tone}
        tone_price_rbt={songData?.tone_price}
        reason_refuse={songData?.reason_refuse}
        contentProvider={songData?.contentProvider?.name ?? ''}
        available_datetime={songData?.available_datetime}
        showInfo
        hideLike
        hideShare
        showExpandedInvited
        hideDownload
        showExpandedGift
        showExpandedDownload
        singerName={songData?.singer_name}
        composer={songData?.composer}
        isPlaying={isPlaying}
        showEq={isPlaying}
        animated={isPlaying}
        onPlayClick={onPlayClick}
      />
      {audio}
    </Box>
  );
};

export const RbtManagerBase = () => {


  const { data, loading, fetchMore } = useGetMyToneCreationsQuery({
    variables: { first: 10 },
  });
  const [selectedDownload, setSelectedDownload] = useState<RbtCreate | null>(null);

  const fetchMoreItem = useFetchMoreEdges(
    loading,
    'getMyToneCreations',
    fetchMore,
    data?.getMyToneCreations
  );

  const hasNextPage = data?.getMyToneCreations?.pageInfo?.hasNextPage;

  return (
    <Box bg="defaultBackground" my={4}>

      {(data?.getMyToneCreations?.edges ?? []).map((songData, idx) => {
        return (
          <Box my={1} mx={3} key={idx}>
            <TouchableOpacity
              onPress={() =>
                selectedDownload?.id === songData?.node?.id
                  ? setSelectedDownload(null)
                  : setSelectedDownload(songData?.node)
              }>
              <CollectionItem
                idx={idx + 1}
                songData={songData?.node}
                selected={songData?.node?.id === selectedDownload?.id}
                playedCallback={() => setSelectedDownload(songData?.node)}
              />
            </TouchableOpacity>
          </Box>
        )
      })}
      {
        (!data?.getMyToneCreations?.edges || data?.getMyToneCreations?.edges.length === 0) &&
        <Flex alignItems='center' flexDirection='column' width='100%' pt={4}>
          <Box>
            <Text
              fontSize={[2, 3, 4]}
              fontWeight='bold'
              color='primary'>
              Quý khách chưa có bài nhạc sáng tạo nào.
            </Text>
          </Box>
        </Flex>
      }
      {hasNextPage && (
        <Flex alignItems="center" flexDirection="column" width="100%" pt={1}>
          <Button variant="underline" onPress={fetchMoreItem}>
            Xem thêm
          </Button>
        </Flex>
      )}
    </Box>
  );
};

const RbtManagerScreen = () => {

  const navigatorProfile = useNavigationLink('/ca-nhan');
  const backAndStop = () => {
    navigatorProfile()
  }

  return (
    <Box bg="defaultBackground" height="100%">
      <Header leftButton="back" title="Quản lý nhạc chờ" leftButtonClick={backAndStop} />
      <ScrollView>
        <RbtManagerBase />
      </ScrollView>
    </Box>
  );
};
export default RbtManagerScreen;
