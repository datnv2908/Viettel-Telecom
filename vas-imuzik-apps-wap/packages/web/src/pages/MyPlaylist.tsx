import React from 'react';
import { Flex } from 'rebass';
import { useFetchMoreEdges } from '../hooks';
import { Playlist } from '../containers/Playlist';
import { useLikedSongQuery } from '../queries';
import { PersonalSplitView } from './PersonalInfo';

const MyPlaylistPage = () => {
  const { data, fetchMore, refetch, loading } = useLikedSongQuery({
    variables: { first: 20 },
  });
  const fetchMoreSongs = useFetchMoreEdges(loading, 'likedSongs', fetchMore, data?.likedSongs!);
  return (
    <PersonalSplitView title="My playlist">
      <Flex flexDirection="column">
        <Playlist
          showShare
          hideIdx={true}
          songs={data?.likedSongs}
          loading={loading}
          name="Đề xuất"
          onRefresh={refetch}
          onFetchMore={fetchMoreSongs}
        />
      </Flex>
    </PersonalSplitView>
  );
};

export default MyPlaylistPage;
