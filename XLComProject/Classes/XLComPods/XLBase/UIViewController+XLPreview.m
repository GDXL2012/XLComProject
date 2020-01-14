//
//  UIViewController+XLPreview.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UIViewController+XLPreview.h"
#import "XLImagePreviewCell.h"
#import "XLPreviewItemInfo.h"

#import "XLDeviceMacro.h"
#import "NSString+XLCategory.h"
#import "XLComMacro.h"
#import "Masonry.h"
#import <objc/runtime.h>

/// 管理类：
@interface XLImagePreviewManager : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, copy) NSMutableArray      *previewInfoArray; // 预览信息列表

/// 图片预览开始及结束时的黑色背景，开始是为了仿微信效果，后来发现这个暂时看必须添加，
/// 否则在预览过程中设置的图层层级及zPosition会导致页面显示错乱
@property (nonatomic, strong) UIView            *backgroundView;
@property (nonatomic, strong) UICollectionView  *xlCollectionView;  /// 预览展示

/// 可见区域View：用于图片预览销毁时判断动画执行，多张图片时有效，且为预览参数为ImageView类型
@property (nonatomic, weak)   UIView            *visibleView;
@property (nonatomic, assign) NSInteger         selelctIndex;       /// 选中位置
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) NSInteger         currentIndex;
@property (nonatomic, assign) XLPreviewItemType previewItemType;

@property (nonatomic, weak) id<XLImagePreviewProtocol> xlDelegate;

@end

static XLImagePreviewManager *previewManager;

@implementation XLImagePreviewManager

+(instancetype)previewManager{
    if (!previewManager) {
        previewManager = [[XLImagePreviewManager alloc] init];
    }
    return previewManager;
}

/// 取消图片预览
+(void)cancelImagePreview{
    if (previewManager) {
        [previewManager hiddenPreview:nil];
    }
}

-(void)dealloc{
    NSLog(@"XLImagePreviewManager dealloc");
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _previewInfoArray = [NSMutableArray array];
        
        _backgroundView = [[UIView alloc] initWithFrame:XLScreenBounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _xlCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _xlCollectionView.backgroundColor = [UIColor blackColor];
        _xlCollectionView.dataSource = self;
        _xlCollectionView.delegate = self;
        _xlCollectionView.pagingEnabled = YES;
        _xlCollectionView.scrollsToTop = NO;
        _xlCollectionView.showsHorizontalScrollIndicator = NO;
        _xlCollectionView.contentOffset = CGPointMake(0, 0);
        [_xlCollectionView registerClass:[XLImagePreviewCell class] forCellWithReuseIdentifier:@"XLImagePreviewCell"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPreview:)];
        [_xlCollectionView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [_xlCollectionView addGestureRecognizer:longPress];
    }
    return self;
}

/// 添加预览事件回调
/// @param delegate <#delegate description#>
-(void)addPreivewDelegate:(id<XLImagePreviewProtocol>)delegate{
    _xlDelegate = delegate;
}

/// 长按事件
/// @param gesture <#gesture description#>
-(void)longPressGesture:(UIGestureRecognizer *)gesture{
    if(self.xlDelegate &&
       [self.xlDelegate respondsToSelector:@selector(previewLongPressAtIndex:)]){
        [self.xlDelegate previewLongPressAtIndex:self.currentIndex];
    }
}

#pragma mark - SetPreview Info
/// 单张图片预览：默认从中间放大显示
/// @param image <#image description#>
-(void)preViewImage:(UIImage *)image{
    [self previewImageArray:@[image] atSelectIndex:0 visibleView:nil];
}

/// 单张网络图片预览：默认从中间放大显示
/// @param imageUrl <#imageUrl description#>
-(void)preViewImageUrl:(NSString *)imageUrl{
    [self previewImageUrlArray:@[imageUrl] atSelectIndex:0 visibleView:nil];
}

/// 单张图片预览：根据图片位置弹出
/// @param imageView imageView description
-(void)preViewImageView:(UIImageView *)imageView{
    [self previewSDImageViewArray:@[imageView] atSelectIndex:0 visibleView:nil];
}

/// 单张图片预览：弹出结合SDImageView库使用，显示网络图片
/// @param imageView <#imageView description#>
-(void)preViewSDImageView:(UIImageView *)imageView{
    [self previewSDImageViewArray:@[imageView] atSelectIndex:0 visibleView:nil];
}

/// 图片预览：默认从中间放大显示
/// @param imageArray ImageArray 图片列表
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageArray:(NSArray *)imageArray
           atSelectIndex:(NSInteger)selectIndex
             visibleView:(UIView *)visibleView{
    _selelctIndex = selectIndex;
    _visibleView = visibleView;
    [self initRreviewImageInfo:imageArray type:XLPreviewItemImage];
    [self showRreviewImageInfo];
}

/// 网络图片预览：默认从中间放大显示
/// @param imageUrlArray <#imageUrlArray description#>
/// @param selectIndex <#selectIndex description#>
-(void)previewImageUrlArray:(NSArray *)imageUrlArray
              atSelectIndex:(NSInteger)selectIndex
                visibleView:(UIView *)visibleView{
    _selelctIndex = selectIndex;
    _visibleView = visibleView;
    [self initRreviewImageInfo:imageUrlArray type:XLPreviewItemImageUrl];
    [self showRreviewImageInfo];
}

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray ImageViewArray 图片View列表
/// @param selectIndex <#selectIndex description#>
-(void)previewImageViewArray:(NSArray *)imageViewArray
               atSelectIndex:(NSInteger)selectIndex
                 visibleView:(UIView *)visibleView{
    _selelctIndex = selectIndex;
    _visibleView = visibleView;
    [self initRreviewImageInfo:imageViewArray type:XLPreviewItemImageView];
    [self showRreviewImageInfo];
}

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray 图片View列表：结合SDImageView库使用，显示网络图片
/// @param selectIndex 选中图片位置
-(void)previewSDImageViewArray:(NSArray *)imageViewArray
                 atSelectIndex:(NSInteger)selectIndex
                   visibleView:(UIView *)visibleView{
    _selelctIndex = selectIndex;
    _visibleView = visibleView;
    [self initRreviewImageInfo:imageViewArray type:XLPreviewItemSDImageView];
    [self showRreviewImageInfo];
}

/// 预览图片列表
/// @param imageInfoArray <#imageInfoArray description#>
/// @param itemType <#itemType description#>
-(void)initRreviewImageInfo:(NSArray *)imageInfoArray
                       type:(XLPreviewItemType)itemType{
    NSInteger count = imageInfoArray.count;
    NSArray *imageArrayCopy = [imageInfoArray copy];
    _previewItemType = itemType;
    for (NSInteger index = 0; index < count; index ++) {
        XLPreviewItemInfo *itemInfo = [[XLPreviewItemInfo alloc] init];
        if (itemType == XLPreviewItemSDImageView) {
            UIImageView *imageView = [imageArrayCopy objectAtIndex:index];
            [itemInfo setPreviewSDImageView:imageView atIndex:index];
        } else if (itemType == XLPreviewItemImageView){
            UIImageView *imageView = [imageArrayCopy objectAtIndex:index];
            [itemInfo setPreviewImageView:imageView atIndex:index];
        } else if (itemType == XLPreviewItemImageUrl){
            NSString *imageUrl = [imageArrayCopy objectAtIndex:index];
            [itemInfo setPreviewImageUrl:imageUrl atIndex:index];
        } else if (itemType == XLPreviewItemImage){
            UIImage *image = [imageArrayCopy objectAtIndex:index];
            [itemInfo setPreviewImage:image atIndex:index];
        }
        [self.previewInfoArray addObject:itemInfo];
    }
}

#pragma mark - show Preview View
-(void)showRreviewImageInfo{
    CGFloat paddingMargin = 10.0f;
    NSInteger count = self.previewInfoArray.count;
    CGFloat itemWidth = XLScreenWidth + paddingMargin * 2;
    CGFloat itemHeight = XLScreenHeight;
    CGFloat totalWidth = itemWidth * count;
    
    CGFloat xOffset = itemWidth * self.selelctIndex;
    
    self.layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    self.xlCollectionView.frame = CGRectMake(-paddingMargin, 0, itemWidth, itemHeight);
    self.xlCollectionView.hidden = YES;
    self.xlCollectionView.contentSize = CGSizeMake(totalWidth, itemHeight);
    self.xlCollectionView.contentOffset = CGPointMake(xOffset, 0.0f);
    [self.xlCollectionView setCollectionViewLayout:self.layout];
    
    if (self.selelctIndex > 0) {
        CGFloat offsetX = self.selelctIndex * self.layout.itemSize.width;
        [self.xlCollectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.xlCollectionView];
    
    [self.xlCollectionView reloadData];
    if (self.previewItemType == XLPreviewItemImageView ||
        self.previewItemType == XLPreviewItemSDImageView) {
        [self showAnimateInView:window];
    } else {
        self.xlCollectionView.hidden = NO;
    }
}

static const char XLLayerMasksKey       = '\0';
static const char XLLayerZPositionKey   = '\0';
/// 将图片发送到最前端:不同级View会出现遮挡问题，需要将preview分支的父类View图层调到最上层
/// @param preview <#preview description#>
-(void)bringPreviewToFront:(UIView *)preview{
    UIView *superView = preview.superview;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    BOOL isVisibleView = NO;
    while (superView && superView != window) {
        /// 可见图层内需要设置图层不被遮挡
        if (superView == self.visibleView) {
            /// 当父类是visibleView后，则图层遮挡不再处理，只处理图层剪切
            isVisibleView = YES;
        }
        if (!isVisibleView) {
            CGFloat zPosition = superView.layer.zPosition;
            objc_setAssociatedObject(superView, &XLLayerZPositionKey, @(zPosition), OBJC_ASSOCIATION_ASSIGN);
            superView.layer.zPosition = 998;
        }
        
        BOOL masks = superView.layer.masksToBounds;
        objc_setAssociatedObject(superView, &XLLayerMasksKey, @(masks), OBJC_ASSOCIATION_ASSIGN);
        superView.layer.masksToBounds = NO;
        
        superView = superView.superview;
    }
}

/// 恢复图层层级
/// @param preview <#preview description#>
-(void)resetPreviewZPosition:(UIView *)preview{
    UIView *superView = preview.superview;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    BOOL isVisibleView = NO;
    while (superView && superView != window) {
        /// 可见图层内需要设置图层不被遮挡
        if (superView == self.visibleView) {
            /// 当父类是visibleView后，则图层遮挡不再处理，只处理图层剪切
            isVisibleView = YES;
        }
        if (!isVisibleView) {
            superView.layer.zPosition = 0;
            NSNumber *zPosition = objc_getAssociatedObject(superView, &XLLayerZPositionKey);
            if (zPosition) {
                superView.layer.zPosition = zPosition.floatValue;
            }
        }
        
        /// 图层分支树中，需要将图层剪切去除，否则会导致图片缩放过程中出现剪切
        NSNumber *masks = objc_getAssociatedObject(superView, &XLLayerMasksKey);
        if (masks) {
            superView.layer.masksToBounds = masks.boolValue;
        }
        superView = superView.superview;
    }
}

/// 显示预览开始动画
/// @param view <#view description#>
-(void)showAnimateInView:(UIView *)view{
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.selelctIndex];
    UIView *originalView = info.originalPreviewInfo;
    originalView.layer.zPosition = 1000;
    [originalView.superview addSubview:self.backgroundView];
    self.backgroundView.layer.zPosition = 999;
    self.backgroundView.center = view.center;
    [self bringPreviewToFront:originalView];
    [UIView animateWithDuration:0.2f animations:^{
        [self enlargeOriginalView:info inView:view];
    } completion:^(BOOL finished) {
        self.xlCollectionView.hidden = NO;
    }];
}

/// 销毁预览页面
-(void)destoryPreviewCollectionView{
    self.xlCollectionView.hidden = YES;
    [self.xlCollectionView removeFromSuperview];
    self.xlCollectionView = nil;
}

/// 移除背景
-(void)removeBackgroundView{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

/// 释放预览信息
-(void)releasePreviewInfo{
    [self.previewInfoArray removeAllObjects];
    previewManager = nil;
}

/// 图片恢复:恢复指定图片缩放状态
-(void)recoveryPreviewInfoAtIndex:(NSInteger)selectIndex{
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:selectIndex];
    UIView *originalView = info.originalPreviewInfo;
    CGRect oldFrame = info.originalFrame;
    CGPoint center = CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2, oldFrame.origin.y + oldFrame.size.height / 2);
    originalView.transform = CGAffineTransformIdentity;
    originalView.layer.zPosition = 0;
    originalView.center = center;
    
    [self resetPreviewZPosition:originalView];
}

/// 隐藏预览
/// @param gesture <#gesture description#>
-(void)hiddenPreview:(UIGestureRecognizer *)gesture{
    if (self.previewItemType == XLPreviewItemImageView ||
        self.previewItemType == XLPreviewItemSDImageView) {
        if (self.currentIndex == self.selelctIndex || self.previewInfoArray.count == 1) {
            /// 选中图片即当前点击图片，直接执行
            [self previewDisappearForSelectIndex];
        } else {
            XLPreviewItemInfo *currentInfo = [self.previewInfoArray objectAtIndex:self.currentIndex];
            /// 在当前Window中的位置
            CGRect currentInfoFrame = currentInfo.originalFrame;
            CGRect viewFrame = self.visibleView.frame;
            if((CGRectGetMaxY(currentInfoFrame) < viewFrame.origin.y ||
               CGRectGetMinY(currentInfoFrame) > CGRectGetMaxY(viewFrame))){
                /// 不可见
                [self previewDisappearForInvisible];
            } else {
                /// 可见
                [self previewDisappearForVisable];
            }
        }
    } else {
        [self previewDisappearForDefault];
    }
}

-(void)removeAllView:(UIImageView *)previewView{
    [previewView removeFromSuperview];
    [self removeBackgroundView];
    [self releasePreviewInfo];
}

/// 不可见预览图片消失：最终预览图片在View中不可见，预览图片回到选中的预览图片位置
-(void)previewDisappearForInvisible{
    /// 1.设置预览图片
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.selelctIndex];
    UIImageView *originalView = (UIImageView *)info.originalPreviewInfo;
    
    XLImagePreviewCell *cell = [self.xlCollectionView visibleCells].lastObject;
    UIImageView *previewView = cell.previewView.previewImageView;
    
    UIImage *originalImage = originalView.image;
    originalView.image = previewView.image;
    
    /// 2.销毁预览页面
    [self destoryPreviewCollectionView];
    
    /// 3.计算中心位置
    CGRect oldFrame = info.originalFrame;
    CGPoint center = CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2, oldFrame.origin.y + oldFrame.size.height / 2);
    [UIView animateWithDuration:0.3f animations:^{
        originalView.center = center;
        originalView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        originalView.image = originalImage;
        [self removeBackgroundView];
        originalView.layer.zPosition = 0;
        [self releasePreviewInfo];
        [self resetPreviewZPosition:originalView];
    }];
}

/// 不可见预览图片消失：最终预览图片在View中不可见，预览图片回到选中的预览图片位置
/// 方法废弃，如果有导航栏，且图片被导航栏部分遮挡等类似情况
/// 图片预览消失时会出现图片将导航栏遮挡问题
-(void)previewDisappearForInvisible1 DEPRECATED_MSG_ATTRIBUTE("Please use [XLImagePreviewManager previewDisappearForInvisible]"){
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.selelctIndex];
    UIView *selectView = (UIImageView *)info.originalPreviewInfo;
    CGRect oldFrame = info.originalFrame;
    
    /// 预览图片机制，可见cell只会有一个
    XLImagePreviewCell *cell = [self.xlCollectionView visibleCells].lastObject;
    UIImageView *previewView = cell.previewView.previewImageView;
    /// 设置图片全部填充，否者图片会出现黑框等问题
    previewView.contentMode = UIViewContentModeScaleAspectFill;
    previewView.clipsToBounds = YES;
    
    UIView *superView = selectView.superview;
    CGRect newRect = [previewView.superview convertRect:oldFrame fromView:superView];
    CGSize imageSize = selectView.frame.size;
    CGSize previewSize = previewView.frame.size;
    /// 处理图片区域大小
    if (previewSize.width / previewSize.height > imageSize.width / imageSize.height) {
        /// 图片超宽
        previewSize.width = previewSize.height * imageSize.width / imageSize.height;
    } else {
        /// 图片超高
        previewSize.height = previewSize.width * imageSize.height / imageSize.width;
    }
    
    /// 处理预览图片截取
    if (previewSize.width / previewSize.height > oldFrame.size.width / oldFrame.size.height) {
        /// 图片超宽
        previewSize.width = previewSize.height * oldFrame.size.width / oldFrame.size.height;
    } else {
        /// 图片超高
        previewSize.height = previewSize.width * oldFrame.size.height / oldFrame.size.width;
    }
    CGRect previewFrame = previewView.frame;
    previewFrame.size = previewSize;
    CGPoint previewCenter = previewView.center;
    previewView.frame = previewFrame;
    previewView.center = previewCenter;
    
    /// 点击图片中心位置
    CGPoint newCenter = CGPointMake(newRect.origin.x + newRect.size.width / 2.0f, newRect.origin.y + newRect.size.height / 2.0f);
    
    previewView.layer.zPosition = 1001;
    [cell clearBackgroundColor];
    self.xlCollectionView.backgroundColor = [UIColor clearColor];
    /// 首次选中图片恢复
    [self recoveryPreviewInfoAtIndex:self.selelctIndex];
    [UIView animateWithDuration:0.2f animations:^{
        previewView.center = newCenter;
        previewView.frame = newRect;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        [self destoryPreviewCollectionView];
        [self releasePreviewInfo];
    }];
}

/// View中可见图片消失:最终预览图片非选中图片，将原图放大后再次执行恢复操作
-(void)previewDisappearForVisable{
    /// 1.首次选中图片恢复:注意顺序
    /// 如果恢复操作在步骤2中的bringPreviewToFront之后
    /// 两张图片控件的父类分支有重叠，则会导致动画结束后resetPreviewZPosition操作结果错误
    [self recoveryPreviewInfoAtIndex:self.selelctIndex];
    
    /// 2.设置当前预览图片放大处理
    XLPreviewItemInfo *currentInfo = [self.previewInfoArray objectAtIndex:self.currentIndex];
    UIView *currentView = currentInfo.originalPreviewInfo;
    currentView.layer.zPosition = 1000;
    [currentView.superview addSubview:self.backgroundView];
    self.backgroundView.layer.zPosition = 999;
    
    [self enlargeOriginalView:currentInfo inView:nil];
    [self bringPreviewToFront:currentView];
    
    /// 当前预览View销毁
    [self destoryPreviewCollectionView];
    [UIView animateWithDuration:0.2f animations:^{
        CGRect currentFrame = currentInfo.originalFrame;
        CGPoint currentCenter = CGPointMake(currentFrame.origin.x + currentFrame.size.width / 2, currentFrame.origin.y + currentFrame.size.height / 2);
        currentView.center = currentCenter;
        currentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        currentView.layer.zPosition = 0;
        [self releasePreviewInfo];
        [self resetPreviewZPosition:currentView];
    }];
}

/// 选中图片消失
-(void)previewDisappearForSelectIndex{
    /// 1.销毁预览页面
    [self destoryPreviewCollectionView];
    
    /// 2.恢复选中图片位置
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.selelctIndex];
    UIView *originalView = info.originalPreviewInfo;
    CGRect oldFrame = info.originalFrame;
    CGPoint center = CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2, oldFrame.origin.y + oldFrame.size.height / 2);
    
    [UIView animateWithDuration:0.3f animations:^{
        originalView.center = center;
        originalView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        originalView.layer.zPosition = 0;
        [self releasePreviewInfo];
        [self resetPreviewZPosition:originalView];
    }];
}

/// 默认预览画面消失:按透明度慢慢隐去
-(void)previewDisappearForDefault{
    [UIView animateWithDuration:0.2f animations:^{
        self.xlCollectionView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        [self destoryPreviewCollectionView];
        [self releasePreviewInfo];
    }];
}

/// 放大原图
/// @param original <#original description#>
/// @param supperView <#supperView description#>
-(void)enlargeOriginalView:(XLPreviewItemInfo *)original inView:(UIView *)supperView{
    UIView *originalView = original.originalPreviewInfo;
    CGRect oldFrame = original.originalFrame;
    CGFloat xScale = XLScreenWidth / oldFrame.size.width;
    CGFloat yScale = XLScreenHeight / oldFrame.size.height;
    /// 按最大边缩放：值越小，边长越大
    if(xScale > yScale){
        xScale = yScale;
    } else {
        yScale = xScale;
    }
    originalView.layer.transform = CATransform3DMakeScale(xScale, yScale, 1);
    CGPoint center;
    if (supperView) {
        center = supperView.center;
    } else {
        center = [UIApplication sharedApplication].delegate.window.center;
    }
    originalView.center = center;
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.previewInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLImagePreviewCell" forIndexPath:indexPath];
    
    XLPreviewItemInfo *itemInfo = [self.previewInfoArray objectAtIndex:indexPath.row];
    cell.itemInfo = itemInfo;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(XLImagePreviewCell *)cell recoverPreviewView];
    _currentIndex = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(XLImagePreviewCell *)cell recoverPreviewView];
}

@end

@implementation UIViewController (XLPreview)

/// 取消图片预览
-(void)cancelImagePreview{
    [XLImagePreviewManager cancelImagePreview];
}

/// 添加预览事件回调
/// @param delegate <#delegate description#>
-(void)addPreivewDelegate:(id<XLImagePreviewProtocol>)delegate{
    [[XLImagePreviewManager previewManager] addPreivewDelegate:delegate];
}

/// 单张图片预览：默认从中间放大显示
/// @param image <#image description#>
-(void)preViewImage:(UIImage *)image{
    [[XLImagePreviewManager previewManager] preViewImage:image];
}

/// 单张网络图片预览：默认从中间放大显示
/// @param imageUrl <#imageUrl description#>
-(void)preViewImageUrl:(NSString *)imageUrl{
    [[XLImagePreviewManager previewManager] preViewImageUrl:imageUrl];
}

/// 单张图片预览：根据图片位置弹出
/// @param imageView <#imageView description#>
-(void)preViewImageView:(UIImageView *)imageView{
    [[XLImagePreviewManager previewManager] preViewImageView:imageView];
}

/// 单张图片预览：弹出结合SDImageView库使用，显示网络图片
/// @param imageView <#imageView description#>
-(void)preViewSDImageView:(UIImageView *)imageView{
    [[XLImagePreviewManager previewManager] preViewSDImageView:imageView];
}

/// 图片预览：默认从中间放大显示
/// @param imageArray ImageArray 图片列表
/// @param selectIndex <#selectIndex description#>
-(void)previewImageArray:(NSArray *)imageArray
           atSelectIndex:(NSInteger)selectIndex{
    [self previewImageArray:imageArray
              atSelectIndex:selectIndex
                visibleView:self.view];
}

/// 网络图片预览：默认从中间放大显示
/// @param imageUrlArray <#imageUrlArray description#>
/// @param selectIndex <#selectIndex description#>
-(void)previewImageUrlArray:(NSArray *)imageUrlArray
              atSelectIndex:(NSInteger)selectIndex{
    [self previewImageUrlArray:imageUrlArray
                 atSelectIndex:selectIndex
                   visibleView:self.view];
}

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray ImageViewArray 图片View列表
/// @param selectIndex <#selectIndex description#>
-(void)previewImageViewArray:(NSArray *)imageViewArray
               atSelectIndex:(NSInteger)selectIndex{
    [self previewImageViewArray:imageViewArray
                  atSelectIndex:selectIndex
                    visibleView:self.view];
}

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray 图片View列表：结合SDImageView库使用，显示网络图片
/// @param selectIndex 选中图片位置
-(void)previewSDImageViewArray:(NSArray *)imageViewArray
                 atSelectIndex:(NSInteger)selectIndex{
    [self previewSDImageViewArray:imageViewArray
                    atSelectIndex:selectIndex
                      visibleView:self.view];
}

/// 图片预览：默认从中间放大显示
/// @param imageArray ImageArray 图片列表
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageArray:(NSArray *)imageArray
           atSelectIndex:(NSInteger)selectIndex
             visibleView:(UIView *)visibleView{
    [[XLImagePreviewManager previewManager] previewImageArray:imageArray
                                                atSelectIndex:selectIndex
                                                  visibleView:self.view];
}

/// 网络图片预览：默认从中间放大显示
/// @param imageUrlArray <#imageUrlArray description#>
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageUrlArray:(NSArray *)imageUrlArray
              atSelectIndex:(NSInteger)selectIndex
                visibleView:(UIView *)visibleView{
    [[XLImagePreviewManager previewManager] previewImageUrlArray:imageUrlArray
                                                   atSelectIndex:selectIndex
                                                     visibleView:visibleView];
}

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray ImageViewArray 图片View列表
/// @param selectIndex <#selectIndex description#>
/// @param visibleView 可见区域View
-(void)previewImageViewArray:(NSArray *)imageViewArray
               atSelectIndex:(NSInteger)selectIndex
                 visibleView:(UIView *)visibleView{
    [[XLImagePreviewManager previewManager] previewImageViewArray:imageViewArray
                                                    atSelectIndex:selectIndex
                                                      visibleView:visibleView];
}

/// 多张图片预览：根据图片位置弹出
/// @param imageViewArray 图片View列表：结合SDImageView库使用，显示网络图片
/// @param selectIndex 选中图片位置
/// @param visibleView 可见区域View
-(void)previewSDImageViewArray:(NSArray *)imageViewArray
                 atSelectIndex:(NSInteger)selectIndex
                   visibleView:(UIView *)visibleView{
    [[XLImagePreviewManager previewManager] previewSDImageViewArray:imageViewArray
                                                      atSelectIndex:selectIndex
                                                        visibleView:visibleView];
}
@end
