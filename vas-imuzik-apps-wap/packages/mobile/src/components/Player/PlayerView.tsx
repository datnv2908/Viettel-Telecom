import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  Animated,
  Dimensions,
  GestureResponderEvent,
  Image,
  PanResponder,
  Platform,
  TouchableOpacity,
  TouchableWithoutFeedback,
} from 'react-native';
import { useTheme } from 'styled-components/native';
import { BackgroundColorProps } from 'styled-system';

import { useNavigationLink } from '../../platform/links';
import { Box, Flex, Text } from '../../rebass';
import { Icon, IconName } from '../svg-icon';
import { PlayerControl, usePlayer, usePlayerTime } from './Provider';
import { CircleAvatar } from '../Animation';
import GestureRecognizer from 'react-native-swipe-gestures';

const PlayerViewAction = (props: { icon: IconName; onPress?: () => void; enabled: boolean }) => {
  return (
    <TouchableOpacity onPress={props.enabled ? props.onPress : undefined} disabled={!props.enabled}>
      <Flex flexDirection="column" alignItems="center" p={2}>
        <Icon name={props.icon} size={20} color={props.enabled ? 'normalText' : 'lightText'} />
      </Flex>
    </TouchableOpacity>
  );
};

export const SeekBar = (props: { height?: number }) => {
  const playerTime = usePlayerTime();
  const player = usePlayer();
  const onPressSeekBar = useCallback(
    (e: GestureResponderEvent) => {
      if (playerTime?.duration) {
        const screenWidth = Math.round(Dimensions.get('window').width) || 500;
        const padding = 15;
        const seekBarWidth = screenWidth - 2 * padding;
        player.onSeek((e.nativeEvent.pageX - padding) / seekBarWidth);
      }
    },
    [player, playerTime?.duration]
  );
  const height = props.height ?? 2;
  if (!playerTime || !PlayerView) return null;
  return (
    <TouchableWithoutFeedback onPress={onPressSeekBar}>
      <Flex py={2}>
        <Flex position="relative" height={14} justifyContent="center">
          <Box
            height={height}
            borderRadius={2}
            bg='playerSeekBar'
            overflow="hidden"
            position="relative"
            my={2}
            width="100%">
            <Box
              height={height}
              position="absolute"
              style={{ width: `${(playerTime.playedRatio ?? 0) * 100}%` }}
              bg={playerTime.duration ? 'secondary' : 'transparent'}
            />
          </Box>
          <Box
            height={14}
            width={14}
            top={0}
            borderRadius={7}
            overflow="hidden"
            position="absolute"
            style={{ left: `${(playerTime.playedRatio ?? 0) * 100}%`, marginLeft: -7 }}
            bg={playerTime.duration ? 'playerCue' : 'transparent'}
          />
        </Flex>
      </Flex>
    </TouchableWithoutFeedback>
  );
};

export const SeekBarPlayBox = (props: { height?: number, pan: any }) => {
  const playerTime = usePlayerTime();
  const player = usePlayer();
  const onPressSeekBar = useCallback(
    (e: GestureResponderEvent) => {
      if (playerTime?.duration) {
        const screenWidth = Math.round(Dimensions.get('window').width) || 500;
        const padding = 15;
        const seekBarWidth = screenWidth - 2 * padding;
        player!.onSeek((e.nativeEvent.pageX - padding) / seekBarWidth);
      }
    },
    [player, playerTime?.duration]
  );
  const height = props.height ?? 2;
  if (!playerTime || !PlayerView) return null;
  return (
    <Animated.View style={{
      transform: [{ translateX: props.pan ? props.pan.x : 0 }],
    }}>
      <TouchableWithoutFeedback onPress={onPressSeekBar} >
        <Flex p={2} bg="tabBar"
          px={3}
          pb={2} borderBottomWidth={1} borderBottomColor={"tabBar"}>
          <Flex position="relative" height={14} justifyContent="center">
            <Box
              height={height}
              borderRadius={2}
              bg='playerSeekBar'
              overflow="hidden"
              position="relative"
              my={2}
              width="100%">
              <Box
                height={height}
                position="absolute"
                style={{ width: `${(playerTime.playedRatio ?? 0) * 100}%` }}
                bg={playerTime.duration ? 'secondary' : 'transparent'}
              />
            </Box>
            <Box
              height={14}
              width={14}
              top={0}
              borderRadius={7}
              overflow="hidden"
              position="absolute"
              style={{ left: `${(playerTime.playedRatio ?? 0) * 100}%`, marginLeft: -7 }}
              bg={playerTime.duration ? 'playerCue' : 'transparent'}
            />
          </Flex>
        </Flex>
      </TouchableWithoutFeedback>
    </Animated.View>
  );
};

const { width: screenWidth } = Dimensions.get('window');
export const PlayerView = () => {
  const player = usePlayer();
  const theme = useTheme();
  const showPlayerModal = useNavigationLink('player');
  const pan = useRef(new Animated.ValueXY()).current;

  const panResponder = useMemo(
    () => PanResponder.create({
      onMoveShouldSetPanResponder: (_, gestureState) => {
        //@ts-ignore
        const { dx, dy } = gestureState
        return (dx > 2 || dx < -2 || dy > 2 || dy < -2)
      },

      onMoveShouldSetPanResponderCapture: (_, gestureState) => {
        const { dx, dy } = gestureState
        return (dx > 2 || dx < -2 || dy > 2 || dy < -2)
      },
      onPanResponderMove: Animated.event([null, { dx: pan.x }], { useNativeDriver: false }),
      onPanResponderRelease: () => {
        //@ts-ignore
        if (Math.abs(pan.x._value) > 150) {
          //@ts-ignore
          Animated.spring(pan, {
            //@ts-ignore
            toValue: { x: pan.x._value < 0 ? -  (screenWidth) : (screenWidth), y: 0 },
            useNativeDriver: false,
          }).start(async ({ finished }) => {
            if (finished) {
              if (player.isPlaying) {
                player.onPlayClicked();
                player.onCloseClicked();
              } else {
                player.onCloseClicked();
              }
            }
          });
        } else {
          //@ts-ignore
          Animated.spring(pan, { toValue: { x: 0, y: 0 }, useNativeDriver: false }).start();
        }
      },
    }),
    [player]
  );

  useEffect(() => {
    if (player.isPlaying) {
      pan.setValue({ x: 0, y: 0 })
    }
  }, [player])
  if (!player) return null;
  if (!(player.hasNext || player.hasPrev || player.currentPlayable)) return null

  return (
    <Flex
      borderBottomColor={theme.colors.tabBarSeparator}
      borderBottomWidth={1}>
      <SeekBarPlayBox pan={pan} />
      <Animated.View
        style={{
          transform: [{ translateX: pan.x }],
        }}
        {...panResponder.panHandlers}>

        <TouchableWithoutFeedback onPress={() => {
          showPlayerModal()
        }}>
          <Flex flexDirection="row" bg="tabBar"
            px={3}
            pb={2}>
            <Flex flex={1} alignItems="center" flexDirection="row" >
              <Flex
                bg="#C4C4C4"
                overflow="hidden"
                position="relative"
                borderRadius={20}
                justifyContent="center"
                alignItems="center"
                width={40}
                height={40}>
                {!!player.currentPlayable?.image && (
                  <CircleAvatar imageUri={player.currentPlayable?.image ?? 'https://source.unsplash.com/random/512x512'} />
                )}
              </Flex>
              <Flex flexDirection="column" ml={3} flex={1}>
                <Text color="normalText" fontSize={2} numberOfLines={1}>
                  {player.currentPlayable?.title}
                </Text>
                <Text color="lightText" fontSize={1} fontWeight="bold" numberOfLines={1}>
                  {player.currentPlayable?.artist}
                </Text>
              </Flex>
            </Flex>

            <Flex alignItems="center" flexDirection="row">
              <PlayerViewAction
                icon="player-prev"
                onPress={player.onPrevClicked}
                enabled={player.hasPrev}
              />
              {player.isPlaying ? (
                <PlayerViewAction
                  icon="player-pause"
                  onPress={player.onPlayClicked}
                  enabled={!!player.currentPlayable}
                />
              ) : (
                <PlayerViewAction
                  icon="player-play"
                  onPress={player.onPlayClicked}
                  enabled={player.hasNext || !!player.currentPlayable}
                />
              )}
              <PlayerViewAction
                icon="player-next"
                onPress={player.onNextClicked}
                enabled={player.hasNext}
              />
            </Flex>
          </Flex>
        </TouchableWithoutFeedback>

      </Animated.View>
    </Flex >
  );
};

export const PlayerViewPadding = (props: BackgroundColorProps) => {
  const player = usePlayer();
  if (!player || !(player.hasNext || player.hasPrev || player.currentPlayable)) return null;
  return <Box height={84} {...props} />;
};
