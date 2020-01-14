//
//  XLMoreMenuView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XLMoreMenuView;
@protocol XLMoreMenuViewDelegate <NSObject>
@optional
/**
 菜单选项点击回调

 @param menuView <#menuView description#>
 @param index <#index description#>
 */
-(void)moreMenuView:(XLMoreMenuView *)menuView clickAtIndex:(NSInteger)index;

/**
 非主动触发导致menuView隐藏时回调：hiddenMenuView不会触发该回调
 */
-(void)moreMenuViewCancel;

@end

@interface XLMoreMenuView : UIView

@property (nonatomic, weak) id<XLMoreMenuViewDelegate> menuDelegate;

/**
 初始化
 
 @param titles 标题
 @param icos 图标
 @return <#return value description#>
 */
-(instancetype)initWithTitles:(NSArray *)titles icos:(NSArray *)icos;

#pragma mark - 单例对象
/**
 显示菜单

 @param titles <#titles description#>
 @param icos <#icos description#>
 @param view <#view description#>
 @param delegate <#delegate description#>
 */
+(void)showMenuView:(NSArray *)titles icos:(NSArray *)icos inView:(UIView *)view delegate:(id<XLMoreMenuViewDelegate>)delegate;
+(void)hiddenMenuView;
@end

NS_ASSUME_NONNULL_END
