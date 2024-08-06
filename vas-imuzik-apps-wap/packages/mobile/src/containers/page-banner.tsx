import React, { useCallback } from 'react';
import { TouchableOpacity } from 'react-native';
import { Banner, Section } from '../components';
import { marketingLink } from '../helpers/marketing-link';
import { useVipBrandId } from '../hooks';
import { useGoBack } from '../platform/go-back';
import { NavLink, useAlert, useNavigationLink } from '../platform/links';
import { MyRbtDocument, MyRbtDownloadsDocument, useBannerPackagesQuery, useMeQuery, useMyRbtQuery, usePageBannerQuery, useRbtPackagesQuery, useRegisterRbtMutation } from '../queries';
import { Box, Text } from '../rebass';

const useContentType = (
  userPackage: { brandId: string; name: string; price: string; period: string },
  currentPackage: { brandId: string; name: string; price: string; period: string },
): [string, 'confirm' | 'cancel'] => {
  if (userPackage.brandId === '') {
    return [
      `Bạn có chắc muốn đăng ký sử dụng gói cước “${currentPackage.name.split("Gói ").pop()}” Giá cước ${currentPackage.price}, gia hạn hàng ${currentPackage.period}?`,
      'confirm',
    ];
  } else {
    if (userPackage.brandId === currentPackage.brandId) {
      return [`Bạn đang sử dụng gói cước \n“${currentPackage.name.split("Gói ").pop()}”, \ngiá cước ${userPackage.price} đồng/${userPackage.period}, \ngia hạn hàng ${currentPackage.period}`, 'cancel'];
    } else {
      return ['Để đăng ký, vui lòng hủy gói cước đang sử dụng.', 'cancel'];
    }
  }
};

export const BannerPackage = () => {
  const { data: meData } = useMeQuery();
  const { data } = useBannerPackagesQuery();
  // const lines = data?.bannerPackages?.[0]?.note?.split(/[\n\r]+/) ?? [];
  const lines = data?.bannerPackages?.[0];

  const [registerRbt, { loading }] = useRegisterRbtMutation({
    refetchQueries: [{ query: MyRbtDocument }, { query: MyRbtDownloadsDocument }],
  });
  const { data: packagesData } = useRbtPackagesQuery();
  const { brandId, name, price, period } =
    packagesData?.rbtPackages?.find((p) => p.brandId === lines?.brandId) ?? {};

  const dismiss = useGoBack();
  const showPopup = useAlert({ type: 'cancel', action: dismiss });
  const showPopupLogin = useAlert({ type: 'requireLogin' });
  const requireLogin = () => {
    showPopupLogin({ content: 'Vui lòng đăng nhập để sử dụng!' });
  };

  const { data: myRbtData } = useMyRbtQuery();
  const myPackage = packagesData?.rbtPackages?.find((p) => p.brandId === myRbtData?.myRbt?.brandId);

  const register = useCallback(() => {
    if (!meData?.me) return requireLogin?.();
    if (lines?.brandId) {
      if (myPackage && myPackage.brandId === lines?.brandId) {
        showPopup({ content: `Bạn đang sử dụng gói cước \n“${name?.split("Gói ").pop()}”, \ngiá cước ${price} đồng/${period}, \ngia hạn hàng ${period}` })
      } else {
        registerRbt({
          variables: {
            brandId: lines?.brandId,
          },
        }).then((res) => {
          if (res.data?.registerRbt.success) showPopup({ content: `Đăng kí “${name}” thành công!` });
          else
            showPopup({
              content: res.data?.registerRbt?.message ?? 'Hệ thống đang bận! Vui lòng thử lại sau!',
            });
        }).catch(err => {
          console.log(err);
        });
      }
    }
  }, [
    myPackage,
    registerRbt,
    showPopup,
    lines,
    name,
    period,
    price,
  ]);

  const [content, type] = useContentType(
    {
      brandId: myPackage?.brandId || '',
      name: myPackage?.name || '',
      price: myPackage?.price || '',
      period: myPackage?.period || '',
    },
    {
      brandId: brandId || '',
      name: name || '',
      price: price || '',
      period: period || '',
    }
  );

  const confirm = useNavigationLink('popup', {
    title: `Đăng ký ${name}`,
    type,
    content,
    action: register,
  });
  return (
    <Section mt={-60} mb={3}>
      <Box height={1} bg="white" mt={1} mb={1} />
      <TouchableOpacity onPress={meData?.me ? confirm : requireLogin}>
        <Box position='relative' >
          <Text color="white" fontSize={1} numberOfLines={1} >
            {lines?.name}
          </Text>
          <Text color="primary" fontSize={1} numberOfLines={2} >
            {lines?.note}
          </Text>
        </Box>
      </TouchableOpacity>
    </Section>
  )
};

export const PageBanner = ({
  page,
  slug,
  take,
}: {
  page: string;
  slug?: string;
  take?: number;
}) => {
  const { data } = usePageBannerQuery({ variables: { page, slug, first: take ?? 5 } });
  return (
    <Box>
      <Banner>
        {(data?.pageBanner?.edges ?? []).map(({ node }) => (
          <NavLink {...marketingLink(node.itemType, node.itemId)} key={node.id}>
            <Banner.Item image={node.fileUrl}>
              <Text fontWeight="bold" fontSize={3} color="white" numberOfLines={1}>
                {node.name}
              </Text>
              <Text fontWeight="bold" color="primary" fontSize={2} numberOfLines={1}>
                {node.alterText}
              </Text>
            </Banner.Item>
          </NavLink>
        ))}
      </Banner>
      <BannerPackage />
    </Box>
  );
};
