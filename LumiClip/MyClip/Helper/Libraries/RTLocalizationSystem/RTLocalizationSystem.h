//
//  RTLocalizationSystem.h
//  RTLocalizationSystem
//
//  Created by Đào Văn Nghiên on 7/17/20.
//  Copyright © 2020 Đào Văn Nghiên. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Return localiztion string
 * Example: RTLocalizeString(@"Hello", @"Hello!!")
 *
 * @param key the key of word in language
 * @param value if there is no match key or key is nil then it will return comment
 */
//#define RTLocalizeString(key, comment) \
//[[RTLocalizationSystem localizationSystem] localizeStringForKey:(key) value:(comment)]
//
///**
// * Set system's language
// */
//#define RTSetLanguage(lang) \
//[[RTLocalizationSystem localizationSystem] setLanguage:(lang) withNotify:(YES)]
//
///**
// * Get system's current language
// */
//#define RTGetLanguage \
//[[RTLocalizationSystem localizationSystem] getCurrentLanguage]
//
///**
// * Reset system
// */
//#define RTResetSystem \
//[[RTLocalizationSystem localizationSystem] resetSystem]

/**
 * Name of notification when system's language changed
 */
#define RTOnLanguageChanged \
@"RTOnLanguageChanged"

/**
 * The key in UserInfo in notification for the language user changed to
 * language changed notification
 */
#define RTNewLanguage \
@"RTNewLang"

/**
 * The key in UserInfo in notification for the language user changed from
 * language changed notification
 */
#define RTOldLanguage \
@"RTOldLang"

/**
 * When you set a new language it will post notification,
 * you can use NSNotificationCenter to observe it by give
 * notification marco RTOnLanguageChanged
 */
@interface RTLocalizationSystem : NSObject

/**
 * Return an instance of this localization system
 */
+ (RTLocalizationSystem *)localizationSystem;

/**
 * Return localized string for the key of language
 * It is recommend to use RTLocalizeString(key, comment)
 *
 * @param key the key of word in language
 * @param value if there is no match key or key is nil then it will return comment
 */
- (NSString *)localizeStringForKey:(NSString *)key value:(NSString *)comment;

/**
 * Set language
 */
- (void)setLanguage:(NSString *)lang withNotify:(BOOL)yesOrNo;

/**
 * Get current language
 */
- (NSString *)getCurrentLanguage;

/**
 * Reset system
 */
- (void)resetSystem;

+ (NSString *) rtLocalizeString: (NSString *)key comment: (NSString *) comment;

/**
 * Set system's language
 */
+ (void) rtSetLanguage:(NSString *) lang;

/**
 * Get system's current language
 */
+ (NSString *) rtGetLanguage;

/**
 * Reset system
 */
#define RTResetSystem \
[[RTLocalizationSystem localizationSystem] resetSystem]

@end
