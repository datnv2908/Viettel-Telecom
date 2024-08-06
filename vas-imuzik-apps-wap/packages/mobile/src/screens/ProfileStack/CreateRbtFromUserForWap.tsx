import React, { useState, useRef, useContext, useEffect } from 'react';

import { AnimatedEq, HeaderClose, Icon, IconName, ICON_GRADIENT_1, InputWithButton } from '../../components';
import { withApollo } from '../../helpers/apollo';
import { Box, Button, Flex, ButtonProps, Text } from '../../rebass';
import * as DocumentPicker from 'expo-document-picker';
import { NavLink, useAlert, useNavigationLink } from '../../platform/links';
import { LinearGradient } from 'expo-linear-gradient';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { Dimensions, Image, TouchableOpacity, View, Platform, SafeAreaView, KeyboardAvoidingView, ScrollView } from 'react-native';
import { Audio } from 'expo-av';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useFocusEffect } from '@react-navigation/native';



function CreateRbtFromDevice() {
    const [doc, setDoc] = useState({ name: '', size: '', uri: '' });
    const [isPlay, setIsPlay] = useState(false);
    const soundObj = useRef(new Audio.Sound());
    const [isChooseAudio, setIsChooseAudio] = useState(false);
    const [errorSongName, setErrorSongName] = useState('')
    const [errorSingerName, setErrorSingerName] = useState('')
    const [errorComposer, setErrorComposer] = useState('')
    const [duration, setDuration] = useState<number>()
    const [data, setData] = React.useState({
        songName: '',
        singerName: '',
        composer: '',
        check_textInputChange: false,
        isValidsongName: false,
        isValidsingerName: false,
        isValidcomposer: false,
    });

    const errorPopup = useAlert({ type: 'cancel1stack' });
    const pickDocument = async () => {

        await DocumentPicker.getDocumentAsync({
            type: 'audio/mp3',
            copyToCacheDirectory: false,
        }).then((response: any) => {
            if (formatBytes(response.size) >= 5) {
                errorPopup({ content: 'Bài hát đăng tải có dung lượng nhỏ hơn 5MB!' ?? 'Hệ thống bận!' });
            } else {
                if (response.type === 'success') {
                    if (Platform.OS === 'web') {
                        let audio = new window.Audio(URL.createObjectURL(response.file));

                        audio.addEventListener('loadedmetadata', (e: any) => {
                            const duration = Math.round(e.target.duration * 1000)
                            let { name, size, uri } = response;
                            setDuration(duration);
                            // const file_audio = {
                            //     duration: duration,
                            //     name: name,
                            //     uri: uri
                            // }
                            let nameParts = name.split('.');
                            let fileType = nameParts[nameParts.length - 1];
                            if (fileType !== 'mp3') {
                                errorPopup({ content: `Bài hát phải có định dạng Mp3` ?? 'Hệ thống bận!' });
                            } else {
                                // storeData(file_audio);
                                checkDurationMillisForWeb(fileType, name, size, uri, duration)
                            }
                        })
                    }

                }
            }
        });

    };


    const storeData = async (value: any) => {
        const jsonValue = JSON.stringify(value)
        await AsyncStorage.setItem('@storage_Key', jsonValue)
    }

    const formatBytes = (bytes: number, decimals = 2): number => {
        if (bytes === 0) return 0;

        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ["Bytes", "KB", "MB", "GB", "TB", "PB"];
        const i = Math.floor(Math.log(bytes) / Math.log(k));

        if (sizes[i] == 'KB') return parseFloat(((bytes / Math.pow(k, i)).toFixed(dm)) + " " + sizes[i]) / 1024

        return (
            parseFloat(((bytes / Math.pow(k, i)).toFixed(dm)) + " " + sizes[i])
        );
    }
    const checkDurationMillisForWeb = async (type?: any, name?: any, size?: any, uri?: any, duration?: any) => {
        if (duration) {
            const minute = Math.floor((duration) / 60000) * 60;
            const second = (duration % 60000 / 1000);
            const totalSecond = minute + second;

            const kbit = size / 128;//calculate bytes to kbit
            const kbps = Math.ceil(Math.round(kbit / totalSecond) / 16) * 16;

            if (totalSecond < 30) {
                errorPopup({ content: 'Thời lượng của bài hát quá ngắn, vui lòng chọn bài nhiều hơn 30 giây' });
            } else if (kbps < 128 || kbps > 128) {
                errorPopup({ content: 'Chỉ tải lên file nhạc 128kpbs' });
            } else {
                let fileToUpload = {
                    name: name,
                    size: size,
                    uri: uri,
                    type: 'application/' + type,
                };
                setDoc(fileToUpload);
                setIsChooseAudio(true);
            }
        }
    }

    const doPlay = async () => {
        setIsPlay(true)
        try {
            await soundObj.current.loadAsync({ uri: doc.uri }, { isLooping: true, shouldPlay: true });
            await soundObj.current.playAsync();
        } catch (error) {
            console.log(error);
        }
    }

    const doPause = async () => {
        setIsPlay(false);
        try {
            await soundObj.current.stopAsync();
            await soundObj.current.unloadAsync();
        } catch (error) {
            console.log(error);
        }
    };

    const ChartSongAction = (props: { icon: IconName; onPress?: () => void }) => {
        return (
            <TouchableOpacity onPress={props.onPress}>
                <Flex flexDirection="column" alignItems="center" p={2}>
                    <Icon name={props.icon} size={20} />
                </Flex>
            </TouchableOpacity>
        );
    };

    const textInputChangesongName = (val?: any) => {

        const specialChars = /^[a-zA-Z0-9| _]+$/;
        if (val.trim().length >= 6 && val.trim().length <= 100 && specialChars.test(val)) {
            setErrorSongName('')
            setData({
                ...data,
                songName: val,
                isValidsongName: true
            });
        } else if (val.trim().length === 0) {
            setErrorSongName('')
            setData({
                ...data,
                songName: val,
                isValidsongName: false
            });
        } else {
            setErrorSongName('Tên bài hát cho phép nhập kí tự chữ và số. Độ dài 6-100 ký tự. Không cho phép nhập Tiếng Việt có dấu và ký tự đặc biệt.')
            setData({
                ...data,
                songName: val,
                isValidsongName: false
            });
        }
    }

    const textInputChangesingerName = (val?: any) => {
        const specialChars = /^[a-zA-Z0-9| _]+$/;
        if (val.trim().length >= 2 && val.trim().length <= 100 && specialChars.test(val)) {
            setErrorSingerName('')
            setData({
                ...data,
                singerName: val,
                isValidsingerName: true
            });
        } else if (val.trim().length === 0) {
            setErrorSingerName('')
            setData({
                ...data,
                singerName: val,
                isValidsingerName: false
            });
        } else {
            setErrorSingerName('Tên ca sĩ cho phép nhập kí tự chữ và số. Độ dài 2-100 ký tự. Không cho phép nhập Tiếng Việt có dấu và ký tự đặc biệt.')
            setData({
                ...data,
                singerName: val,
                isValidsingerName: false
            });
        }
    }

    const textInputChangecomposer = (val?: any) => {
        const specialChars = /^[a-zA-Z0-9| _]+$/;
        if (val.trim().length >= 2 && val.trim().length <= 100 && specialChars.test(val)) {
            setErrorComposer('')
            setData({
                ...data,
                composer: val,
                isValidcomposer: true
            });
        } else if (val.trim().length === 0) {
            setErrorComposer('')
            setData({
                ...data,
                composer: val,
                isValidcomposer: false
            });
        } else {
            setErrorComposer('Tên nhạc sĩ cho phép nhập kí tự chữ và số. Độ dài 2-100 ký tự. Không cho phép nhập Tiếng Việt có dấu và ký tự đặc biệt.')
            setData({
                ...data,
                composer: val,
                isValidcomposer: false
            });
        }
    }

    const navigationToCreateRbtFromDevice = useNavigationLink('/ca-nhan/tao-nhac-cho');
    const backAndStop = () => {
        navigationToCreateRbtFromDevice();
    }

    return (
        <KeyboardAwareScrollView
            // enableOnAndroid={true}
            contentContainerStyle={{ paddingHorizontal: 15, flexGrow: 1, }}
            bounces={false}
            showsVerticalScrollIndicator={false}>
            <Flex flexDirection="row" justifyContent="flex-end">
                <HeaderClose leftButtonClick={backAndStop} />
            </Flex>
            <Flex>
                <Flex flexDirection="row" alignItems="center" >
                    <Icon name="file-upload" size={50} color={ICON_GRADIENT_1} />
                    <Text ml={2} fontSize={20} fontWeight="bold" >
                        Tạo nhạc chờ {'\n'}từ Đăng tải bài hát
                    </Text>
                </Flex>
                <Flex >
                    <Text fontSize={14} mt={2} fontWeight="bold" >
                        Upload bài hát bạn muốn tạo nhạc chờ {'\n'}(định dạng mp3, 128kbps)
                    </Text>
                    <Button variant="secondary1" size={'largest'} mt={2} onPress={pickDocument}>
                        CHỌN BÀI HÁT
                    </Button>
                </Flex>
            </Flex>
            <Flex>
                {doc?.uri ? (
                    <Flex
                        borderRadius={8}
                        bg="rgba(0, 0, 0, 0.4)"
                        css={{
                            overflow: 'hidden',
                        }}
                        mt={2}>
                        <Flex
                            borderRadius={8}
                            flexDirection="row"
                            alignItems="center"
                            px={3}
                            height={64}
                            pl={0}
                            css={{
                                height: 80,
                                overflow: 'hidden',
                                position: 'relative',
                            }}
                        >
                            {isChooseAudio ? (
                                <Flex ml={1} mr={1} width={25} alignItems="center">
                                    <AnimatedEq size={14} animated={isPlay} />
                                </Flex>
                            ) : (
                                <Box ml={1} mr={1} width={25} alignItems="center">
                                    <Text fontSize={2} color="lightText">

                                    </Text>
                                </Box>
                            )}

                            <Flex flex={1} alignItems="center" flexDirection="row">
                                <Flex
                                    borderRadius={20}
                                    justifyContent="center"
                                    alignItems="center"
                                    mr={3}>
                                    <Logo />
                                </Flex>
                                <Flex flex={4}>
                                    <Text
                                        fontSize={14}
                                        width={0.95}
                                        numberOfLines={1}
                                        fontWeight={700}
                                    // color="#FFFFFF"
                                    >
                                        {doc.name}
                                    </Text>
                                    <Text fontSize={[2, 3, 4]} color="#B2B2B2">
                                        Không tên
                                    </Text>
                                </Flex>
                            </Flex>
                            <Flex alignItems="center">
                                {!isChooseAudio ? (
                                    <View style={{
                                        paddingRight: -25,
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        height: 40,
                                        width: 40,
                                    }}>
                                    </View>
                                ) : (
                                    <ChartSongAction
                                        icon={isPlay ? 'player-pause' : 'player-play'}
                                        onPress={isPlay ? doPause : doPlay}
                                    />
                                )}
                            </Flex>
                        </Flex>
                    </Flex>

                ) : undefined
                }
            </Flex>
            <Flex
                mt={2}
                mb={1}
                flexDirection="row"
                alignItems="center"
                borderBottomColor="tabBar">
                <InputWithButton
                    maxLength={100}
                    gradient
                    border={false}
                    value={data.songName}
                    onChangeText={(val) => textInputChangesongName(val)}
                    placeholder="Tên bài hát *"
                    placeholderTextColor="#848484"
                    flex={1}
                />
            </Flex>
            {
                errorSongName ? (
                    <Text fontSize={12} mt={1} color='red'>
                        {errorSongName}
                    </Text>
                ) : undefined
            }
            <Flex
                mt={2}
                mb={1}
                flexDirection="row"
                alignItems="center"
                borderBottomColor="tabBar">
                <InputWithButton
                    maxLength={100}
                    gradient
                    border={false}
                    value={data.singerName}
                    onChangeText={(val) => textInputChangesingerName(val)}
                    placeholder="Tên ca sỹ *"
                    placeholderTextColor="#848484"
                    flex={1}
                />
            </Flex>
            {
                errorSingerName ? (
                    <Text fontSize={12} mt={1} color='red'>
                        {errorSingerName}
                    </Text>
                ) : undefined
            }
            <Flex
                mt={2}
                mb={1}
                flexDirection="row"
                alignItems="center"
                borderBottomColor="tabBar">
                <InputWithButton
                    maxLength={100}
                    gradient
                    border={false}
                    value={data.composer}
                    onChangeText={(val) => textInputChangecomposer(val)}
                    placeholder="Tên nhạc sỹ *"
                    placeholderTextColor="#848484"
                    flex={1}
                />
            </Flex>
            {errorComposer ? (
                <Text fontSize={12} mt={1} color='red' mb={2}>
                    {errorComposer}
                </Text>
            ) : undefined}
            <Flex
                // alignItems="right" // Error on mobile app
                flex={1}
            >
            </Flex>
            {
                !doc?.uri || !data.isValidsongName || !data.isValidsingerName || !data.isValidcomposer ? (
                    <Flex
                        borderRadius={8}
                        bg="rgba(0, 0, 0, 0.4)"
                        css={{
                            overflow: 'hidden',
                        }}
                        height={55}
                    >
                        <Flex
                            borderRadius={8}
                            flexDirection="row"
                            alignItems="center"
                            justifyContent="center"
                            px={3}
                            height={55}
                            pl={0}
                            css={{
                                height: 65,
                                overflow: 'hidden',
                                position: 'relative',
                            }}
                        >
                            <Icon name="file-upload" size={17} color="inputClose" />
                            <Text ml={2} fontSize={17} fontWeight="bold" color="inputClose">
                                ĐĂNG TẢI BÀI HÁT
                            </Text>
                        </Flex>
                    </Flex>
                ) : (
                    <UploadingButton
                        uri={doc.uri}
                        duration={duration ?? 0}
                        name={doc.name}
                        songName={data.songName}
                        singerName={data.singerName}
                        composer={data.composer}
                    />
                )}
            <Flex
                alignItems="center"
                mt={3}
            // mt="10vh" // Error on mobile app
            >
            </Flex>
            {/* </Flex> */}
        </KeyboardAwareScrollView>
    );
}

export const Logo = () => {
    return (
        <Image
            resizeMode="cover"
            source={
                require('../../../assets/logo-music.png')
            }
            style={{ width: 40, height: 40 }}
        />
    );
};

export const UploadingButton = (props: { _props?: ButtonProps, uri: string, duration: number, name: string, songName: string, singerName: string, composer: string }) => {
    const showTrimmer = useNavigationLink('trimmer', {
        uri: props.uri,
        duration: props.duration + '',
        name: props.name,
        songName: props.songName,
        singerName: props.singerName,
        composer: props.composer,
        type: 'user'
    });

    return (
        <>
            <TouchableOpacity onPress={showTrimmer}>
                <Flex
                    height={55}
                    borderRadius={8}
                    flexDirection="row"
                    alignItems="center"
                    justifyContent="center"
                    backgroundColor="#FDCC26"
                >
                    <Icon name="file-upload" size={17} color="gray" />
                    <Text ml={2} fontSize={17} fontWeight="bold" color="gray">
                        ĐĂNG TẢI BÀI HÁT
                    </Text>
                </Flex>
            </TouchableOpacity>
        </>
    );
};

export default CreateRbtFromDevice;
