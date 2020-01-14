//
//  XLComPods.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLComPods.h"

static XLComPods *manager;
@implementation XLComPods

+(instancetype)manager{
    if (!manager) {
        manager = [[XLComPods alloc] init];
    }
    return manager;
}

@end
