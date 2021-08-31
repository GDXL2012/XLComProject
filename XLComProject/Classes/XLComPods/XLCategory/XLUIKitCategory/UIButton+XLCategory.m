//
//  UIButton+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2021/2/5.
//

#import "UIButton+XLCategory.h"
#import "XLMacroFont.h"
#import "XLMacroColor.h"

@implementation UIButton (XLCategory)

-(void)xlButtonTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)xlHButtonTitle:(NSString *)hTitle{
    [self setTitle:hTitle forState:UIControlStateHighlighted];
}
-(void)xlAddButtonClick:(SEL)action target:(nullable id)target{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 常规字体
-(void)xlThemFont:(CGFloat)fontSize{
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
    [self xlTextBFont:fontSize color:[UIColor whiteColor]];
}

-(void)xlTextFont:(CGFloat)fontSize color:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = XLFont(fontSize);
}

#pragma mark - 高亮
-(void)xlHThemFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLThemeColor];
}
-(void)xlHTitleFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLTipsColor];
}
-(void)xlHSubTitleFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLSubTitleColor];
}
-(void)xlHDetailFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLDetailColor];
}
-(void)xlHTipsFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLTipsColor];
}
-(void)xlHWarningFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLWarningColor];
}
-(void)xlHPlaceholderFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLHolderColor];
}
-(void)xlHOhterFont:(CGFloat)fontSize{
    [self xlHTextFont:fontSize color:XLOtherColor];
}
-(void)xlHWhiteFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:[UIColor whiteColor]];
}

-(void)xlHTextFont:(CGFloat)fontSize color:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateHighlighted];
    self.titleLabel.font = XLFont(fontSize);
}

#pragma mark -  加粗
-(void)xlBThemFont:(CGFloat)fontSize{
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
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = XLBFont(fontSize);
}

#pragma mark - 加粗高亮
-(void)xlHBThemFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLThemeColor];
}
-(void)xlHBTitleFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLTitleColor];
}
-(void)xlHBSubTitleFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLSubTitleColor];
}
-(void)xlHBDetailFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLDetailColor];
}
-(void)xlHBTipsFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLTipsColor];
}
-(void)xlHBWarningFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLWarningColor];
}
-(void)xlHBPlaceholderFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLHolderColor];
}
-(void)xlHBOhterFont:(CGFloat)fontSize{
    [self xlHTextBFont:fontSize color:XLOtherColor];
}
-(void)xlHBWhiteFont:(CGFloat)fontSize{
    [self xlTextBFont:fontSize color:[UIColor whiteColor]];
}

-(void)xlHTextBFont:(CGFloat)fontSize color:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = XLBFont(fontSize);
}
@end
