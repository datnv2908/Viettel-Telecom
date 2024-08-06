import _ from 'lodash';
import React, { useMemo, useState } from 'react';
import { Box, Button, Flex } from 'rebass';
import { MarginProps } from 'styled-system';

import { Separator } from '../components';
import { usePlayer } from '../components/Player';
import { ChartSong, Song } from '../components/Song';
import { useCollection, useResponseHandler } from '../hooks';
import {
  LikeSongMutation,
  SongBaseFragment,
  Song as SongProps,
  SongConnectionBaseFragment,
  useLikeSongMutation,
} from '../queries';
import Download from './Download';
import Gift from './Gift';
import Share from './Share';

export const LoadingFooter = (props: { hasMore?: boolean }) => {
  return props.hasMore ? (
    <Flex alignItems="center" pt={3} pb={4}>
      {/* <ActivityIndicator /> */}
    </Flex>
  ) : (
    <Flex alignItems="center" pb={2} />
  );
};

export interface PlaylistProps extends MarginProps {
  name: string;
  songs?: { edges: { node: SongBaseFragment }[] } & SongConnectionBaseFragment;
  loading?: boolean;
  onRefresh?: () => void;
  onFetchMore?: () => void;
  isChart?: boolean;
  hideIdx?: boolean;
  columns?: number;
  showShare?: boolean;
}

function useCallbacks<T>(
  list: T[],
  keyFunc: (item: T) => string,
  factory: (item: T, idx: number) => () => void,
  input: React.DependencyList
) {
  return useMemo(
    () =>
      _.fromPairs(_.map(list ?? [], (item: T, idx: number) => [keyFunc(item), factory(item, idx)])),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [list, factory, keyFunc, ...input]
  );
}

export const Playlist = ({
  name,
  songs,
  loading,
  onRefresh,
  onFetchMore,
  isChart,
  hideIdx,
  columns = 1,
  showShare,
  ...marginProps
}: PlaylistProps) => {
  const player = usePlayer();
  const collection = useCollection(name, songs);
  const [likeSong] = useLikeSongMutation();
  const handleLikeSongResult = useResponseHandler<LikeSongMutation>((res) => res.data?.likeSong);
  const onPlayClick = useCallbacks(
    songs?.edges ?? [],
    (e) => e.node.id,
    ({ node: song }, idx) => () => {
      if (player?.currentPlayable?.sources?.[0] === song.fileUrl) player?.onPlayClicked();
      else {
        player?.playCollection(collection, idx);
      }
    },
    [player, collection]
  );
  const onLikeClick = useCallbacks(
    songs?.edges ?? [],
    (e) => e.node.id,
    ({ node: song }) => () => {
      likeSong({ variables: { songId: song.id, like: !song.liked } }).then(handleLikeSongResult);
    },
    [likeSong]
  );
  const [modalDownload, setOpenDownload] = useState(false);
  const [modalGift, setOpenGift] = useState(false);
  const [modalShare, setOpenShare] = useState(false);
  return (
    <Flex flexDirection="row" flexWrap="wrap" mb={50} mx={-3} {...marginProps}>
      {(songs?.edges ?? []).map(({ node: song }, idx) => (
        <Box key={song.id} width={1 / columns}>
          {columns <= 2 ? (
            <Box px={3}>
              <ChartSong
                slug={song.slug}
                image={song.imageUrl}
                title={song.name}
                artist={song.singers}
                download={song.downloadNumber}
                liked={song.liked}
                onPlayClick={onPlayClick[song.id]}
                onLikeClick={onLikeClick[song.id]}
                compact={columns === 2}
                onDownloadClick={() => setOpenDownload(true)}
                onGiftClick={() => setOpenGift(true)}
                onShareClick={() => setOpenShare(true)}
                showShare={showShare}
                {...(!hideIdx && { index: idx + 1 })}
              />
              <Separator />
              <Share
                isOpen={modalShare}
                onClose={() => setOpenShare(false)}
                slug={song.slug ?? ''}
              />
              <Download
                isOpen={modalDownload}
                onClose={() => setOpenDownload(false)}
                name={song?.name}
                toneCode={(song as SongProps)?.toneFromList?.toneCode}
                singer={song?.singers.map((s) => s.alias).join(' - ')}
              />
              <Gift
                isOpen={modalGift}
                onClose={() => setOpenGift(false)}
                name={song?.name}
                toneCode={(song as SongProps)?.toneFromList?.toneCode}
              />
            </Box>
          ) : (
            <Box px={3} pt={0} pb={4}>
              <Song
                slug={song.slug}
                image={song.imageUrl}
                title={song.name}
                artist={song.singers}
                download={song.downloadNumber}
                onPlayClick={onPlayClick[song.id]}
              />
            </Box>
          )}
        </Box>
      ))}
      {songs?.pageInfo?.hasNextPage && onFetchMore && (
        <Flex alignItems="center" flexDirection="column" width="100%" pt={5}>
          <Button variant="muted" onClick={onFetchMore}>
            Xem THÊM
          </Button>
        </Flex>
      )}
    </Flex>
  );
};
