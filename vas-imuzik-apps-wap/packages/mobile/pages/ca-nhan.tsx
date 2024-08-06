import React from 'react';
import { ActivityIndicator } from 'react-native';

import { Header, Icon, NotificationIcon } from '../src/components';
import { ConditionalGoVipButton } from '../src/containers';
import { withApollo } from '../src/helpers/apollo';
import { useNavigationLink } from '../src/platform/links';
import { useMeQuery } from '../src/queries';
import { Box, Button, Flex, Text } from '../src/rebass';
import { ManageSection, MemberSection } from '../src/screens/ProfileStack/ProfileScreen';

function UserPage() {
  const { data: meData, loading } = useMeQuery();
  const navigate = useNavigationLink('login');
  const toCreateRbt = useNavigationLink('/ca-nhan/tao-nhac-cho');

  return (
    <Box>
      {loading && <ActivityIndicator />}
      <Header logo search>
        <ConditionalGoVipButton />
        <NotificationIcon />
      </Header>
      <Box>
        <MemberSection showLogin={!loading && !meData?.me ? navigate : undefined} />
        <Button
          size="large"
          mx={3}
          variant="primary"
          mt={2}
          onPress={meData?.me ? toCreateRbt : navigate}>
          <Flex height={60} flexDirection="row" alignItems="center">
            <Icon name="ring-tone" size={20} color="gray" />
            <Text ml={2} fontSize={[3, 4, 5]} fontWeight="bold" color="gray">
              TỰ SÁNG TẠO NHẠC CHỜ
            </Text>
          </Flex>
        </Button>
        <ManageSection />
      </Box>
    </Box >
  );
}
export default withApollo()(UserPage);
