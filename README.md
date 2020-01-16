# XLComProject

[![CI Status](https://img.shields.io/travis/GDXL2012/XLComProject.svg?style=flat)](https://travis-ci.org/GDXL2012/XLComProject)
[![Version](https://img.shields.io/cocoapods/v/XLComProject.svg?style=flat)](https://cocoapods.org/pods/XLComProject)
[![License](https://img.shields.io/cocoapods/l/XLComProject.svg?style=flat)](https://cocoapods.org/pods/XLComProject)
[![Platform](https://img.shields.io/cocoapods/p/XLComProject.svg?style=flat)](https://cocoapods.org/pods/XLComProject)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 9.0

## Installation

XLComProject is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XLComProject'
```

## DESCRIPTION 【持续更新...】
### XLConfig 配置信息 
##### 适配配置 XLAdaptationConfig
- UIModalPresentationStyle 控制模态弹出模式
- UIStatusBarStyle 状态栏风格
- backImageName 返回按钮图标
- showBackTitle 返回按钮显示文字
##### 预定义颜色配置 XLColorConfig 
- 主题颜色、导航栏颜色、背景色等
##### 通用配置 XLComConfig 
- 远端图片加载失败默认图片
- 图片原图地址获取方法：图片预览等显示缩略图、原图
##### 字体配置 XLFontConfig
- 字体缩放等级、字体缩放倍数
- 用于获取可变字体大小，应用支持字体大小设置时使用
- 相关.h、.m文件【UIFont+XLCategory、XLMacroFont】
##### - 通用间距配置 XLLayoutConfig
- 控件左右间距、内部间距、分割线、圆角等，方便页面统一
 
### XLMacro 宏定义
##### 常用宏 XLComMacro
- 文件、路径、weakself、GCD等
##### 颜色宏 XLMacroColor
- 对应 XLColorConfig 中预定义值
##### 字体宏 XLMacroFont 
- 常用字体定义、可变字体
##### 控件间距宏 XLMacroLayout
- 对应XLLayoutConfig 中预定义值
##### 屏幕适配常用宏 XLDeviceMacro
- 屏幕尺寸、分辨率、物理分辨率，状态栏、导航栏、标签栏高度【适配刘海屏】
##### 系统版本 XLSystemMacro
- 系统版本判断

### Category 常用类添加类别添加工具方法
- 数组、NSData、JSON、NSString转换，判空：NSArray+XLCategory
- 字典、NSData、JSON、NSString转换，判空：NSDictionary+XLCategory
- NSError快速创建：NSError+XLCategory
- NSNull异常保护：NSNull+XLCategory
- 基类添加方法交换：NSObject+XLCategory
- 字符串判空、本地化、区域大小、生成唯一UUID，常用数字转字符串方法
- 指定时间格式获取、指定时间获取：NSDate+XLCategory、NSDate+XLFormatter、NSDateFormatter+XLCategory

- 16进制颜色转换，支持动态颜色：UIColor+XLCategory
- 设备类型：UIDevice+XLCategory
- 缩放字体：UIFont+XLCategory
- 图片颜色重绘、视频缩略图、图片压缩、图片剪切、纯色图片生成、截屏等：UIImage+XLCategory
- UILabel文本显示nil保护：UILabel+XLCategory
- UITextField占位符颜色设置，文本nil显示保护：UITextField+XLCategory
- UITextView文本nil显示保护：UITextView+XLCategory
- UIView圆角设置、添加分割线：UIView+XLCategory

### 预定义基类 XLFoundation
- XLWeakMutableArray 弱引用数组
- XLWeakMutableDictionary 弱引用字典
- NSWeakProxy虚类实现消息转发
- XLWeakTimer弱引用定时器

### 工具类 XLTools
##### 应用信息 XLAppInfoTools
- 应用名车、短版本号、版本号
##### 应用工具 XLApplicationTools
- 第三方应用跳转或打开链接：openURLScheme:
- 系统拨号：makePhoneCall:
- 系统短信：sendSMS:recipients:body:delegate:
- 方法调用【无参数方法】：runFuncation:target:
##### 校验工具 XLComCheckTools
- 数字校验：isNumber
- 账号校验【手机号码校验】：checkAccount:error:
- 密码校验：checkPassword:error:
- 密码格式校验：isPasswordFormat:
- 运营商【携号转网后这个似乎无意义了】：mobileCarriers:
- 手机号码校验：isMobileNumber:
- 座机号码校验、号码校验、邮箱校验、身份证校验
##### 文件操作工具 XLFileTools
- 常用文件操作写、删除、文件大小、媒体文件时长、文件是否存在、缓存唯一标识符【地址】、视频转换
##### 媒体工具 XLMediaOperateTools
- 拍照、选择照片/视频、录制视频：
##### 通知工具类 XLNotificationTools
- 注册/移除通知，通知发送
##### 控制器工具类 XLViewControllerTools
- 获取根控制器、获取最上层控制器、获取最上层模态控制器

### 部分系统控件封装 XLWidget
- XLCollectionReusableView：预设分组标题
- XLTableReusableView：预设分组标题
- XLRefreshTableView 基于[MJRefresh](https://github.com/CoderMJLee/MJRefresh)封装的下拉刷新/上拉加载更多列表，重载/替换了部分方法，支持动态设置上拉/下拉状态
- XLTableViewCell：预设了集中常见cell类型
- XLTextView 支持设置占位符TextView，实现TextView高度变更监听
- XLBarButtonItem 导航栏按钮自定义
- XLMoreMenuView 导航栏右上角更多菜单按钮

### 控制器基类 - XLBase
##### XLNavigationController.h
- 封装了TabBar标签设置方法
- 基于XLColorConfig.h中配置的导航栏风格设置

##### XLBaseViewController
- 控制器基类：定义了一些初始化方法，子类覆写后自动调用，导航栏的隐藏控制类

##### UIViewController+XLToast.h
- 基于第三方库[MBProgressHUD](https://github.com/jdg/MBProgressHUD)的简单封装，显示提醒跟等待框
- UIAlertController的简单封装

##### UIViewController+XLTools.h
- 控制器导航栏右侧按钮设置、隐藏等控制
- 页面跳转方法

##### UIViewController+XLPreview.h
- 图片预览：支持单张/多张图片【UIImage】、地址【URL】、控件【UIImageView】预览
- 支持基于[SDWebImage](https://github.com/SDWebImage/SDWebImage)的控件【UIImageView】预览

##### XLBaseTableViewController.h
- 简单的列表控制器，封装了UITableView初始化
- 支持UITableview位置自定义

##### XLBaseRefreshTableController.h
- 下拉刷新/上拉加载列表控制器
- 使用XLRefreshTableView基于[MJRefresh](https://github.com/CoderMJLee/MJRefresh)的简单封装
- 支持下拉/上拉刷新重置、取消
【持续更新中....】

## Author

GDXL2012, liyijun_1989@163.com

## License

XLComProject is available under the MIT license. See the LICENSE file for more info.
