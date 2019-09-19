//
//  Constants.h
//  Dominosa
//
//  Created by Anjona on 13-7-4.
//  Copyright (c) 2013年 Anjona. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS7() SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

// com.anjona.game.dominosa
#define GAMECENT_DOMINOSA_45 @"com.anjona.game.dominosa.4.5"
#define GAMECENT_DOMINOSA_56 @"com.anjona.game.dominosa.5.6"
#define GAMECENT_DOMINOSA_67 @"com.anjona.game.dominosa.6.7"
#define GAMECENT_DOMINOSA_78 @"com.anjona.game.dominosa.7.8"
#define GAMECENT_DOMINOSA_89 @"com.anjona.game.dominosa.8.9"
#define GAMECENT_DOMINOSA_910 @"com.anjona.game.dominosa.9.10"
#define GAMECENT_DOMINOSA_1011 @"com.anjona.game.dominosa.10.11"

#define KEY_ADMOB @"ca-app-pub-2437325967979488/7056485257"
#define KEY_ADMOB_INTERSTITIAL @"ca-app-pub-2437325967979488/8533218450"
#define KEY_URL @"https://itunes.apple.com/us/app/dominosa/id1267653720?ls=1&mt=8"
#define KEY_URL_REVIEW @"https://itunes.apple.com/us/app/dominosa/id1267653720?action=write-review&mt=8"
#define BUY_REMOVEAD @"com.anjona.game.dominosa.removead"
#define APP_REVIEW @"1267653720"

// afconvert -f caff -d LEI16 drop_card1.wav drop_card1.caf

#define KEY_GAME_TYPE @"KEY_GAME_TYPE"
#define KEY_SOUND @"KEY_SOUND"
#define KEY_ACTIVE @"KEY_ACTIVE"
#define KEY_REMOVEAD @"KEY_REMOVEAD"
#define KEY_REVIEW_COUNT @"KEY_REVIEW_COUNT"
#define KEY_TIME_COUNT @"KEY_TIME_COUNT"
#define KEY_CURRENT_PLAYING_GAME @"KEY_CURRENT_PLAYING_GAME"
#define KEY_GAME_HINT @"KEY_GAME_HINT"

#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define Device_Is_iPhoneXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define Device_Is_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_OS_103_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.3)
#define LIGHTBG [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1.0]
#define HINTCOLOR [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:0.75]
#endif
