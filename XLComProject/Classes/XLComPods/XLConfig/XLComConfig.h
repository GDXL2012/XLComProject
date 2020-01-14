//
//  XLComConfig.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/28.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLComConfigDelegate <NSObject>

/// 获取原图地址：如不实现，则取string地址
/// @param string 缩略图地址
-(NSString *)originalRemotePathFromUrl:(NSString *)string;

@end

@interface XLComConfig : XLBaseConfig

@property (nonatomic, weak) id<XLComConfigDelegate> xlConfigDelegate;

/// 加载失败图片显示：默认nil
@property (nonatomic, strong) UIImage  *loadingFaileImage;
@end

NS_ASSUME_NONNULL_END
