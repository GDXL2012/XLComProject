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
#import "XLMacroFont.h"
#import "XLMacroColor.h"

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

#pragma mark - 常规字体
-(void)xlThemeFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLThemeColor];
}
-(void)xlTitleFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLTitleColor];
}
-(void)xlSubTitleFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLSubTitleColor];
}
-(void)xlDetailFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLDetailColor];
}
-(void)xlTipsFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLTipsColor];
}
-(void)xlWarningFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLWarningColor];
}
-(void)xlPlaceholderFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLHolderColor];
}
-(void)xlOhterFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:XLOtherColor];
}
-(void)xlWhiteFont:(CGFloat)fontSize{
    [self xlTextFont:fontSize color:[UIColor whiteColor]];
}

-(void)xlTextFont:(CGFloat)fontSize color:(UIColor *)color{
    self.font = XLFont(fontSize);
    self.textColor = color;
}

#pragma mark -  加粗
-(void)xlBThemeFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLThemeColor];
}
-(void)xlBTitleFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLTitleColor];
}
-(void)xlBSubTitleFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLSubTitleColor];
}
-(void)xlBDetailFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLDetailColor];
}
-(void)xlBTipsFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLTipsColor];
}
-(void)xlBWarningFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLWarningColor];
}
-(void)xlBPlaceholderFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLHolderColor];
}
-(void)xlBOhterFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:XLOtherColor];
}
-(void)xlBWhiteFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:[UIColor whiteColor]];
}

-(void)xlTextBFont:(CGFloat)fontSize color:(UIColor *)color{
    self.font = XLBFont(fontSize);
    self.textColor = color;
}

@end
