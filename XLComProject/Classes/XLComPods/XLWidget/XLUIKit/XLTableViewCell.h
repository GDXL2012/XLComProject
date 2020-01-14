//
//  XLTableViewCell.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLTableViewCellStyle){
    XLTableViewCellNone,         // 默认空cell
    XLTableViewCellTitle,        // 标题
    XLTableViewCellSubtitle,     // 标题，副标题【上下结构】
    XLTableViewCellContent,      // 标题，内容【左右结构】
    XLTableViewCellIcoTitle,     // 图标，标题
    XLTableViewCellHeadTitle,    // 头像，标题
    XLTableViewCellHeadSubTitle, // 头像，标题，副标题
};

typedef NS_ENUM(NSInteger, XLCellSelectType){
    XLCellSelectNone,   // 不显示选中
    XLCellSelectLeft,   // 左侧选中
    XLCellSelectRight   // 右侧选中
};

@interface XLTableViewCell : UITableViewCell
#pragma mark - Common property
/// TODO：选中类型:暂未实现
@property (nonatomic, assign) XLCellSelectType selectType;
@property (nonatomic, assign) BOOL isSelected;
/// 左侧辅助view：默认nil
@property (nonatomic, strong) UIView *leftAccessoryView;

#pragma mark - Customized property
@property (nonatomic, readonly) UIImageView *xlHeadeView;   /// 头像/Ico
@property (nonatomic, copy)     NSString    *headerUrl;     /// 网络头像
@property (nonatomic, copy)     NSString    *headerName;    /// 本地头像

@property (nonatomic, readonly) UILabel     *xlTitleLabel;  /// 标题label
@property (nonatomic, copy)     NSString    *xlTitle;       /// 标题

@property (nonatomic, readonly) UILabel     *xlDetailLabel; /// 详情、SubTitle
@property (nonatomic, copy)     NSString    *xlDetail;      /// 详情

/**
 获取cell
 
 @param style cell类型
 @param reuseIdentifier 复用标识
 @return 实例对象
 */
+(instancetype)cellForStyle:(XLTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/**
 获取cell高度
 
 @param bindingData <#bindingData description#>
 @return <#return value description#>
 */
+(CGFloat)hieghForBindingData:(id)bindingData;

/// 初始化cell
-(instancetype)initWithXLStyle:(XLTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

#pragma mark - Binding Data
/// 设置选中图标
/// @param normal <#normal description#>
/// @param select <#select description#>
-(void)setSelIcoNormal:(NSString *)normal select:(NSString *)select;

/// 设置头像
/// @param headerUrl 网络地址
/// @param defaultIco 默认头像
-(void)setHeaderUrl:(NSString *)headerUrl defaultIco:(NSString *)defaultIco;
@end

NS_ASSUME_NONNULL_END
