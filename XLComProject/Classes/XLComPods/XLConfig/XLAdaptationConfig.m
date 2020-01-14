//
//  XLAdaptationConfig.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLAdaptationConfig.h"
#import "XLSystemMacro.h"

@implementation XLAdaptationConfig
-(instancetype)init{
    self = [super init];
    if (self) {
        _modalPresentationStyle = UIModalPresentationFullScreen;
        if (XLAvailableiOS13) {
            _preferredStatusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            _preferredStatusBarStyle = UIStatusBarStyleDefault;
        }
    }
    return self;
}
@end
