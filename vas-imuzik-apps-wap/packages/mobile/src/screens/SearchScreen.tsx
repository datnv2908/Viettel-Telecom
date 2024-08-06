import React, { useEffect, useMemo } from 'react';
import { ActivityIndicator, FlatList, Image, TouchableOpacity } from 'react-native';

import { ChartSong, Header, HeaderClose, InputWithButton, Separator } from '../components';
import { LoadingFooter } from '../containers';
import { marketingLink } from '../helpers/marketing-link';
import { useFetchMoreEdges } from '../hooks';
import { ModalBox } from '../platform/ModalBox';
import { NavLink, useAlert } from '../platform/links';
import { useHotKeywordsQuery, useRecordKeywordMutation, useSearchQuery } from '../queries';
import { Box, Flex, Text } from '../rebass';
import { ChartSongCreate } from './ProfileStack/CreateRbtFromLibrary';

const SearchItem = (props: { name: string; image?: string | null }) => {
  return (
    <Box flexDirection="row" alignItems="center" py={3}>
      {
        props.image ? (
          <Image source={{ uri: props.image }} style={{ width: 44, height: 44 }} resizeMode="cover" />
        ) : (
          <Image
            source={
              require('../../assets/icon.png')
            }
            style={{ width: 44, height: 44 }}
          />
        )
      }
      <Flex flexDirection="column" ml={2} flex={1}>
        <Text color="normalText" fontWeight="bold" fontSize={2} numberOfLines={1}>
          {props.name}
        </Text>
      </Flex>
    </Box>
  );
};

export enum NodeType {
  User = 'USER',
  Cp = 'CP',
  Genre = 'GENRE',
  Rbt = 'RBT',
  Singer = 'SINGER',
  Song = 'SONG',
  Topic = 'TOPIC'
}
export const SearchScreen = () => {
  const [query, setQuery] = React.useState('');
  const [queryInput, setQueryInput] = React.useState('');
  useEffect(() => {
    // only change query if there is no typing within 500ms
    const timeout = setTimeout(() => {
      setQuery(queryInput);
    }, 500);
    return () => {
      clearTimeout(timeout);
    };
  }, [queryInput]);

  const showPopup = useAlert({ type: 'cancel1stack' });

  const checkVadidate = (inputValue: any) => {
    if (inputValue.length <= 255) {
      setQueryInput(inputValue)
    } else {
      showPopup({ content: 'Quá 255 ký tự. Xin vui lòng thử lại!' });
      setQueryInput('');
    }
  }

  const { data, loading, fetchMore, refetch } = useSearchQuery({ variables: { query, first: 10, } });

  // console.log({ data });

  const { data: hotKeywordData } = useHotKeywordsQuery();
  // const sortData = (data?.search.edges!).sort((a,b) => (a?.node?.__typename && b?.node?.__typename ? (a?.node?.__typename - b?.node?.__typename)  ) ? 1 : ((b.last_nom > a.last_nom) ? -1 : 0))

  const [recordKeyword] = useRecordKeywordMutation();
  const onFetchMore = useFetchMoreEdges(loading, 'search', fetchMore, data?.search);
  const filteredEdges = useMemo(() => (data?.search.edges ?? []).filter((e) => e.node), [
    data?.search.edges,
  ]);

  return (
    <ModalBox px={3}>
      <Header title="Tìm kiếm">
        <HeaderClose />
      </Header>
      <InputWithButton
        value={queryInput}
        onChangeText={(e) => checkVadidate(e)}
        iconColor="inputClose"
        placeholder="Nhập tên bài hát"
        iconSize={16}
        onPress={() => setQueryInput('')}
      />
      {
        loading ? (
          <Box flexDirection='row' alignItems='center' justifyContent='center'>
            <Text textAlign="center" color="lightText" py={4}>
              Đang tìm kiếm
            </Text>
            <ActivityIndicator size='small' />
          </Box>
        ) : (
          (!query) || data?.search?.totalCount === 0 ? (
            <Box>
              {data?.search?.totalCount === 0 && !!query && (
                <Text textAlign="center" color="lightText" p={4} mt={2}>
                  Không tìm thấy kết quả nào!
                </Text>
              )}
            </Box>
          ) : (
            <>
              <Text color="primary" fontWeight="bold" my={3} fontSize={3}>
                Kết quả tìm kiếm “{queryInput}”
              </Text>
              <FlatList
                data={filteredEdges}
                ListFooterComponent={
                  <LoadingFooter hasMore={data?.search?.pageInfo.hasNextPage || loading} />
                }
                initialNumToRender={10}
                onEndReachedThreshold={0.2}
                refreshing={loading}
                onRefresh={refetch}
                onEndReached={onFetchMore}
                keyExtractor={({ node }, idx) => node?.id ?? `${idx}`}
                renderItem={({ item: { node } }) => {

                  const name =
                    node?.__typename === 'Song'
                      ? node?.name
                      : node?.__typename === 'Genre'
                        ? node?.name
                        : node?.__typename === 'Singer'
                          ? node?.alias
                          : '';
                  const image =
                    node?.__typename === 'Song'
                      ? node?.imageUrl
                      : node?.__typename === 'Genre'
                        ? node?.imageUrl
                        : node?.__typename === 'Singer'
                          ? node?.imageUrl
                          : '';

                  return (
                    <Box>
                      {node?.__typename === 'Song' && (
                        <NavLink key={node.id} route="/bai-hat/[slug]" params={{ slug: node.slug }}>
                          <Box py={2}>
                            <ChartSongCreate
                              id={node.id}
                              slug={node.slug}
                              title={node.name}
                              image={image}
                              artist={node.singers.map((s) => s.alias).join(' - ')}
                            />
                          </Box>
                        </NavLink>
                      )}
                      {
                        node?.__typename === 'Singer' && image && name ? (
                          <NavLink key={node.id} route="/ca-sy/[slug]" params={{ slug: node.slug }}>
                            <SearchItem image={image} name={name} />
                          </NavLink>
                        ) : undefined
                      }
                      {
                        node?.__typename === 'Genre' && image && name ? (
                          <NavLink key={node.id} route="/the-loai/[slug" params={{ slug: node.slug }}>
                            <SearchItem image={image} name={name} />
                          </NavLink>
                        ) : undefined
                      }
                      <Separator />
                    </Box>
                  );
                }}
              />
            </>
          )
        )
      }
    </ModalBox>
  );
};
