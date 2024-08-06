import { useRoute } from '@react-navigation/native';
import { Audio, AVPlaybackStatus } from 'expo-av';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import { ActivityIndicator, Dimensions, Platform, TouchableOpacity } from 'react-native';
import { Header, Section } from '../../components';
import { Icon } from '../../components/svg-icon';
import { VipInfo } from '../../components/VipInfo';
import { useVipBrandId } from '../../hooks';
import { useGoBack } from '../../platform/go-back';
import { useAlert, useNavigationLink } from '../../platform/links';
import { ModalBox } from '../../platform/ModalBox';
import { LinearGradient } from 'expo-linear-gradient';
import {
    GetMyToneCreationDocument,
    GetMyToneCreationsDocument3,
    MyRbtDocument,
    MyRbtDownloadsDocument,
    useCreateRbtComposedByUserMutation,
    useCreateRbtUnavailableMutation,
    useMeQuery,
    useMyRbtQuery,
    useRbtPackagesQuery,
    useRegisterRbtMutation,
} from '../../queries';
import { Box, Button, Flex, Text } from '../../rebass';
import Trimmer from '../../components/Trimmer';

const maxTrimDuration = 45000;
const minimumTrimDuration = 30000;

const initialLeftHandlePosition = 0;
const initialRightHandlePosition = 30000;

export const TrimmerScreenWap = (props: {
    uri?: string,
    duration?: string,
    name?: string,
    composer?: string,
    singerName?: string,
    songName?: string,
    type?: string
}) => {
    const [totalDurationAudio, setTotalDurationAudio] = useState(Number(props.duration));
    const [uploadFile, setUploadFile] = useState<File | null>(null);

    const soundObj = useRef(new Audio.Sound());
    const [isPlay, setIsPlay] = useState(false);
    const [trimmerLeftHandlePosition, setTrimmerLeftHandlePosition] =
        useState(initialLeftHandlePosition);
    const [trimmerRightHandlePosition, setTrimmerRightHandlePosition] = useState(
        initialRightHandlePosition
    );

    const [scrubberPosition, setScrubberPosition] = useState(0);

    const { width, height } = Dimensions.get('window');

    async function dataUrlToFile(dataUrl: string, fileName: string): Promise<File> {

        const res: Response = await window.fetch(dataUrl);
        const blob: Blob = await res.blob();
        return new File([blob], fileName, { type: 'audio/mpeg' });
    }

    useEffect(() => {
        if (props.uri && props.name) {
            Promise.all([dataUrlToFile(props.uri, props.name)]).then(data => {
                setUploadFile(data[0])
            })
        }
    }, [props.uri, props.name,])

    // @ts-ignore
    const onHandleChange = ({ leftPosition, rightPosition }) => {
        setTrimmerLeftHandlePosition(leftPosition);
        setTrimmerRightHandlePosition(rightPosition);
    };

    const onProgress = useCallback(

        (status: AVPlaybackStatus) => {
            if (soundObj) {
                if (status?.isLoaded) {
                    setIsPlay(status.isPlaying);
                    setScrubberPosition(status.positionMillis);
                    if (status.didJustFinish) {
                        soundObj.current.setOnPlaybackStatusUpdate(null);
                    }
                }
            }
        },
        [soundObj]
    );
    useEffect(() => {
        if (soundObj) {
            soundObj.current.setOnPlaybackStatusUpdate(onProgress);
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [soundObj]);

    const doPlay = async () => {
        setIsPlay(true);
        setScrubberPosition(trimmerLeftHandlePosition);

        try {
            if (props.uri) {
                await soundObj.current.loadAsync({ uri: props.uri });
                await soundObj.current.getStatusAsync().then((e) => {
                    if (Platform.OS !== 'web') {
                        if (e.isLoaded) {
                            setTotalDurationAudio(e.durationMillis ?? 255000);
                        }
                    }
                });
                await soundObj.current.setPositionAsync(trimmerLeftHandlePosition);

                await soundObj.current.playAsync();
            }
        } catch (error) {
            console.log(error);
        }

    };

    const doPause = async () => {
        setIsPlay(false);
        setScrubberPosition(trimmerLeftHandlePosition);
        try {
            await soundObj.current.stopAsync();
            await soundObj.current.unloadAsync();
        } catch (error) {
            console.log(error);
        }
    };

    // eslint-disable-next-line react-hooks/exhaustive-deps
    async function handleBreak() {
        try {
            await soundObj.current.stopAsync();
            await soundObj.current.unloadAsync();
        } catch (error) {
            console.log(error);
        }
    }
    useEffect(() => {
        if (scrubberPosition > trimmerRightHandlePosition) {
            setIsPlay(false);
            handleBreak();
        }
    }, [
        scrubberPosition,
        trimmerRightHandlePosition,
        trimmerLeftHandlePosition,
        soundObj,
        handleBreak,
    ]);

    const navigationToCreateRbtFromDevice = useNavigationLink(props.type === 'online' ? '/ca-nhan/tao-nhac-cho-co-san' : props.type === 'offline' ? '/ca-nhan/tao-nhac-cho-ca-nhan' : '/ca-nhan/tao-nhac-cho-tu-sang-tao');
    const backAndStop = () => {
        setTrimmerLeftHandlePosition(initialLeftHandlePosition);
        setTrimmerRightHandlePosition(initialRightHandlePosition);
        navigationToCreateRbtFromDevice();
        handleBreak();
    };

    const showPopup = useAlert({ type: 'create-rbt' });
    const errorPopup = useAlert({ type: 'cancel1stack' });

    const convertMinsToTime = (time: number) => {
        let minutes = Math.floor(time / 60);
        let s: string | number = time % 60;
        s = s < 10 ? '0' + s : s;
        return `${minutes}:${s}`;
    }

    const [createRbtUnavailable, { loading: createLoadingRbtUnavailable }] = useCreateRbtUnavailableMutation();

    const [createRbtComposedByUser, { loading: createLoadingComposedByUser }] = useCreateRbtComposedByUserMutation({
        refetchQueries: [{ query: GetMyToneCreationsDocument3 }, { query: GetMyToneCreationDocument }]
    });

    const actionRbt = () => {
        handleBreak();
        if (props.composer && props.singerName && props.songName) {
            if (props.type === 'offline') {

                if (Platform.OS === 'web') {
                    console.log('tretet');

                    createRbtUnavailable({
                        variables: {
                            composer: props.composer,
                            singerName: props.singerName,
                            songName: props.songName,
                            time_start: (trimmerLeftHandlePosition / 1000).toString(),
                            time_stop: (trimmerRightHandlePosition / 1000).toString(),
                            file: uploadFile,
                        },
                    })
                        .then((res) => {
                            if (res.data?.createRbtUnavailable.success) {
                                showPopup({
                                    content: res.data.createRbtUnavailable.result?.tone_code ?? '',
                                });
                            } else {
                                errorPopup({ content: res.data?.createRbtUnavailable.message ?? 'Hệ thống bận!' });
                            }
                        })
                        .catch((e) => {
                            console.log(e);
                            errorPopup({ content: ' Hệ thống bận!' });
                        });
                }
            } else if (props.type === 'user') {

                if (Platform.OS === 'web') {
                    createRbtComposedByUser({
                        variables: {
                            composer: props.composer,
                            singerName: props.singerName,
                            songName: props.songName,
                            time_start: (trimmerLeftHandlePosition / 1000).toString(),
                            time_stop: (trimmerRightHandlePosition / 1000).toString(),
                            file: uploadFile,
                        },
                    })
                        .then((res) => {
                            if (res.data?.createRbtComposedByUser.success) {
                                showPopup({
                                    content: res.data.createRbtComposedByUser.result?.tone_code ?? '',
                                });
                            } else {
                                errorPopup({ content: res.data?.createRbtComposedByUser.errorCode == '400042' ? 'Bài hát đã tồn tại trên hệ thống!' : "Hệ thống bận!" });
                            }
                        })
                        .catch((e) => {
                            errorPopup({ content: 'Hệ thống bận!' });
                        });
                }
            }
        }
    }

    return (
        <ModalBox>
            <Box bg="defaultBackground" position="relative" flex={1}>
                <Header leftButton="back" title="Chọn đoạn nhạc" leftButtonClick={backAndStop} />
                <Box bg="defaultBackground" flex={1} marginBottom={3} justifyContent="space-between">

                    {props?.uri && totalDurationAudio ? (
                        <>
                            <Text mt={20} mx={3} textAlign="center" fontSize={3} fontWeight="bold" color="normalText">
                                {props.songName ? props.songName : props.name}
                            </Text>
                            <Box mt={2} height='100%' >
                                <Box alignItems="center" justifyContent="space-around" flexDirection="row" mb={3}>
                                    <Text fontSize={[3, 4, 5]} fontWeight="bold" color="normalText">
                                        {convertMinsToTime(Math.floor(trimmerLeftHandlePosition / 1000))}
                                    </Text>
                                    <Text fontSize={[3, 4, 5]} fontWeight="bold" color="normalText">
                                        {convertMinsToTime(Math.floor(trimmerRightHandlePosition / 1000))}
                                    </Text>
                                </Box>

                                <Trimmer
                                    // @ts-ignore
                                    onHandleChange={onHandleChange}
                                    totalDuration={totalDurationAudio}
                                    trimmerLeftHandlePosition={trimmerLeftHandlePosition}
                                    trimmerRightHandlePosition={trimmerRightHandlePosition}
                                    minimumTrimDuration={minimumTrimDuration}
                                    maxTrimDuration={maxTrimDuration}
                                    maximumZoomLevel={5}
                                    zoomMultiplier={20}
                                    initialZoomValue={2}
                                    scaleInOnInit={true}
                                    tintColor="rgba(56, 239, 125, 125)"
                                    markerColor="#FCCC26"
                                    trackBackgroundColor="#262523"
                                    trackBorderColor="#5a3d5c"
                                    scrubberColor="#b7e778"
                                    scrubberPosition={scrubberPosition}
                                    onLeftHandlePressIn={doPause}
                                    onRightHandlePressIn={doPause}
                                    onScrubberPressIn={() => console.log('onScrubberPressIn')}
                                />

                                <Box alignItems="center" justifyContent="space-between" height='45%'>
                                    <Text mt={3}>Thời gian tối đa của nhạc chuông là 45 giây </Text>
                                    <TouchableOpacity onPress={isPlay ? doPause : doPlay}>
                                        <LinearGradient
                                            colors={['#38EF7D', '#11998E']}
                                            start={[0, 0]}
                                            end={[1, 1]}
                                            style={{
                                                width: height < 600 ? 70 : 80,
                                                height: height < 600 ? 70 : 80,
                                                borderRadius: height < 600 ? 35 : 40,
                                                alignItems: 'center',
                                                justifyContent: 'center',
                                            }}>
                                            {isPlay ? (
                                                <Icon name="player-pause" size={25} color="white" />
                                            ) : (
                                                <Icon name="player-play" size={25} color="white" />
                                            )}
                                        </LinearGradient>
                                    </TouchableOpacity>
                                    <Box width={"100%"}>
                                        <LinearGradient
                                            colors={['#38EF7D', '#11998E']}
                                            start={[0, 0]}
                                            end={[1, 1]}
                                            style={{ borderRadius: 12, marginHorizontal: 15, marginVertical: height < 600 ? 5 : 10 }}
                                        >
                                            <TouchableOpacity
                                                style={{
                                                    height: 50,
                                                    flexDirection: 'row',
                                                    width: '100%',
                                                    borderRadius: 8,
                                                    alignItems: 'center',
                                                    justifyContent: 'center'
                                                }}
                                                onPress={actionRbt}
                                                disabled={createLoadingRbtUnavailable || createLoadingComposedByUser}
                                            >

                                                {createLoadingRbtUnavailable || createLoadingComposedByUser ? (
                                                    <Box flex={1} alignItems="center" justifyContent="center">
                                                        <ActivityIndicator size="large" color="white" />
                                                    </Box>
                                                ) : (
                                                    <Text fontWeight={700}>LƯU NHẠC CHỜ</Text>
                                                )}

                                            </TouchableOpacity>
                                        </LinearGradient>
                                    </Box>
                                </Box>
                            </Box>
                        </>
                    ) : undefined}

                </Box>
            </Box>
        </ModalBox>
    );
};

const TrimmerDelay = () => {
    return (
        <Box style={{ alignItems: 'center', justifyContent: 'center', }}>
            <Text textAlign="center" color="lightText" py={4}>
                Đang tải dữ liệu
            </Text>
            <ActivityIndicator size='large' />
        </Box>
    )
}