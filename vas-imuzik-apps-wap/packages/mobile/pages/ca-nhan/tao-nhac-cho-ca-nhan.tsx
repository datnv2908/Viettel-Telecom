import React from 'react';

import { withApollo } from '../../src/helpers/apollo';
import CreateRbtFromDeviceForWap from '../../src/screens/ProfileStack/CreateRbtFromDeviceForWap';

function CreateRbtFromDevicePage() {
  return <CreateRbtFromDeviceForWap />;
}
export default withApollo({ ssr: true })(CreateRbtFromDevicePage);
