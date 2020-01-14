//
//  XLCollectionReusableView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLCollectionReusableType) {
    XLCollectionReusableEmpty  = 0,       // 空白
    XLCollectionReusableTitleCenter,      // 标题居中
    XLCollectionReusableTitleBottom       // 标题底部对齐
};

extern NSString *const XLCollectionReusableHeadID;
extern NSString *const XLCollectionReusableFooterID;

@interface XLCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) XLCollectionReusableType reusableType;

@property (nonatomic, copy) NSString            *xlTitle;
@property (nonatomic, copy) NSAttributedString  *xlAttributedTitle;
@property (nonatomic, copy) UIFont              *xlFont;

@property (nonatomic, readonly) UILabel         *xlLabel; // 标题

@end

NS_ASSUME_NONNULL_END
