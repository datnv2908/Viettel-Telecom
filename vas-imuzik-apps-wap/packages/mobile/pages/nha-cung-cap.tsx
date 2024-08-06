import React from 'react';
import { SafeAreaView } from 'react-native';

import { Header, NotificationIcon, Section } from '../src/components';
import { ConditionalGoVipButton, PageBanner } from '../src/containers';
import { ExploreTabs } from '../src/containers/explore-tabs';
import { withApollo } from '../src/helpers/apollo';
import { Box } from '../src/rebass';
import { ContentProvidersSection } from '../src/screens/ExploreStack/ExploreScreen';

function ContentProvidersPage() {
  return (
    <SafeAreaView>
      <Box height="100%" position="relative">
        <Box position="fixed" top={0} left={0} right={0} zIndex={100}>
          <Header logo search>
            <ConditionalGoVipButton />
            <NotificationIcon />
          </Header>
        </Box>
        <PageBanner page="nha-cung-cap" />

        <Section bg="defaultBackground">
          <ExploreTabs currentTab="nha-cung-cap" />
        </Section>
        <ContentProvidersSection />
      </Box>
    </SafeAreaView>
  );
}

export default withApollo({ ssr: true })(ContentProvidersPage);
