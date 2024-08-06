//
//  UIApplication+AppDimensions.h
//  MobiTV
//
//  Created by GEM on 7/13/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppDimensions)

+(CGSize) currentSize;
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;
@end
