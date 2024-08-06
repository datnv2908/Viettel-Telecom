import React from 'react';
import { SafeAreaView } from 'react-native';

import { Header, NotificationIcon, Section } from '../src/components';
import { ConditionalGoVipButton, ExploreTabs, PageBanner } from '../src/containers';
import { withApollo } from '../src/helpers/apollo';
import { Box } from '../src/rebass';
import { GenresSection } from '../src/screens/ExploreStack/ExploreScreen';

function GenresPage() {
  return (
    <SafeAreaView>
      <Box height="100%" position="relative">
        <Box position="fixed" top={0} left={0} right={0} zIndex={100}>
          <Header logo search>
            <ConditionalGoVipButton />
            <NotificationIcon />
          </Header>
        </Box>
        <PageBanner page="the-loai" />

        <Section bg="defaultBackground">
          <ExploreTabs currentTab="the-loai" />
        </Section>
        <GenresSection />
      </Box>
    </SafeAreaView>
  );
}

export default withApollo({ ssr: true })(GenresPage);
