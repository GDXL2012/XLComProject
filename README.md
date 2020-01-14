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

## DESCRIPTION - XLMacro 宏定义
### 屏幕适配常用宏定义
屏幕尺寸、分辨率、物理分辨率，状态栏、导航栏、标签栏高度【适配刘海屏】
XLDeviceMacro.h

### 系统版本
系统版本判断
XLSystemMacro.h

## DESCRIPTION - XLBase 控制器
### XLNavigationController.h
- 封装了TabBar标签设置方法
- 基于XLColorConfig.h中配置的导航栏风格设置

### XLBaseViewController
控制器基类：定义了一些初始化方法，子类覆写后自动调用，导航栏的隐藏控制类

### UIViewController+XLToast.h
- 基于第三方库[MBProgressHUD](https://github.com/jdg/MBProgressHUD)的简单封装，显示提醒跟等待框
- UIAlertController的简单封装

### UIViewController+XLTools.h
- 控制器导航栏右侧按钮设置、隐藏等控制
- 页面跳转方法

### UIViewController+XLPreview.h
- 图片预览：支持单张/多张图片【UIImage】、地址【URL】、控件【UIImageView】预览
- 支持基于[SDWebImage](https://github.com/SDWebImage/SDWebImage)的控件【UIImageView】预览

### XLBaseTableViewController.h
- 简单的列表控制器，封装了UITableView初始化
- 支持UITableview位置自定义

### XLBaseRefreshTableController.h
- 下拉刷新/上拉加载列表控制器
- 基于[MJRefresh](https://github.com/CoderMJLee/MJRefresh)的封装
- 支持下拉/上拉刷新重置、取消
【更新中....】
## Author

GDXL2012, liyijun_1989@163.com

## License

XLComProject is available under the MIT license. See the LICENSE file for more info.
