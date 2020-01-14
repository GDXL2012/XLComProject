//
//  XLSystemMacro.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLSystemMacro_h
#define XLSystemMacro_h
#import <UIKit/UIKit.h>

// 系统版本号
#define XLSysVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

#define XLiOS7   ((XLSysVersion >= 7.0)  && (XLSysVersion < 8.0))
#define XLiOS8   ((XLSysVersion >= 8.0)  && (XLSysVersion < 9.0))
#define XLiOS9   ((XLSysVersion >= 9.0)  && (XLSysVersion < 10.0))
#define XLiOS10  ((XLSysVersion >= 10.0) && (XLSysVersion < 11.0))
#define XLiOS11  ((XLSysVersion >= 11.0) && (XLSysVersion < 12.0))
#define XLiOS12  ((XLSysVersion >= 12.0) && (XLSysVersion < 13.0))
#define XLiOS13  ((XLSysVersion >= 13.0) && (XLSysVersion < 14.0))
#define XLiOS14  ((XLSysVersion >= 14.0) && (XLSysVersion < 15.0))

#define XLAvailableiOS13    @available(iOS 13.0, *) // iOS 13
#define XLAvailableiOS12    @available(iOS 12.0, *) // iOS 12
#define XLAvailableiOS11    @available(iOS 11.0, *) // iOS 11
#define XLAvailableiOS10    @available(iOS 10.0, *) // iOS 10

#define XLAboveiOS7         (XLSysVersion >= 7.0)    // iOS7以上
#define XLAboveiOS8         (XLSysVersion >= 8.0)    // iOS8以上
#define XLAboveiOS9         (XLSysVersion >= 9.0)    // iOS9以上
#define XLAboveiOS10        (XLSysVersion >= 10.0)   // iOS10以上
#define XLAboveiOS11        (XLSysVersion >= 11.0)   // iOS11以上
#define XLAboveiOS12        (XLSysVersion >= 12.0)   // iOS12以上
#define XLAboveiOS13        (XLSysVersion >= 13.0)   // iOS13以上
#define XLAboveiOS14        (XLSysVersion >= 14.0)   // iOS14以上

#endif /* XLSystemMacro_h */
