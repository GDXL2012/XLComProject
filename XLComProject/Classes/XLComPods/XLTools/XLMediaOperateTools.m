//
//  XLMediaOperateTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLMediaOperateTools.h"

#import <CoreServices/CoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <PhotosUI/PHPhotoLibrary+PhotosUISupport.h>

#import "XLProgressHUDHelper.h"
#import "XLAppInfoTools.h"
#import "XLSystemMacro.h"
#import "XLMacroColor.h"
#import "XLMacroFont.h"

@implementation XLMediaOperateTools

/// 校验拍摄权限
/// @param permissionGranted <#permissionGranted description#>
+ (void)xlCheckTakeVideoAuthorization:(void(^)(BOOL granted))permissionGranted{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
        if (videoGranted) {
            //麦克风权限
            [XLMediaOperateTools xlCheckAudioAuthorization:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (permissionGranted){
                        permissionGranted(granted);
                    }
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showCameraAuthorization];
                if (permissionGranted){
                    permissionGranted(NO);
                }
            });
        }
    }];
}

/// 校验录音权限
/// @param permissionGranted <#permissionGranted description#>
+ (void)xlCheckAudioAuthorization:(void(^)(BOOL granted))permissionGranted{
    //麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL audioGranted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!audioGranted) {
                [XLMediaOperateTools showMicrophoneAuthorization];
            }
            if (permissionGranted){
                permissionGranted(audioGranted);
            }
        });
    }];
}

/// 校验相机拍照
/// @param permissionGranted <#permissionGranted description#>
+ (void)xlCheckTakePhotoAuthorization:(void(^)(BOOL granted))permissionGranted{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
        //麦克风权限
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!videoGranted) {
                [self showCameraAuthorization];
            }
            if (permissionGranted){
                permissionGranted(videoGranted);
            }
        });
    }];
}

/** 校验是否有相册权限 */
+ (void)xlCheckAlbumAuthorization:(void (^)(BOOL, PHAuthorizationStatus))permissionGranted{
    if(@available(iOS 14.0, *)){
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL granted = NO;
                if (status == PHAuthorizationStatusRestricted) {
                    // 这是系统级别的限制（比如家长控制），用户也无法修改这个授权状态
                    [self showMediaRestricted];
                } else if (status == PHAuthorizationStatusDenied) { // 拒绝访问
                    [XLMediaOperateTools showPhotoAuthorization];
                } else if (status == PHAuthorizationStatusAuthorized ||
                           status == PHAuthorizationStatusLimited) { // 已授权
                    granted = YES;
                } else { // 用户未选择受权
                    [XLMediaOperateTools showPhotoAuthorization];
                }
                if (permissionGranted){
                    permissionGranted(granted, status);
                }
            });
        }];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted) {
                    // 这是系统级别的限制（比如家长控制），用户也无法修改这个授权状态
                    [self showMediaRestricted];
                } else if (status == PHAuthorizationStatusDenied) { // 拒绝访问
                    [XLMediaOperateTools showPhotoAuthorization];
                } else if (status == PHAuthorizationStatusAuthorized) { // 已授权
                } else { // 用户未选择受权
                    [self showPhotoAuthorization];
                }
                if (permissionGranted){
                    permissionGranted(status == PHAuthorizationStatusAuthorized, status);
                }
            });
        }];
    }
}

+(PHAuthorizationStatus)xlAlbumAuthorization{
    if(@available(iOS 14.0, *)){
        return [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    } else {
        return [PHPhotoLibrary authorizationStatus];
    }
}


+(void)presentLimitedLibraryPickerFromViewController:(UIViewController *)controller{
    if(@available(iOS 14.0, *)){
        [[PHPhotoLibrary sharedPhotoLibrary] presentLimitedLibraryPickerFromViewController:controller];
    }
}
/**
 选择照片
 
 @param viewController 弹出的父视图
 @param allowsEditing 是否可编辑
 @param delegate 回调
 */
+(void)selectPhotoInViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing delegate:(id <XLMediaOperateDelegate>) delegate{
    
    UIImagePickerController *pickerVC = [XLMediaOperateTools imagePickerController];
    pickerVC.allowsEditing  = allowsEditing;
    pickerVC.editing        = allowsEditing;
    pickerVC.delegate       = delegate;
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.modalPresentationStyle = [XLConfigManager xlConfigManager].adaptationConfig.modalPresentationStyle;
    [viewController presentViewController:pickerVC animated:YES completion:nil];
}

/**
 选择视频
 
 @param viewController 弹出的父视图
 @param delegate 回调
 */
+(void)selectVideoInViewController:(UIViewController *)viewController delegate:(id <XLMediaOperateDelegate>) delegate{
    UIImagePickerController *pickerVC = [XLMediaOperateTools imagePickerController];
    
    pickerVC.allowsEditing  = NO;
    pickerVC.editing        = NO;
    pickerVC.delegate       = delegate;
    pickerVC.sourceType     = UIImagePickerControllerSourceTypePhotoLibrary;
    NSString *mediaType     = ( NSString *)kUTTypeMovie;
    NSArray *mediaTypes     = [NSArray arrayWithObjects:mediaType,nil];
    [pickerVC setMediaTypes:mediaTypes];
    pickerVC.modalPresentationStyle = [XLConfigManager xlConfigManager].adaptationConfig.modalPresentationStyle;
    [viewController presentViewController:pickerVC animated:YES completion:nil];
}

/// 图片选择控制器
+(UIImagePickerController *)imagePickerController{
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    // 导航栏图标颜色
    [pickerVC.navigationBar setTintColor:XLBarTitleColor];
    // 导航栏背景色黑色
    [pickerVC.navigationBar setBarTintColor:XLThemeColor];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:XLBarTitleFont};
    pickerVC.modalPresentationStyle = [XLConfigManager xlConfigManager].adaptationConfig.modalPresentationStyle;
    [pickerVC.navigationBar setTitleTextAttributes:attributes];
    return pickerVC;
}

/**
 系统拍照或视频
 
 @param viewController 弹出的父视图
 @param type 类型：拍照/视频
 @param allowsEditing 是否可编辑
 @param delegate 回调
 */
+(void)takePhotoInViewController:(UIViewController *)viewController imgMode:(XLMediaOperateType)type allowsEditing:(BOOL)allowsEditing delegate:(id <XLMediaOperateDelegate>) delegate{
    [XLMediaOperateTools takePhotoInViewController:viewController imgMode:type duration:0 allowsEditing:allowsEditing delegate:delegate];
}

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
                        delegate:(id <XLMediaOperateDelegate>) delegate{
    //拍照仅仅涉及相机权限
    if (type == XLMediaOperateTypePhoto) {
        [XLMediaOperateTools xlCheckTakePhotoAuthorization:^(BOOL granted) {
            if (granted) {
                [XLMediaOperateTools privateTakePhotoFromViewController:viewController imgMode:type duration:duration allowsEditing:allowsEditing delegate:delegate];
            }
        }];
    } else { //摄像涉及的权限
        //相机权限
        [XLMediaOperateTools xlCheckTakeVideoAuthorization:^(BOOL granted) {
            if (granted) {
                [XLMediaOperateTools xlCheckAlbumAuthorization:^(BOOL granted, PHAuthorizationStatus status) {
                    [XLMediaOperateTools privateTakePhotoFromViewController:viewController imgMode:type duration:duration allowsEditing:allowsEditing delegate:delegate];
                }];
            }
        }];
    }
}

/// 拍照/拍摄视频：视频拍摄时间默认不限制
/// @param viewController 弹出的父视图
/// @param type 类型：拍照/视频
/// @param allowsEditing YES 可编辑
/// @param delegate 回调
+(void)privateTakePhotoFromViewController:(UIViewController *)viewController imgMode:(XLMediaOperateType)type allowsEditing:(BOOL)allowsEditing delegate:(id <XLMediaOperateDelegate>) delegate{
    [self privateTakePhotoFromViewController:viewController imgMode:type duration:0 allowsEditing:allowsEditing delegate:delegate];
}

/// 拍照/拍摄视频
/// @param viewController 弹出的父视图
/// @param type 类型：拍照/视频
/// @param duration 视频时长：录制视频时参数有效
/// @param allowsEditing YES 可编辑
/// @param delegate 回调
+(void)privateTakePhotoFromViewController:(UIViewController *)viewController
                                  imgMode:(XLMediaOperateType)type
                                 duration:(NSTimeInterval)duration
                            allowsEditing:(BOOL)allowsEditing
                                 delegate:(id <XLMediaOperateDelegate>) delegate{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerVC = [XLMediaOperateTools imagePickerController];
        pickerVC.allowsEditing  = allowsEditing;
        pickerVC.editing        = allowsEditing;
        pickerVC.delegate       = delegate;
        pickerVC.sourceType     = UIImagePickerControllerSourceTypeCamera;
        pickerVC.cameraDevice   = UIImagePickerControllerCameraDeviceRear;
        
        NSString *requiredMediaType = (NSString *)kUTTypeImage;
        if (type == XLMediaOperateTypeVideo) {
            requiredMediaType = (NSString *)kUTTypeMovie;
            // 设置录制视频的质量
            [pickerVC setVideoQuality:UIImagePickerControllerQualityTypeMedium];
            //设置最长摄像时间
            if (duration > 0) {
                [pickerVC setVideoMaximumDuration:60.f];
            }
        }
        NSArray *arrMediaTypes = [NSArray arrayWithObjects:requiredMediaType, nil];
        [pickerVC setMediaTypes:arrMediaTypes];
        
        pickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        pickerVC.showsCameraControls = YES;
        pickerVC.modalPresentationStyle = [XLConfigManager xlConfigManager].adaptationConfig.modalPresentationStyle;
        [viewController presentViewController:pickerVC animated:YES completion:nil];
    } else {
        [XLProgressHUDHelper toast:@"设备不支持拍照功能"];
    }
}

+(void)showMediaRestricted{
    [XLProgressHUDHelper toast:@"由于系统原因，无法访问相册！"];
}

/**
 显示相机权限提醒
 */
+(void)showCameraAuthorization{
    NSString *toast = [NSString stringWithFormat:@"%@没有访问相机的权限。请在设置->隐私->相机权限中开启访问权限。", [XLAppInfoTools appName]];
    [XLProgressHUDHelper toast:toast];
}

/**
 显示相册权限提醒
 */
+(void)showPhotoAuthorization{
    NSString *toast = [NSString stringWithFormat:@"%@没有访问相册的权限。请在设置->隐私->照片权限中开启访问权限。", [XLAppInfoTools appName]];
    [XLProgressHUDHelper toast:toast];
}

/**
 显示麦克风权限提醒
 */
+(void)showMicrophoneAuthorization{
    NSString *toast = [NSString stringWithFormat:@"%@没有访问麦克风的权限，无法进行拍摄。请在设置->隐私->麦克风权限中开启访问权限。", [XLAppInfoTools appName]];
    [XLProgressHUDHelper toast:toast];
}
@end
