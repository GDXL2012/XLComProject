//
//  XLImageMosaicTools.h
//  CHNMed
//
//  Created by GDXL2012 on 2020/8/17.
//  Copyright © 2020 GDXL2012. All rights reserved.
//
//  ⚠️代码修改自第三方库：ZMJImageEditor⚠️
//  ⚠️Git地址：https://github.com/keshiim/ZMJImageEditor⚠️

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XLImageMosaicTools;
@protocol XLImageMosaicDelegate <NSObject>

/// 涂鸦开始
/// @param mosaicTools <#mosaicTools description#>
-(void)xlImageMosaicBegain:(XLImageMosaicTools *)mosaicTools;

/// 涂鸦结束
/// @param mosaicTools <#mosaicTools description#>
-(void)xlImageMosaicEnd:(XLImageMosaicTools *)mosaicTools;

@end

@interface XLMosaicPath : UIBezierPath
@property (nonatomic, strong) CAShapeLayer *xlShape;
@property (nonatomic, strong) UIColor      *xlStrokeColor;//画笔颜色

/// 初始化路径
/// @param startPoint <#startPoint description#>
/// @param strokeWidth <#strokeWidth description#>
/// @param color <#color description#>
+(instancetype)xlPathWithStartPoint:(CGPoint)startPoint
                        strokeWidth:(CGFloat)strokeWidth
                              color:(UIColor *)color;

-(void)drawPathInCurrentImageContext;
@end

/// 图片马赛克
@interface XLImageMosaicTools : NSObject
@property (nonatomic, weak) id<XLImageMosaicDelegate> xlMosaicDelegate;
// 马赛克：NO 涂鸦
-(instancetype)initMosaictoolsWithImgView:(UIImageView *)imageView forMosaic:(BOOL)mosaic;
-(void)updateImageView:(UIImageView *)imageView;
#pragma mark - Mosaic Began/End
/// 开始马赛克
-(void)xlBeganMosaic;
-(void)xlBeganMosaicWithPaths:(nullable NSArray <XLMosaicPath *> *)mosaicPaths;
-(void)xlResetMosaic;
/// 开始马赛克
-(void)xlEndMosaic;

/// 设置画笔颜色：涂鸦时有效
-(void)setMosaicStrokeColor:(UIColor *)color width:(CGFloat)width;

#pragma mark - Operation Revoke/Resume
/// 取消本次涂鸦
-(void)xlCancelMosaic;

/// 上一步/下一步：单步撤回、恢复
-(void)xlPreviousStep;
//-(void)xlNextStep;

/// 涂鸦后的图片
-(UIImage *)xlmosaicImage;
-(NSArray <XLMosaicPath *> *)xlImageMosaicPathArray;
@end

NS_ASSUME_NONNULL_END
