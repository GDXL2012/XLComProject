//
//  XLTextView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLTextView;
@protocol XLTextViewDelegate <UITextViewDelegate>
@optional
/**
 文本高度变更
 
 @param textView 文本描述
 @param height 高度
 */
-(void)textView:(XLTextView *)textView heightChange:(CGFloat) height;
@end

@interface XLTextView : UITextView
@property (nonatomic, copy) NSString *placeHolder;      // 占位符
@property (nonatomic, copy) UIColor  *placeHolderColor; // 占位符颜色

@property (nonatomic, assign, nonnull) id<XLTextViewDelegate> xlDelegate;

-(void)setDelegate:(nullable id<UITextViewDelegate>)delegate DEPRECATED_MSG_ATTRIBUTE("Please use [XLTextView xlDelegate]");

@end

NS_ASSUME_NONNULL_END
