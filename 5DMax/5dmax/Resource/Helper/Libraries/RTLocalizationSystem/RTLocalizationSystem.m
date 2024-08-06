//
//  RTLocalizationSystem.m
//  RTLocalizationSystem
//
//  Created by tomneo2004 on 2015/8/10.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "RTLocalizationSystem.h"

@interface RTLocalizationSystem ()

- (NSString *)getSettingFilePath;
- (BOOL)saveSettingFile;
- (NSString *)getDocumentsDirectory;

@end

@implementation RTLocalizationSystem{

    NSString *_currentLang;
    NSMutableDictionary *_setting;
}

//setting file name
static NSString *_rtSettingFileName = @"RTLocalizationSystemSetting";
static RTLocalizationSystem *_instance;
static NSBundle *_currentBundle;

#pragma mark - Get shared instance
+ (RTLocalizationSystem *)localizationSystem{

    /*GCD this has problem on freeze launch screen
    dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
    
        _instance = [[RTLocalizationSystem alloc] init];
    });
     */
    
    if(_instance == nil)
        _instance = [[RTLocalizationSystem alloc] init];
    
    return _instance;
}

#pragma mark - Init
- (id)init{
    
    self = [super init];
    
    if(self){
        
        //get main bundle
        _currentBundle = [NSBundle mainBundle];
        
        
        NSString *settingFilePath = [self getSettingFilePath];
        
        //if setting file exist in documents directory then we load it otherwise use pre-made one in main bundle;
        if(settingFilePath != nil){
        
            _setting = [[NSMutableDictionary alloc] initWithContentsOfFile:settingFilePath];
        }
        else{
        
            _setting = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_rtSettingFileName ofType:@"plist"]];
            
            //make one copy to documents directory
            [self saveSettingFile];
        }
        
        //set language
        [self setLanguage:[_setting objectForKey:@"language"] withNotify:NO];
    }
    
    return self;
}

+ (NSString *) rtLocalizeString: (NSString *)key comment: (NSString *) comment {
    return [[RTLocalizationSystem localizationSystem] localizeStringForKey:key value:comment];
}

+ (void) rtSetLanguage:(NSString *) lang
{
    [[RTLocalizationSystem localizationSystem] setLanguage:(lang) withNotify:(YES)];
}

+ (NSString *) rtGetLanguage {
   return [[RTLocalizationSystem localizationSystem] getCurrentLanguage];
}

#pragma mark - Get localized string
- (NSString *)localizeStringForKey:(NSString *)key value:(NSString *)comment{
    
    return [_currentBundle localizedStringForKey:key value:comment table:nil];
}

#pragma mark - Set language
- (void)setLanguage:(NSString *)lang withNotify:(BOOL)yesOrNo{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    
    NSString *oldLang = [self getCurrentLanguage];
    
    //if no match bundle use default language otherwise use custom set
    if(path == nil){
        
        [self resetSystem];
        
        [_setting setValue:[_setting objectForKey:@"default"] forKey:@"language"];
    }
    else{
        
        _currentBundle = [NSBundle bundleWithPath:path];
        
        [_setting setValue:lang forKey:@"language"];
    }
    
    //save setting
    [self saveSettingFile];
    

    if(!yesOrNo)
        return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:[self getCurrentLanguage] forKey:RTNewLanguage];
    [dic setValue:oldLang forKey:RTOldLanguage];
    
    //post notification about language changed
    [[NSNotificationCenter defaultCenter] postNotificationName:RTOnLanguageChanged object:nil userInfo:dic];

}

#pragma mark - Get current language
- (NSString *)getCurrentLanguage{
    
    return [_setting objectForKey:@"language"];
}

#pragma mark - Reset system
- (void)resetSystem{
    
    _currentBundle = [NSBundle mainBundle];
    
    [_setting setValue:[_setting objectForKey:@"default"] forKey:@"language"];
    
    [self saveSettingFile];
}

#pragma mark - Internal use
- (NSString *)getSettingFilePath{
    
    NSString *settingPlistPath = [[self getDocumentsDirectory] stringByAppendingPathComponent:[_rtSettingFileName stringByAppendingString:@".plist"]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:settingPlistPath]){
        
        return settingPlistPath;
    }
    else{
        
        return  nil;
    }
}

- (BOOL)saveSettingFile{

    return [_setting writeToFile:[[self getDocumentsDirectory] stringByAppendingPathComponent:[_rtSettingFileName stringByAppendingString:@".plist"]] atomically:NO];
}

- (NSString *)getDocumentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
