//
//  UIDevice+XLCategory.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/25.
//  Copyright © 2019 GDXL2012. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 模拟器
extern NSString *const XLDeviceSimulator;
// iPod
extern NSString *const XLDeviceiPod;
extern NSString *const XLDeviceiPod2;
extern NSString *const XLDeviceiPod3;
extern NSString *const XLDeviceiPod4;
extern NSString *const XLDeviceiPod5;
extern NSString *const XLDeviceiPod6;
extern NSString *const XLDeviceiPod7;
// iPad
extern NSString *const XLDeviceiPad;
extern NSString *const XLDeviceiPad2;
extern NSString *const XLDeviceiPad3;
extern NSString *const XLDeviceiPad4;
extern NSString *const XLDeviceiPad5;
extern NSString *const XLDeviceiPad6;
// iPadMini
extern NSString *const XLDeviceiPadMini;
extern NSString *const XLDeviceiPadMini2;
extern NSString *const XLDeviceiPadMini3;
extern NSString *const XLDeviceiPadMini4;
extern NSString *const XLDeviceiPadMini5;
// iPadAir
extern NSString *const XLDeviceiPadAir;
extern NSString *const XLDeviceiPadAir2;
extern NSString *const XLDeviceiPadAir3;
// iPadPro
extern NSString *const XLDeviceiPadPro_9inch;
extern NSString *const XLDeviceiPadPro_10inch;
extern NSString *const XLDeviceiPadPro_12inch;
extern NSString *const XLDeviceiPadPro2;
extern NSString *const XLDeviceiPadPro3_11inch;
extern NSString *const XLDeviceiPadPro3_12inch;
// AppleTV
extern NSString *const XLDeviceiTV2;
extern NSString *const XLDeviceiTV3;
extern NSString *const XLDeviceiTV4;
extern NSString *const XLDeviceiTV5;
// iPhone
extern NSString *const XLDeviceiPhone4;
extern NSString *const XLDeviceiPhone4S;
extern NSString *const XLDeviceiPhone5;
extern NSString *const XLDeviceiPhone5S;
extern NSString *const XLDeviceiPhone5C;
extern NSString *const XLDeviceiPhone6;
extern NSString *const XLDeviceiPhone6plus;
extern NSString *const XLDeviceiPhone6S;
extern NSString *const XLDeviceiPhone6Splus;
extern NSString *const XLDeviceiPhoneSE;
extern NSString *const XLDeviceiPhone7;
extern NSString *const XLDeviceiPhone7plus;
extern NSString *const XLDeviceiPhone8;
extern NSString *const XLDeviceiPhone8plus;
extern NSString *const XLDeviceiPhoneX;
extern NSString *const XLDeviceiPhoneXR;
extern NSString *const XLDeviceiPhoneXs;
extern NSString *const XLDeviceiPhoneXsMax;
extern NSString *const XLDeviceiPhone11;
extern NSString *const XLDeviceiPhone11Pro;
extern NSString *const XLDeviceiPhone11ProMax;
// 未匹配
extern NSString *const XLDeviceUnrecognized;

@interface UIDevice (XLCategory)

+(NSString *)deviceModel;
@end

NS_ASSUME_NONNULL_END
