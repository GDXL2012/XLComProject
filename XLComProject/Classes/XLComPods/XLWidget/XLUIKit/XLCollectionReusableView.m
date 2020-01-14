//
//  XLCollectionReusableView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLCollectionReusableView.h"
#import "Masonry.h"
#import "XLMacroFont.h"
#import "XLMacroColor.h"
#import "XLMacroLayout.h"

NSString *const XLCollectionReusableHeadID   = @"XLCollectionReusableHeadID";
NSString *const XLCollectionReusableFooterID = @"XLCollectionReusableFooterID";

@interface XLCollectionReusableView()
@property (nonatomic, strong) UILabel *xlTitleLabel;
@end

@implementation XLCollectionReusableView

-(void)setReusableType:(XLCollectionReusableType)reusableType{
    _reusableType = reusableType;
    if(reusableType != XLCollectionReusableEmpty){
        [self.xlLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if (reusableType == XLCollectionReusableTitleBottom) {
                make.bottom.mas_equalTo(self).offset(-4.0f);
            } else {
                make.centerY.mas_equalTo(self);
            }
        }];
    }
}

-(UILabel *)xlTitleLabel{
    if (!_xlTitleLabel) {
        _xlTitleLabel = [[UILabel alloc] init];
        _xlTitleLabel.font = XLGFont(15.0f);
        _xlTitleLabel.textColor = XLHolderColor;
        [self addSubview:_xlTitleLabel];
        [_xlTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(XLHMargin);
            make.centerY.mas_equalTo(self);
        }];
    }
    return _xlTitleLabel;
}

-(void)setXlTitle:(NSString *)xlTitle{
    _xlTitle = xlTitle;
    self.xlTitleLabel.text = xlTitle;
}
@end
