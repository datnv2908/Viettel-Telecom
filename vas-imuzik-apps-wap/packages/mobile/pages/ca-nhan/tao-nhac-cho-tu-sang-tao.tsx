import React from 'react';

import { withApollo } from '../../src/helpers/apollo';
import CreateRbtFromUserForWap from '../../src/screens/ProfileStack/CreateRbtFromUserForWap';

function CreateRbtFromUserPage() {
  return <CreateRbtFromUserForWap />;
}
export default withApollo({ ssr: true })(CreateRbtFromUserPage);
