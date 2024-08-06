import React from 'react';
import { Box, Flex } from 'rebass';

import { H2 } from '../components';
import { Section } from '../components/Section';
import { PageBanner } from '../containers';
import Footer from '../containers/Footer';
import Header from '../containers/Header';
import { Playlist } from '../containers/Playlist';
import { useFetchMoreEdges } from '../hooks';
import { useRecommendedSongsQuery } from '../queries';

export default function RecommendedSongsPage() {
  const { data, fetchMore, refetch, loading } = useRecommendedSongsQuery({
    variables: { first: 20 },
  });
  const fetchMoreSongs = useFetchMoreEdges(
    loading,
    'recommendedSongs',
    fetchMore,
    data?.recommendedSongs!
  );
  return (
    <Box>
      <Header.Fixed />
      <PageBanner page="de-xuat" />
      <Section>
        <H2>Đề xuất</H2>
      </Section>
      <Section>
        <Flex flexDirection="column">
          <Playlist
            songs={data?.recommendedSongs}
            loading={loading}
            name="Đề xuất"
            onRefresh={refetch}
            onFetchMore={fetchMoreSongs}
          />
        </Flex>
      </Section>
      <Footer />
    </Box>
  );
}
