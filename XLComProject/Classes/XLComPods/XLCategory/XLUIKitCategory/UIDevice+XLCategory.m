//
//  UIDevice+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/25.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIDevice+XLCategory.h"
#import "sys/utsname.h"
#import "NSString+XLCategory.h"

NSString *const XLDeviceSimulator   = @"Simulator";   // 模拟器

NSString *const XLDeviceiPod        = @"iPod";
NSString *const XLDeviceiPod2       = @"iPod2";
NSString *const XLDeviceiPod3       = @"iPod3";
NSString *const XLDeviceiPod4       = @"iPod4";
NSString *const XLDeviceiPod5       = @"iPod5";
NSString *const XLDeviceiPod6       = @"iPod6";
NSString *const XLDeviceiPod7       = @"iPod7";

NSString *const XLDeviceiPad        = @"iPad";
NSString *const XLDeviceiPad2       = @"iPad2";
NSString *const XLDeviceiPad3       = @"iPad3";
NSString *const XLDeviceiPad4       = @"iPad4";
NSString *const XLDeviceiPad5       = @"iPad5";
NSString *const XLDeviceiPad6       = @"iPad6";

NSString *const XLDeviceiPadMini    = @"iPad Mini";
NSString *const XLDeviceiPadMini2   = @"iPad Mini Retina";
NSString *const XLDeviceiPadMini3   = @"iPad Mini 3";
NSString *const XLDeviceiPadMini4   = @"iPad Mini 4";
NSString *const XLDeviceiPadMini5   = @"iPad Mini 5";

NSString *const XLDeviceiPadAir     = @"iPad Air";
NSString *const XLDeviceiPadAir2    = @"iPad Air 2";
NSString *const XLDeviceiPadAir3    = @"iPad Air 3";

NSString *const XLDeviceiPadPro_9inch    = @"iPad Pro 9.7-inch";
NSString *const XLDeviceiPadPro_10inch   = @"iPad Pro 10.5-inch";
NSString *const XLDeviceiPadPro_12inch   = @"iPad Pro 12.9-inch";
NSString *const XLDeviceiPadPro2         = @"iPad Pro 2nd";
NSString *const XLDeviceiPadPro3_11inch  = @"iPad Pro 3rd 11-inch";
NSString *const XLDeviceiPadPro3_12inch  = @"iPad Pro 3rd 12.9-inch";

NSString *const XLDeviceiTV2        = @"Apple TV 2";
NSString *const XLDeviceiTV3        = @"Apple TV 3";
NSString *const XLDeviceiTV4        = @"Apple TV 4";
NSString *const XLDeviceiTV5        = @"Apple TV 5";

NSString *const XLDeviceiPhone4         = @"iPhone 4";
NSString *const XLDeviceiPhone4S        = @"iPhone 4S";
NSString *const XLDeviceiPhone5         = @"iPhone 5";
NSString *const XLDeviceiPhone5S        = @"iPhone 5S";
NSString *const XLDeviceiPhone5C        = @"iPhone 5C";
NSString *const XLDeviceiPhone6         = @"iPhone 6";
NSString *const XLDeviceiPhone6plus     = @"iPhone 6 Plus";
NSString *const XLDeviceiPhone6S        = @"iPhone 6S";
NSString *const XLDeviceiPhone6Splus    = @"iPhone 6S Plus";
NSString *const XLDeviceiPhoneSE        = @"iPhone SE";
NSString *const XLDeviceiPhone7         = @"iPhone 7";
NSString *const XLDeviceiPhone7plus     = @"iPhone 7 Plus";
NSString *const XLDeviceiPhone8         = @"iPhone 8";
NSString *const XLDeviceiPhone8plus     = @"iPhone 8 Plus";
NSString *const XLDeviceiPhoneX         = @"iPhone X";
NSString *const XLDeviceiPhoneXR        = @"iPhone XR";
NSString *const XLDeviceiPhoneXs        = @"iPhone Xs";
NSString *const XLDeviceiPhoneXsMax     = @"iPhone Xs Max";
NSString *const XLDeviceiPhone11        = @"iPhone 11";
NSString *const XLDeviceiPhone11Pro     = @"iPhone 11 Pro";
NSString *const XLDeviceiPhone11ProMax  = @"iPhone 11 Pro Max";

NSString *const XLDeviceUnrecognized    = @"?unrecognized?";

@implementation UIDevice (XLCategory)
+ (NSString *)deviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    static NSDictionary* deviceNamesByCode = nil;
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"i386"   : XLDeviceSimulator,
                              @"x86_64" : XLDeviceSimulator,
                              
                              @"iPod1,1" : XLDeviceiPod,
                              @"iPod2,1" : XLDeviceiPod2,
                              @"iPod3,1" : XLDeviceiPod3,
                              @"iPod4,1" : XLDeviceiPod4,
                              @"iPod5,1" : XLDeviceiPod5,
                              @"iPod7,1" : XLDeviceiPod6,
                              @"iPod9,1" : XLDeviceiPod7,
                              
                              @"iPad1,1" : XLDeviceiPad,
                              @"iPad1,2" : XLDeviceiPad,
                              @"iPad2,1" : XLDeviceiPad2,
                              @"iPad2,2" : XLDeviceiPad2,
                              @"iPad2,3" : XLDeviceiPad2,
                              @"iPad2,4" : XLDeviceiPad2,
                              
                              @"iPad2,5" : XLDeviceiPadMini,
                              @"iPad2,6" : XLDeviceiPadMini,
                              @"iPad2,7" : XLDeviceiPadMini,
                              
                              @"iPad3,1" : XLDeviceiPad3,
                              @"iPad3,2" : XLDeviceiPad3,
                              @"iPad3,3" : XLDeviceiPad3,
                              
                              @"iPad3,4" : XLDeviceiPad4,
                              @"iPad3,5" : XLDeviceiPad4,
                              @"iPad3,6" : XLDeviceiPad4,
                              
                              @"iPad4,1" : XLDeviceiPadAir,
                              @"iPad4,2" : XLDeviceiPadAir,
                              @"iPad4,3" : XLDeviceiPadAir,
                              
                              @"iPad4,4" : XLDeviceiPadMini2,
                              @"iPad4,5" : XLDeviceiPadMini2,
                              @"iPad4,6" : XLDeviceiPadMini2,
                              
                              @"iPad4,7" : XLDeviceiPadMini3,
                              @"iPad4,8" : XLDeviceiPadMini3,
                              @"iPad4,9" : XLDeviceiPadMini3,
                              
                              @"iPad5,1" : XLDeviceiPadMini4,
                              @"iPad5,2" : XLDeviceiPadMini4,
                              
                              @"iPad5,3" : XLDeviceiPadAir2,
                              @"iPad5,4" : XLDeviceiPadAir2,
                              
                              @"iPad6,3" : XLDeviceiPadPro_9inch,
                              @"iPad6,4" : XLDeviceiPadPro_9inch,
                              
                              @"iPad6,7" : XLDeviceiPadPro_12inch,
                              @"iPad6,8" : XLDeviceiPadPro_12inch,
                              
                              @"iPad6,11" : XLDeviceiPad5,
                              @"iPad6,12" : XLDeviceiPad5,
                              
                              @"iPad7,1" : XLDeviceiPadPro2,
                              @"iPad7,2" : XLDeviceiPadPro2,
                              
                              @"iPad7,3" : XLDeviceiPadPro_10inch,
                              @"iPad7,4" : XLDeviceiPadPro_10inch,
                              
                              @"iPad7,5" : XLDeviceiPad6,
                              @"iPad7,6" : XLDeviceiPad6,
                              
                              @"iPad8,1" : XLDeviceiPadPro3_11inch,
                              @"iPad8,2" : XLDeviceiPadPro3_11inch,
                              @"iPad8,3" : XLDeviceiPadPro3_11inch,
                              @"iPad8,4" : XLDeviceiPadPro3_11inch,
                              
                              @"iPad8,5" : XLDeviceiPadPro3_12inch,
                              @"iPad8,6" : XLDeviceiPadPro3_12inch,
                              @"iPad8,7" : XLDeviceiPadPro3_12inch,
                              @"iPad8,8" : XLDeviceiPadPro3_12inch,
                              
                              /// Apple TV
                              @"AppleTV2,1" : XLDeviceiTV2,
                              @"AppleTV3,1" : XLDeviceiTV3,
                              @"AppleTV3,2" : XLDeviceiTV4,
                              @"AppleTV5,3" : XLDeviceiTV5,
                              
                              // iPhone
                              @"iPhone3,1" : XLDeviceiPhone4,
                              @"iPhone3,2" : XLDeviceiPhone4,
                              @"iPhone3,3" : XLDeviceiPhone4,
                              
                              @"iPhone4,1" : XLDeviceiPhone4S,
                              
                              @"iPhone5,1" : XLDeviceiPhone5,
                              @"iPhone5,2" : XLDeviceiPhone5,
                              
                              @"iPhone5,3" : XLDeviceiPhone5C,
                              @"iPhone5,4" : XLDeviceiPhone5C,
                              
                              @"iPhone6,1" : XLDeviceiPhone5S,
                              @"iPhone6,2" : XLDeviceiPhone5S,
                              
                              @"iPhone7,1" : XLDeviceiPhone6plus,
                              @"iPhone7,2" : XLDeviceiPhone6,
                              
                              @"iPhone8,1" : XLDeviceiPhone6S,
                              @"iPhone8,2" : XLDeviceiPhone6Splus,
                              
                              @"iPhone8,4" : XLDeviceiPhoneSE,
                              
                              @"iPhone9,1" : XLDeviceiPhone7,
                              @"iPhone9,3" : XLDeviceiPhone7,
                              
                              @"iPhone9,2" : XLDeviceiPhone7plus,
                              @"iPhone9,4" : XLDeviceiPhone7plus,
                              
                              @"iPhone10,1" : XLDeviceiPhone8,
                              @"iPhone10,4" : XLDeviceiPhone8,
                              
                              @"iPhone10,2" : XLDeviceiPhone8plus,
                              @"iPhone10,5" : XLDeviceiPhone8plus,
                              
                              @"iPhone10,3" : XLDeviceiPhoneX,
                              @"iPhone10,6" : XLDeviceiPhoneX,
                              
                              @"iPhone11,8" : XLDeviceiPhoneXR,

                              @"iPhone11,2" : XLDeviceiPhoneXs,
                              
                              @"iPhone11,4" : XLDeviceiPhoneXsMax,
                              @"iPhone11,6" : XLDeviceiPhoneXsMax,
                              @"iPhone12,1" : XLDeviceiPhone11,
                              @"iPhone12,3" : XLDeviceiPhone11Pro,
                              @"iPhone12,5" : XLDeviceiPhone11ProMax,
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if(![NSString isEmpty:deviceName]){
        return deviceName;
    }
    
    return XLDeviceUnrecognized;
}
@end
