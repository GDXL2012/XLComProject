//
//  XLComPods.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLColorConfig.h"
#import "XLFontConfig.h"
#import "XLLayoutConfig.h"
#import "XLAdaptationConfig.h"
#import "XLComConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLComPods : NSObject

+(instancetype)manager;

@property (nonatomic, strong) XLColorConfig      *colorConfig;
@property (nonatomic, strong) XLFontConfig       *fontConfig;
@property (nonatomic, strong) XLLayoutConfig     *layoutConfig;
@property (nonatomic, strong) XLAdaptationConfig *adaptationConfig;
@property (nonatomic, strong) XLComConfig        *comConfig;

@end

NS_ASSUME_NONNULL_END
