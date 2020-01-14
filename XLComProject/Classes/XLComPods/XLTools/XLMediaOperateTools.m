//
//  XLMediaOperateTools.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLMediaOperateTools.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

#import "XLProgressHUDHelper.h"
#import "XLAppInfoTools.h"
#import "XLSystemMacro.h"
#import "XLMacroColor.h"
#import "XLMacroFont.h"

@implementation XLMediaOperateTools
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
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
            if (videoGranted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XLMediaOperateTools privateTakePhotoFromViewController:viewController imgMode:type duration:duration allowsEditing:allowsEditing delegate:delegate];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XLMediaOperateTools showCameraAuthorization];
                });
            }
        }];
    } else { //摄像涉及的权限
        //相机权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL videoGranted) {
            if (videoGranted) {
                //麦克风权限
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL audioGranted) {
                    if (audioGranted) {
                        //相片权限
                        // 判断当前的授权状态
                        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                            if (status == PHAuthorizationStatusRestricted) {
                                // 这是系统级别的限制（比如家长控制），用户也无法修改这个授权状态
                                [XLProgressHUDHelper toast:@"由于系统原因，无法保存图片！"];
                            } else if (status == PHAuthorizationStatusDenied) { // 拒绝访问
                                [XLMediaOperateTools showPhotoAuthorization];
                            } else if (status == PHAuthorizationStatusAuthorized) { // 已授权
                                [XLMediaOperateTools privateTakePhotoFromViewController:viewController imgMode:type duration:duration allowsEditing:allowsEditing delegate:delegate];
                            } else { // 用户未选择受权
                                [XLProgressHUDHelper toast:@"请在设置->隐私->照片权限中开启访问权限。"];
                            }
                        }];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [XLMediaOperateTools showMicrophoneAuthorization];
                        });
                    }
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *toast = [NSString stringWithFormat:@"请在隐私设置中开启%@的相机权限", [XLAppInfoTools appName]];
                    [XLProgressHUDHelper toast:toast];
                });
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
//        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [viewController presentViewController:pickerVC animated:YES completion:nil];
    } else {
        [XLProgressHUDHelper toast:@"设备不支持拍照功能"];
    }
}

/**
 显示相机权限提醒
 */
+(void)showCameraAuthorization{
    NSString *toast = [NSString stringWithFormat:@"%@没有访问相机的权限，无法进行拍照。请在设置->隐私->相机权限中开启访问权限。", [XLAppInfoTools appName]];
    [XLProgressHUDHelper toast:toast];
}

/**
 显示相册权限提醒
 */
+(void)showPhotoAuthorization{
    NSString *toast = [NSString stringWithFormat:@"%@没有访问照片的权限，无法进行拍摄。请在设置->隐私->照片权限中开启访问权限。", [XLAppInfoTools appName]];
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
