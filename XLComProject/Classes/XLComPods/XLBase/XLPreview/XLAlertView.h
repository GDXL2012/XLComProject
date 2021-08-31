//
//  XLAlertSheetView.h
//  XLComProject
//
//  Created by GDXL2012 on 2021/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface XLAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(XLAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIAlertActionStyle style;

@end

@interface XLAlertSheetView : UIView

-(void)addAction:(XLAlertAction *)action;

-(void)xlShow;
@end

NS_ASSUME_NONNULL_END
