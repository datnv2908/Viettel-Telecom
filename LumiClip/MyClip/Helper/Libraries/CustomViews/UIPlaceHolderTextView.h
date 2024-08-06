//
//  UIPlaceHolderTextView.h
//  MobiTV
//
//  Created by GEM on 5/18/16.
//  Copyright © 2016 GEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@property (nonatomic, retain) UILabel *placeHolderLabel;
@end
