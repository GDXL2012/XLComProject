//
//  XLMediaOperateTools.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XLMediaOperateType){
    XLMediaOperateTypeAll       = 0,    // 全部
    XLMediaOperateTypePhoto     = 1,    // 照片
    XLMediaOperateTypeVideo     = 2     // 视频
};

@protocol XLMediaOperateDelegate <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

/// 媒体选择工具类
@interface XLMediaOperateTools : NSObject
/**
 选择照片
 
 @param viewController 弹出的父视图
 @param allowsEditing 是否可编辑
 @param delegate 回调
 */
+(void)selectPhotoInViewController:(UIViewController *)viewController
                     allowsEditing:(BOOL)allowsEditing
                          delegate:(id <XLMediaOperateDelegate>) delegate;

/**
 选择视频
 
 @param viewController 弹出的父视图
 @param delegate 回调
 */
+(void)selectVideoInViewController:(UIViewController *)viewController
                          delegate:(id <XLMediaOperateDelegate>) delegate;

/**
 系统拍照或视频
 
 @param viewController 弹出的父视图
 @param type 类型：拍照/视频
 @param allowsEditing 是否可编辑
 @param delegate 回调
 */
+(void)takePhotoInViewController:(UIViewController *)viewController
                         imgMode:(XLMediaOperateType)type
                   allowsEditing:(BOOL)allowsEditing
                        delegate:(id <XLMediaOperateDelegate>) delegate;

/**
 系统拍照或视频
 
 @param viewController 弹出的父视图
 @param type 类型：拍照/视频
 @param duration 视频时长：录制视频时参数有效
 @param allowsEditing 是否可编辑
 @param delegate 回调
 */
+(void)takePhotoInViewController:(UIViewController *)viewController
                         imgMode:(XLMediaOperateType)type
                        duration:(NSTimeInterval)duration
                   allowsEditing:(BOOL)allowsEditing
                        delegate:(id <XLMediaOperateDelegate>) delegate;
@end

NS_ASSUME_NONNULL_END
