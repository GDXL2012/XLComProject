//
//  UIView+XLAdditions.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIView+XLAdditions.h"
#import "Masonry.h"

@implementation UIView (XLAdditions)
- (MASViewAttribute *)mas_safeGuide {
    return [self mas_safeAreaLayoutGuide];
}

- (MASViewAttribute *)mas_safeLeft {
    return [self mas_safeAreaLayoutGuideLeft];
}

- (MASViewAttribute *)mas_safeRight {
    return [self mas_safeAreaLayoutGuideRight];
}

- (MASViewAttribute *)mas_safeTop {
    return [self mas_safeAreaLayoutGuideTop];
}

- (MASViewAttribute *)mas_safeBottom {
    return [self mas_safeAreaLayoutGuideBottom];
}
@end
