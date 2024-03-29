//
//  XLAlertView.h
//  XLComProject
//
//  Created by GDXL2012 on 2021/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface XLAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(XLAlertAction *action))handler;
// 仅支持 UIAlertControllerStyleActionSheet模式
+ (instancetype)actionWithAttributedTitle:(nullable NSAttributedString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(XLAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nullable, nonatomic, readonly) NSAttributedString *attrTitle;
@property (nonatomic, readonly) UIAlertActionStyle style;

@end

/// 不可独立使用
@interface XLAlertView : UIView

@property (nonatomic, assign) NSTextAlignment messageTextAlignment;

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

-(void)addAction:(XLAlertAction *)action;

-(void)xlShow;
@end

@interface XLAlertSheetView : XLAlertView
@end

@interface XLAlertAlertView : XLAlertView

@end



NS_ASSUME_NONNULL_END
