//
//  XLTableReusableView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, XLTableReusableType) {
    XLTableReusableEmpty  = 0,       // 空白
    XLTableReusableTitleCenter,      // 标题居中
    XLTableReusableTitleBottom       // 标题底部对齐
};

extern NSString *const XLTableReusableHeadID;
extern NSString *const XLTableReusableFooterID;
@interface XLTableReusableView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString            *xlTitle;    // 标题
@property (nonatomic, copy) NSAttributedString  *xlAttributedTitle;
@property (nonatomic, copy) UIFont              *xlFont;

@property (nonatomic, readonly) UILabel         *xlLabel;

/**
 初始化
 
 @param reuseIdentifier 复用标识
 @param type 类型
 @return 实例对象
 */
+(instancetype)viewReuseIdentifier:(NSString *)reuseIdentifier type:(XLTableReusableType)type;

@end

NS_ASSUME_NONNULL_END
