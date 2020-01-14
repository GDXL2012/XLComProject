//
//  XLTableReusableView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLTableReusableView.h"
#import "Masonry.h"
#import "XLMacroFont.h"
#import "XLMacroColor.h"
#import "XLMacroLayout.h"

NSString *const XLTableReusableHeadID   = @"XLTableReusableHeadID";
NSString *const XLTableReusableFooterID = @"XLTableReusableFooterID";

@implementation XLTableReusableView

/**
 初始化
 
 @param reuseIdentifier 复用标识
 @param type 类型
 @return 实例对象
 */
+(instancetype)viewReuseIdentifier:(NSString *)reuseIdentifier type:(XLTableReusableType)type {
    XLTableReusableView *view = [[XLTableReusableView alloc] initWithReuseIdentifier:reuseIdentifier type:type];
    return view;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    return [self initWithReuseIdentifier:reuseIdentifier type:XLTableReusableEmpty];
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(XLTableReusableType)type {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initTitleLabelWithType:type];
    }
    return self;
}

-(void)initTitleLabelWithType:(XLTableReusableType)type{
    if(type != XLTableReusableEmpty){
        _xlLabel = [[UILabel alloc] init];
        _xlLabel.font = XLGFont(15.0f);
        _xlLabel.textColor = XLHolderColor;
        [self.contentView addSubview:_xlLabel];
        [_xlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(XLHMargin);
            if (type == XLTableReusableTitleBottom) {
                make.bottom.mas_equalTo(self.contentView).offset(-4.0f);
            } else {
                make.centerY.mas_equalTo(self.contentView);
            }
        }];
    }
}

-(void)setXlTitle:(NSString *)xlTitle{
    _xlTitle = xlTitle;
    self.xlLabel.text = xlTitle;
}

-(void)setXlAttributedTitle:(NSAttributedString *)xlAttributedTitle{
    _xlAttributedTitle = xlAttributedTitle;
    self.xlLabel.attributedText = xlAttributedTitle;
}

-(void)setXlFont:(UIFont *)xlFont{
    _xlFont = xlFont;
    self.xlLabel.font = xlFont;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
