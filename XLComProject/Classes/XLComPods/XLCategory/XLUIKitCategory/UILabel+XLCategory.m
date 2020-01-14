//
//  UILabel+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UILabel+XLCategory.h"
#import "NSObject+XLCategory.h"
#import "NSString+XLCategory.h"

@implementation UILabel (XLCategory)

+(void)load{
    Class label = [UILabel class];
    SEL originalSel = NSSelectorFromString(@"setText:");
    SEL newSel      = NSSelectorFromString(@"setXLText:");
    [NSObject exchangeClassImplementations:label originalSel:originalSel newSel:newSel forClassMethod:NO];
}

-(void)setXLText:(NSString *)text{
    if ([NSString isNilString:text]) {
        [self setXLText:@""];
    } else {
        [self setXLText:text];
    }
}

@end
