//
//  XLComMacro.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLComMacro_h
#define XLComMacro_h

// GlobalQueue/MainQueue
#define XLDisPatchGetGlobalQueue        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define XLDisPatchAsyncGlobal(block)    dispatch_async(XLDisPatchGetGlobalQueue, block)
#define XLDisPatchAsyncMain(block)      dispatch_async(dispatch_get_main_queue(), block)

// 主线程异步队列
#ifndef XLDispatchMainAsyncSafe
#define XLDispatchMainAsyncSafe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

// Weak Self
#define XLWeakSelf      typeof(self) __weak weakSelf = self;
#define XLStrongSelf    typeof(weakSelf) __strong strongSelf = weakSelf;

// 文件相关
#define XLSearchPath(pathDirectory)   [NSSearchPathForDirectoriesInDomains(pathDirectory, NSUserDomainMask, YES) objectAtIndex:0]                    // 获取指定文件目录
// 文件管理单例
#define XLFileManager       [NSFileManager defaultManager]
#define XLHomePath          NSHomeDirectory()
#define XLTempPath          NSTemporaryDirectory()
#define XLDocumentPath      XLSearchPath(NSDocumentDirectory)
#define XLCachesPath        XLSearchPath(NSCachesDirectory)
#define XLLibraryPath       XLSearchPath(NSLibraryDirectory)

// 单例
#define XLUserDefaults   [NSUserDefaults standardUserDefaults]  // 用户行为偏好
#endif /* XLComMacro_h */
