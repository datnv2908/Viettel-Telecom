//
//  NSBundle+Language.m
//  MyClip
//
//  Created by Đào Văn Nghiên on 1/9/19.
//  Copyright © 2019 Huy Nguyen. All rights reserved.
//

#import "NSBundle+Language.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static const char kBundleKey = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    
    BOOL isLanguageRTL = [self isLanguageRTL:language];
    if (isLanguageRTL) {
        if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance] setSemanticContentAttribute:
             UISemanticContentAttributeForceRightToLeft];
        }
    }else {
        if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:isLanguageRTL forKey:@"AppleTextDirection"];
    [[NSUserDefaults standardUserDefaults] setBool:isLanguageRTL forKey:@"NSForceRightToLeftWritingDirection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isLanguageRTL:(NSString *)languageCode
{
    return ([NSLocale characterDirectionForLanguage:languageCode] == NSLocaleLanguageDirectionRightToLeft);
}


@end
