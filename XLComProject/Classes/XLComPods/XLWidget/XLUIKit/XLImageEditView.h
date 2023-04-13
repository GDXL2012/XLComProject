//
//  XLImageEditView.h
//  CHNMed
//
//  Created by GDXL2012 on 2020/8/27.
//  Copyright © 2020 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLImageEditViewStyle) {
    XLImageEditViewDefault, // 画笔颜色可选择
    XLImageEditViewSingle,  // 画笔颜色不可选
};

@protocol XLImageEditViewDelegate <NSObject>
-(void)imageEditViewComplete:(UIImage *)editImage;
-(void)imageEditViewCancel;

@end

@interface XLImageEditView : UIView
@property (nonatomic, strong) UIImage       *cmPreviewImage;
@property (nonatomic, weak) id<XLImageEditViewDelegate> cmDelegate;

/// 显示图片编辑
+(void)showImageEditView:(UIImage *)image
                  inView:(UIView *)view
                delegate:(id<XLImageEditViewDelegate>)delegate;

/// 显示图片编辑
+(void)showSingImageEditView:(UIImage *)image
                      inView:(UIView *)view
                    delegate:(id<XLImageEditViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
