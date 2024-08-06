import { Input } from '@rebass/forms';
import React, { FC, useState } from 'react';
import Modal from 'react-modal';
import { Box, Button, Flex, Text } from 'rebass';
import { useGiftRbtMutation } from '../queries';

const checkGiftNumber = (giftNumber: string): boolean => {
  // const vnf_regex = /((086|096|097|098|032|033|034|035|036|037|038|039)+([0-9]{7})\b)/g;
  const vnf_regex = /^(0|84|\\+84)[1-9]([0-9]{8})/g;
  return vnf_regex.test(giftNumber);
};

export const useGift = (
  giftNumber: string,
  songName?: string,
  toneCode?: string
): [string, 'confirm' | 'cancel'] => {
  return checkGiftNumber(giftNumber)
    ? [
        `Bạn đồng ý tặng bài nhạc chờ <${songName}>; mã số <${
          toneCode ?? ''
        }>; giá cước <3000đ> thời hạn sử dụng 30 ngày cho TB ${giftNumber}`,
        'confirm',
      ]
    : ['Số TB bạn nhập không đúng, vui lòng nhập lại số TB khác', 'cancel'];
};

interface GiftProps {
  isOpen: boolean;
  onClose: () => void;
  name?: string;
  toneCode?: string;
}

const Gift: FC<GiftProps> = ({ isOpen, onClose, name, toneCode }) => {
  const [giftNumber, setGiftNumber] = useState('');
  const [modalGift, setOpenGift] = useState(false);
  const [contentGift] = useGift(giftNumber, name, toneCode);
  const [giftRbt, { loading: giftLoading }] = useGiftRbtMutation();
  const onGift = () =>
    giftRbt({
      variables: { rbtCodes: [toneCode ?? ''], msisdn: giftNumber },
    }).then(({ data }) => {
      if (data?.giftRbt?.success) {
        setGiftNumber('');
      }
      alert(data?.giftRbt?.message);
      setOpenGift(false);
    });
  return (
    <>
      <Modal
        isOpen={isOpen}
        style={{
          overlay: {
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            backgroundColor: 'rgba(0, 0, 0, 0.75)',
            zIndex: 1000,
          },
          content: {
            position: 'absolute',
            top: '0px',
            left: '0px',
            right: '0px',
            bottom: '0px',
            border: 'none',
            background: 'transparent',
            overflow: 'auto',
            WebkitOverflowScrolling: 'touch',
            borderRadius: 'none',
            outline: 'none',
            padding: '0px',
          },
        }}>
        <Flex
          justifyContent="space-around"
          alignItems="center"
          height="100%"
          width="100%"
          css={{ position: 'relative' }}>
          <Box
            css={{
              position: 'absolute',
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
            }}
            onClick={onClose}
          />
          <Flex
            maxWidth="700px"
            maxHeight="250px"
            width="100%"
            height="100%"
            css={{ position: 'relative' }}
            bg="#121212"
            sx={{
              boxShadow: '0px 0px 20px #000000',
              borderRadius: 16,
            }}
            flexDirection="column"
            alignItems="center"
            justifyContent="center"
            px={57}
            py={37}>
            <Text
              color="white"
              fontSize="20px"
              lineHeight="24px"
              fontWeight="bold"
              textAlign="center">
              Nhập số thuê bao người nhận
            </Text>
            <Input
              value={giftNumber}
              onChange={(e) => setGiftNumber(e.target.value ?? '')}
              width={360}
              mt={16}
            />
            <Flex alignItems="center" mt={38}>
              <Button onClick={onClose} variant="clear" fontSize={20} lineHeight="24px" mr={32}>
                Bỏ qua
              </Button>
              <Button
                onClick={() => {
                  onClose();
                  setOpenGift(true);
                }}
                width={113}
                height={48}
                sx={{ borderRadius: 5 }}
                disabled={giftNumber.length !== 10}>
                Đồng ý
              </Button>
            </Flex>
          </Flex>
        </Flex>
      </Modal>
      <Modal
        isOpen={modalGift}
        style={{
          overlay: {
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            backgroundColor: 'rgba(0, 0, 0, 0.75)',
            zIndex: 1000,
          },
          content: {
            position: 'absolute',
            top: '0px',
            left: '0px',
            right: '0px',
            bottom: '0px',
            border: 'none',
            background: 'transparent',
            overflow: 'auto',
            WebkitOverflowScrolling: 'touch',
            borderRadius: 'none',
            outline: 'none',
            padding: '0px',
          },
        }}>
        <Flex
          justifyContent="space-around"
          alignItems="center"
          height="100%"
          width="100%"
          css={{ position: 'relative' }}>
          <Box
            css={{
              position: 'absolute',
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
            }}
            onClick={() => setOpenGift(false)}
          />
          <Flex
            maxWidth="700px"
            maxHeight="250px"
            width="100%"
            height="100%"
            css={{ position: 'relative' }}
            bg="#121212"
            sx={{
              boxShadow: '0px 0px 20px #000000',
              borderRadius: 16,
            }}
            flexDirection="column"
            alignItems="center"
            justifyContent="center"
            px={57}
            py={37}>
            <Text
              color="white"
              fontSize="20px"
              lineHeight="24px"
              fontWeight="bold"
              textAlign="center">
              {contentGift}
            </Text>
            <Flex alignItems="center" mt={27}>
              <Button
                onClick={() => setOpenGift(false)}
                variant="clear"
                fontSize={20}
                lineHeight="24px"
                mr={32}>
                Bỏ qua
              </Button>
              <Button
                disabled={giftLoading}
                onClick={() => onGift()}
                width={113}
                height={48}
                sx={{ borderRadius: 5 }}>
                Đồng ý
              </Button>
            </Flex>
          </Flex>
        </Flex>
      </Modal>
    </>
  );
};

export default Gift;
