//
//  XLTableViewCell.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLTableViewCell.h"
#import "Masonry.h"
#import "XLMacroLayout.h"
#import "XLMacroFont.h"
#import "XLMacroColor.h"
#import "NSString+XLCategory.h"
#import "UIImageView+WebCache.h"

@interface XLTableViewCell ()

/// 设置选中图标
/// @param normal <#normal description#>
/// @param select <#select description#>
-(void)setSelIcoNormal:(NSString *)normal select:(NSString *)select;

#pragma mark - Customized property

@property (nonatomic, strong) UIImageView *xlHeadeView;     /// 头像/Ico
@property (nonatomic, strong) UILabel     *xlTitleLabel;    /// 标题
@property (nonatomic, strong) UILabel     *xlDetailLabel;   /// 详情、SubTitle

#pragma mark - Private Property
@property (nonatomic, strong) UIView *leftAccessoryBGView;  /// 左侧辅助View背景：默认 nil

@property (nonatomic, assign) XLTableViewCellStyle cellStyle;   /// cell类型

@end

@implementation XLTableViewCell

/**
 获取cell
 
 @param style cell类型
 @param reuseIdentifier 复用标识
 @return 实例对象
 */
+(instancetype)cellForStyle:(XLTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [[XLTableViewCell alloc] initWithXLStyle:style reuseIdentifier:reuseIdentifier];
}

/**
 获取cell高度
 
 @param bindingData <#bindingData description#>
 @return <#return value description#>
 */
+(CGFloat)hieghForBindingData:(id)bindingData{
    return 48.0f;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [self initWithXLStyle:XLTableViewCellNone reuseIdentifier:reuseIdentifier];
}

/// 初始化cell
-(instancetype)initWithXLStyle:(XLTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectType = XLCellSelectNone;
        _cellStyle = style;
        [self configCellForStyle:style];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Config Method
-(void)configCellForStyle:(XLTableViewCellStyle)style{
    switch (style) {
        case XLTableViewCellTitle:
            [self configTitleCell];
            break;
        case XLTableViewCellSubtitle:
            [self configSubtitleCell];
            break;
        case XLTableViewCellContent:
            [self configContentCell];
            break;
        case XLTableViewCellIcoTitle:
            [self configIcoTitleCell];
            break;
        case XLTableViewCellHeadTitle:
            [self configHeadTitleCell];
            break;
        case XLTableViewCellHeadSubTitle:
            [self configHeadSubTitleCell];
            break;
        default:
            break;
    }
}

-(void)configTitleCell{
    [self initTitleLabel];
}

-(void)configSubtitleCell{
    [self initTitleLabel];
    [self initDetailLabel];
}

-(void)configContentCell{
    [self initTitleLabel];
    [self initDetailLabel];
}

-(void)configIcoTitleCell{
    [self initHeaderImageView];
    [self initTitleLabel];
}

-(void)configHeadTitleCell{
    [self initHeaderImageView];
    [self initTitleLabel];
}

-(void)configHeadSubTitleCell{
    [self initHeaderImageView];
    [self initTitleLabel];
    [self initDetailLabel];
}

#pragma mark - Init View
-(void)initLeftAccessoryBGView{
    _leftAccessoryBGView = [[UIView alloc] init];
    _leftAccessoryBGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_leftAccessoryView];
    [_leftAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(CGFLOAT_MIN);
    }];
}

/**
 头像初始化
 */
-(void)initHeaderImageView{
    _xlHeadeView = [[UIImageView alloc] init];
    [self.contentView addSubview:_xlHeadeView];
    if (self.cellStyle == XLTableViewCellIcoTitle) {
        [_xlHeadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftAccessoryBGView).offset(XLHMargin);
            make.centerY.mas_equalTo(self.contentView);
            CGFloat width = XLCellIcoWidth;
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    } else {
        [_xlHeadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftAccessoryBGView).offset(XLHMargin);
            make.top.mas_equalTo(self.contentView).offset(XLVMargin);
            make.bottom.mas_equalTo(self.contentView).offset(-XLVMargin);
            make.height.mas_equalTo(self.xlHeadeView.mas_width);
        }];
    }
}

/**
 初始化标题label
 */
-(void)initTitleLabel{
    _xlTitleLabel = [[UILabel alloc] init];
    _xlTitleLabel.font = XLDetail1Font;
    _xlTitleLabel.textColor = XLTitleColor;
    _xlTitleLabel.numberOfLines = 1;
    [self.contentView addSubview:_xlTitleLabel];
    [_xlTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.xlHeadeView) {
            make.left.mas_equalTo(self.xlHeadeView.mas_right).offset(XLHSpace);
        } else {
            make.left.mas_equalTo(self.contentView.mas_left).offset(XLHMargin);
        }
        if (self.cellStyle == XLTableViewCellHeadSubTitle ||
            self.cellStyle == XLTableViewCellSubtitle) {
            CGFloat offset = XLVSpace / 2.0f;
            make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-offset);
        } else {
            make.centerY.mas_equalTo(self.contentView);
        }
        if (self.cellStyle != XLTableViewCellContent) {
            make.right.mas_equalTo(self.contentView).offset(-XLHMargin);
        }
    }];
}

/**
 初始化详情/Subtitle label
 */
-(void)initDetailLabel{
    _xlDetailLabel = [[UILabel alloc] init];
    _xlDetailLabel.font = XLDetail1Font;
    _xlDetailLabel.textColor = [UIColor blackColor];
    _xlDetailLabel.numberOfLines = 1;
    [self.contentView addSubview:_xlDetailLabel];
    [_xlDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.cellStyle == XLTableViewCellSubtitle ||
            self.cellStyle == XLTableViewCellHeadSubTitle) {
            make.left.mas_equalTo(self.xlTitleLabel);
            CGFloat offset = XLVSpace / 2.0f;
            make.top.mas_equalTo(self.contentView.mas_centerY).offset(offset);
        } else {
            make.left.mas_equalTo(self.xlTitleLabel.mas_right).offset(-XLHSpace);
            make.centerY.mas_equalTo(self.xlTitleLabel);
        }
        make.right.mas_equalTo(self.contentView).offset(-XLHMargin);
    }];
}

#pragma mark - Binding Data
/// 设置选中图标
/// @param normal <#normal description#>
/// @param select <#select description#>
-(void)setSelIcoNormal:(NSString *)normal select:(NSString *)select{
    /// TODO：暂未实现
}

-(void)setHeaderUrl:(NSString *)headerUrl defaultIco:(NSString *)defaultIco{
    _headerUrl = headerUrl;
    if ([NSString isEmpty:headerUrl]) {
        [self setHeaderName:defaultIco];
    } else {
        if ([NSString isEmpty:defaultIco]) {
            [self setHeaderUrl:headerUrl];
        } else {
            UIImage *header = [UIImage imageNamed:defaultIco];
            NSURL *url = [NSURL URLWithString:headerUrl];
            [self.xlHeadeView sd_setImageWithURL:url placeholderImage:header];
        }
    }
}

-(void)setHeaderUrl:(NSString *)headerUrl{
    NSURL *url = [NSURL URLWithString:headerUrl];
    if ([NSString isEmpty:headerUrl]) {
        self.xlHeadeView.image = nil;
    } else {
        [self.xlHeadeView sd_setImageWithURL:url];
    }
}

-(void)setHeaderName:(NSString *)headerName{
    if ([NSString isEmpty:headerName]) {
        UIImage *header = [UIImage imageNamed:headerName];
        self.xlHeadeView.image = header;
    } else {
        self.xlHeadeView.image = nil;
    }
}

-(void)setXlTitle:(NSString *)xlTitle{
    _xlTitle = xlTitle;
    if ([NSString isEmpty:xlTitle]) {
        self.xlTitleLabel.text = @" ";
    } else {
        self.xlTitleLabel.text = xlTitle;
    }
}

-(void)setXlDetail:(NSString *)xlDetail{
    _xlDetail = xlDetail;
    if ([NSString isEmpty:xlDetail]) {
        self.xlDetailLabel.text = @" ";
    } else {
        self.xlDetailLabel.text = xlDetail;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
