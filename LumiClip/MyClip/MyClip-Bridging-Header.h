//
//  MyClip-Bridging-Header.h
//  MyClip
//
//  Created by Os on 8/29/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

#ifndef MyClip_Bridging_Header_h
#define MyClip_Bridging_Header_h

#define isIphoneX MAX([UIScreen mainScreen].nativeBounds.size.width, [UIScreen mainScreen].nativeBounds.size.height) >= 2436

#import "TYTabPagerView.h"
#import "TYTabPagerController.h"
#import "FWDraggableManager.h"
#import "MyCustomPlayer.h"
#import "RSKGrowingTextView.h"
#import "UIPlaceHolderTextView.h"
#import "NSBundle+Language.h"
#import "RTLocalizationSystem.h"

#endif /* MyClip_Bridging_Header_h */
