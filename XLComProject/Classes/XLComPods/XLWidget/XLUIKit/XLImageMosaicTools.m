//
//  XLImageMosaicTools.m
//  CHNMed
//
//  Created by GDXL2012 on 2020/8/17.
//  Copyright © 2020 GDXL2012. All rights reserved.
//

#import "XLImageMosaicTools.h"
#import <objc/runtime.h>
#import "Masonry.h"

@interface XLImageMosaicTools ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView     *xlMosaicImgView;
@property (nonatomic, strong) UIImageView   *xlDosaicContentImgView;
@property (nonatomic, weak) UIScrollView    *xlMosaicScrollView;

@property (nonatomic, strong) NSMutableArray *xlMosaicPathArray;    /// 路径列表
@property (nonatomic, strong) NSMutableArray *xlOldMosaicPathArray; /// 旧路径列表

@property (nonatomic, strong) UIPanGestureRecognizer *xlPanGesture; /// 手势

@property (nonatomic, strong) UIColor *xlStrokeColor;
@property (nonatomic, assign) CGFloat xlStrokeWidth;


@property (nonatomic, assign) NSUInteger    minimumNumberOfTouches;
@property (nonatomic, assign) BOOL          delaysTouchesBegan;
@property (nonatomic, assign) BOOL          userInteractionEnabled;

@property (nonatomic, strong) UIImage       *xlMosaicImage;
@property (nonatomic, strong) UIImage       *xlFullMosaicImage; // 全马赛克图片
@property (nonatomic, assign) BOOL forMosaic;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation XLImageMosaicTools

-(instancetype)initMosaictoolsWithImgView:(UIImageView *)imageView forMosaic:(BOOL)mosaic{
    self = [super init];
    if (self) {
        _xlMosaicImgView = imageView;
        
        _xlDosaicContentImgView = [[UIImageView alloc] init];
        _xlDosaicContentImgView.backgroundColor = [UIColor clearColor];
        _xlDosaicContentImgView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addSubview:_xlDosaicContentImgView];
        [_xlDosaicContentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(imageView);
        }];
        
        _forMosaic = mosaic;
        if(_forMosaic){
            CIImage *ciImage = [CIImage imageWithCGImage:imageView.image.CGImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
            [filter setDefaults];
            [filter setValue:ciImage forKey:kCIInputImageKey];
            
            UIImage *filterImage = [UIImage imageWithCIImage:[filter outputImage]];
            _xlFullMosaicImage = filterImage;
        }
        
        _xlMosaicPathArray = [NSMutableArray array];
        _xlOldMosaicPathArray = [NSMutableArray array];
        _xlStrokeWidth = 1.0f;
        _xlStrokeColor = [UIColor blackColor];
    }
    return self;
}

-(void)updateImageView:(UIImageView *)imageView{
    [_xlDosaicContentImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(imageView);
    }];
}

/// 设置画笔颜色
-(void)setMosaicStrokeColor:(UIColor *)color width:(CGFloat)width{
    _xlStrokeColor = color;
    _xlStrokeWidth = width;
}

#pragma mark - Mosaic Began/End
/// 开始马赛克
-(void)xlBeganMosaic{
    [self xlBeganMosaicWithPaths:nil];
}

-(UIScrollView *)getSuperScrollViewForView:(UIView *)view{
    if (view.superview == nil) {
        return nil;
    } else if ([view.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)view.superview;
    } else {
        return [self getSuperScrollViewForView:view.superview];
    }
}

-(void)xlBeganMosaicWithPaths:(nullable NSArray <XLMosaicPath *> *)mosaicPaths{
    _xlMosaicImage = nil;
    //初始化一些东西
    if(_xlPanGesture == nil){
        UIPanGestureRecognizer *gesture = nil;
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(xlMosaicPanGestureRecognizer:)];
        gesture.delegate = self;
        gesture.maximumNumberOfTouches = 1;
        _xlPanGesture = gesture;
    }
    if (!self.xlPanGesture.isEnabled) {
        self.xlPanGesture.enabled = YES;
    }
    
    [self.xlDosaicContentImgView addGestureRecognizer:self.xlPanGesture];
    self.xlDosaicContentImgView.userInteractionEnabled = YES;
    self.xlDosaicContentImgView.layer.shouldRasterize = YES;
    self.xlDosaicContentImgView.layer.minificationFilter = kCAFilterTrilinear;
    
    _xlMosaicScrollView = [self getSuperScrollViewForView:self.xlMosaicImgView];
    
    _userInteractionEnabled = self.xlMosaicImgView.userInteractionEnabled;
    self.xlMosaicImgView.userInteractionEnabled = YES;
    
    if (_xlMosaicScrollView ) {
        _minimumNumberOfTouches = _xlMosaicScrollView.panGestureRecognizer.minimumNumberOfTouches;
        _delaysTouchesBegan = _xlMosaicScrollView.panGestureRecognizer.delaysTouchesBegan;
        
        _xlMosaicScrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
        _xlMosaicScrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    }
    
    if (mosaicPaths.count > 0) {
        [self.xlMosaicPathArray addObjectsFromArray:mosaicPaths];
        [self.xlMosaicPathArray addObjectsFromArray:mosaicPaths];
        [self drawMosaicForAllPath];
    }
}

-(void)xlResetMosaic{
    [_xlMosaicPathArray removeAllObjects];
    [self drawMosaicForAllPath];
    _xlMosaicImage = nil;
}
/// 结束马赛克
-(void)xlEndMosaic{
    if (self.xlPanGesture) {
        self.xlPanGesture.enabled = NO;
    }
    if (self.xlMosaicScrollView ) {
        _xlMosaicScrollView.panGestureRecognizer.minimumNumberOfTouches = _minimumNumberOfTouches;
        _xlMosaicScrollView.panGestureRecognizer.delaysTouchesBegan = _delaysTouchesBegan;
    }
    
    self.xlMosaicImgView.userInteractionEnabled = self.userInteractionEnabled;
    
    _xlMosaicImage = nil;
    [_xlDosaicContentImgView removeFromSuperview];
    _xlDosaicContentImgView = nil;
    
    [_xlMosaicPathArray removeAllObjects];
}

#pragma mark - Operation Revoke/Resume
/// 撤销：全部
-(void)xlCancelMosaic{
    [self.xlMosaicPathArray removeAllObjects];
    [self drawMosaicForAllPath];
}

/// 上一步/下一步：单步撤回、恢复
-(void)xlPreviousStep{
    if (self.xlMosaicPathArray) {
        [self.xlMosaicPathArray removeLastObject];
        [self drawMosaicForAllPath];
    }
}

-(void)xlNextStep{
    
}

#pragma mark - Draw Mosaic Pan
-(void)xlMosaicPanGestureRecognizer:(UIPanGestureRecognizer*)gesture{
    CGPoint draggingPosition = [gesture locationInView:gesture.view];

    if(gesture.state == UIGestureRecognizerStateBegan) {
        if(self.forMosaic && self.shapeLayer == nil){
            self.shapeLayer = [CAShapeLayer layer];
            self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
            self.shapeLayer.fillColor = nil;
            CGFloat width = 3.0f * [UIScreen mainScreen].scale;
            self.shapeLayer.lineWidth = width;
            _xlDosaicContentImgView.image = self.xlFullMosaicImage;
            _xlDosaicContentImgView.layer.mask = self.shapeLayer;
            // 需设置成黑色，偶现不分马赛克位置是透明的
            _xlDosaicContentImgView.backgroundColor = [UIColor blackColor];
        }
        
        // 初始化一个UIBezierPath对象, 把起始点存储到UIBezierPath对象中, 用来存储所有的轨迹点
        XLMosaicPath *path = [XLMosaicPath xlPathWithStartPoint:draggingPosition strokeWidth:self.xlStrokeWidth color:self.xlStrokeColor];
        [self.xlMosaicPathArray addObject:path];
        if (self.xlMosaicDelegate &&
            [self.xlMosaicDelegate respondsToSelector:@selector(xlImageMosaicBegain:)]) {
            [self.xlMosaicDelegate xlImageMosaicBegain:self];
        }
    } else if(gesture.state == UIGestureRecognizerStateChanged) {
        ///  获得数组中的最后一个UIBezierPath对象
        /// (因为我们每次都把UIBezierPath存入到数组最后一个,因此获取时也取最后一个)
        XLMosaicPath *path = self.xlMosaicPathArray.lastObject;
        [path addLineToPoint:draggingPosition];
        [self drawMosaicForAllPath];
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.xlMosaicDelegate &&
            [self.xlMosaicDelegate respondsToSelector:@selector(xlImageMosaicEnd:)]) {
            [self.xlMosaicDelegate xlImageMosaicEnd:self];
        }
    }
}

// TODO： 暂时没有用到的地方
-(void)drawMosaicForCancel{
    if (self.xlOldMosaicPathArray.count > 0) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = self.xlMosaicImgView.frame.size;
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        //去掉锯齿
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        for (XLMosaicPath *path in self.xlOldMosaicPathArray) {
            [path drawPathInCurrentImageContext];
        }
        self.xlMosaicImage = UIGraphicsGetImageFromCurrentImageContext();
        self.xlDosaicContentImgView.image = self.xlMosaicImage;
        UIGraphicsEndImageContext();
    } else {
        self.xlDosaicContentImgView.image = nil;
        self.xlMosaicImage = nil;
    }
    
}

-(void)drawMosaicForAllPath{
    if(self.forMosaic){
        [self p_drawMosaicForAllPath];
    } else {
        [self p_graffitiForAllPath];
    }
}

-(void)p_drawMosaicForAllPath{
    
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    
    for (XLMosaicPath *path in self.xlMosaicPathArray) {
//        [path drawPathInCurrentImageContext];
        CGPathAddPath(mutablePath, nil, path.CGPath);
    }
    self.shapeLayer.path = mutablePath;
}

// 涂鸦
-(void)p_graffitiForAllPath{
    @autoreleasepool {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize size = self.xlMosaicImgView.frame.size;
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        //去掉锯齿
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        for (XLMosaicPath *path in self.xlMosaicPathArray) {
            [path drawPathInCurrentImageContext];
        }
        
        self.xlDosaicContentImgView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
}

/// 涂鸦后的图片
-(UIImage *)xlmosaicImage{
    if (self.xlMosaicPathArray.count > 0) {
        if(!_xlMosaicImage){
            CGSize originalSize = self.xlMosaicImgView.frame.size;
            CGFloat scale = [UIScreen mainScreen].scale;
            UIGraphicsBeginImageContextWithOptions(originalSize, NO, scale);
//            [self.xlMosaicImgView.image drawAtPoint:CGPointZero];
            [self.xlMosaicImgView.image drawInRect:CGRectMake(0, 0, originalSize.width, originalSize.height)];

            [self.xlDosaicContentImgView.layer renderInContext:UIGraphicsGetCurrentContext()];
            _xlMosaicImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        return _xlMosaicImage;
    } else {
        return nil;
    }
}

- (NSArray<XLMosaicPath *> *)xlImageMosaicPathArray{
    return [self.xlMosaicPathArray copy];
}
@end

@implementation XLMosaicPath

/// 初始化路径
/// @param startPoint <#startPoint description#>
/// @param strokeWidth <#strokeWidth description#>
/// @param color <#color description#>
+(instancetype)xlPathWithStartPoint:(CGPoint)startPoint
                        strokeWidth:(CGFloat)strokeWidth
                              color:(UIColor *)color{
    XLMosaicPath *maosaicPath = [XLMosaicPath bezierPath];
    
    maosaicPath.lineWidth     = strokeWidth;
    maosaicPath.lineCapStyle  = kCGLineCapRound;
    maosaicPath.lineJoinStyle = kCGLineJoinRound;
    
    [maosaicPath moveToPoint:startPoint];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineCap      = kCALineCapRound;
    shapeLayer.lineJoin     = kCALineJoinRound;
    shapeLayer.lineWidth    = strokeWidth;
    shapeLayer.fillColor    = [UIColor clearColor].CGColor;
    shapeLayer.path         = maosaicPath.CGPath;
    
    maosaicPath.xlShape         = shapeLayer;
    maosaicPath.xlStrokeColor   = color;
    return maosaicPath;
}

-(void)addLineToPoint:(CGPoint)point{
    [super addLineToPoint:point];
    self.xlShape.path = self.CGPath;
}

-(void)drawPathInCurrentImageContext{
    [self.xlStrokeColor set];
    [self stroke];
}

@end
