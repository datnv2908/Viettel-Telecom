import { createStackNavigator } from '@react-navigation/stack';
import React from 'react';

import MyPlaylistScreen from './MyPlaylistScreen';
import MyRbtScreen from './MyRbtScreen';
import PackagesScreen from './PackagesScreen';
import ProfileScreen from './ProfileScreen';
import RbtGroupScreen from './RbtGroupScreen';
import RbtGroupsScreen from './RbtGroupsScreen';
import HelpCenterScreen from './HelpCenterScreen';
import HelpCenterDetails from './HelpCenterDetails';
import PersonalInformation from './PersonalInformation';
import ChangePassword from './ChangePassword';
import EditPersonalInformation from './EditPersonalInformation';
import ContentProviderScreen from '../ExploreStack/ContentProviderScreen';
import SongScreen from '../HomeStack/SongScreen';
import CreateRbtScreen from './CreateRbtScreen';
import CreateRbtFromLibrary from './CreateRbtFromLibrary';
import CreateRbtFromDevice from './CreateRbtFromDevice';
import RbtManagerScreen from './RbtManagerScreen';
import CreateRbtFromUser from './CreateRbtFromUser';

const ProfileStack = createStackNavigator();

export const ProfileStackScreen = () => (
  <ProfileStack.Navigator screenOptions={{ headerShown: false }}>
    <ProfileStack.Screen name="/ca-nhan" component={ProfileScreen} />
    <ProfileStack.Screen name="/ca-nhan/goi-cuoc" component={PackagesScreen} />
    <ProfileStack.Screen name="/ca-nhan/nhac-cho" component={MyRbtScreen} />
    <ProfileStack.Screen name="/ca-nhan/my-playlist" component={MyPlaylistScreen} />
    <ProfileStack.Screen name="/ca-nhan/nhac-cho-nhom" component={RbtGroupsScreen} />
    <ProfileStack.Screen name="/ca-nhan/nhac-cho-nhom/[groupId]" component={RbtGroupScreen} />
    <ProfileStack.Screen name="/ca-nhan/thong-tin" component={PersonalInformation} />
    <ProfileStack.Screen name="/huong-dan" component={HelpCenterScreen} />
    <ProfileStack.Screen name="/huong-dan/[slug]" component={HelpCenterDetails} />
    <ProfileStack.Screen name="/ca-nhan/thong-tin/doi-mat-khau" component={ChangePassword} />
    <ProfileStack.Screen name="/chinh-sua-thong-tin" component={EditPersonalInformation} />
    <ProfileStack.Screen name="/nha-cung-cap/[group]" component={ContentProviderScreen} />
    <ProfileStack.Screen name="/bai-hat/[slug]" component={SongScreen} />
    <ProfileStack.Screen name="/ca-nhan/tao-nhac-cho" component={CreateRbtScreen} />
    <ProfileStack.Screen name="/ca-nhan/tao-nhac-cho-co-san" component={CreateRbtFromLibrary} />
    <ProfileStack.Screen name="/ca-nhan/tao-nhac-cho-ca-nhan" component={CreateRbtFromDevice} />
    <ProfileStack.Screen name="/ca-nhan/tao-nhac-cho-tu-sang-tao" component={CreateRbtFromUser} />
    <ProfileStack.Screen name="/ca-nhan/quan-ly-nhac-cho" component={RbtManagerScreen} />
  </ProfileStack.Navigator>
);
