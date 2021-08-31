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
#import "XLSystemMacro.h"
#import "UIView+XLAdditions.h"
#import "NSObject+XLCategory.h"
#import "XLMacroLayout.h"
#import "XLImageEditView.h"
#import "XLFileTools.h"
#import "XLMacroFont.h"
#import "XLAdaptation.h"
#import <SDWebImage/UIView+WebCache.h>
#import "XLAlertView.h"

typedef NS_ENUM(NSInteger, XLPreviewOPButtonTag) {
    XLPreviewOPButtonTagMore,
    XLPreviewOPButtonTagDel,
    XLPreviewOPButtonTagEdit,
    XLPreviewOPButtonTagDownload
};

/// 管理类：
@interface XLImagePreviewManager : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, XLImageEditViewDelegate>
@property (nonatomic, strong) NSMutableArray    *previewInfoArray; // 预览信息列表

/// 图片预览开始及结束时的黑色背景，仿微信效果
@property (nonatomic, strong) UIView            *backgroundView;
/// 动画过渡view
@property (nonatomic, strong) UIImageView       *transitionImgView;
@property (nonatomic, strong) UICollectionView  *xlCollectionView;  /// 预览展示

@property (nonatomic, strong) UILabel           *xlCountLabel;      /// 计数
@property (nonatomic, strong) UIView            *bottomOpBgView;
@property (nonatomic, strong) UIButton          *xlMoreButton;      /// 更多按钮
@property (nonatomic, strong) UIButton          *xlEditButton;      /// 编辑按钮
@property (nonatomic, strong) UIButton          *xlDeleteButton;    /// 删除按钮
@property (nonatomic, strong) UIButton          *xlDowloadButton;   /// 下载按钮

/// 可见区域View：用于图片预览销毁时判断动画执行，多张图片时有效，且为预览参数为ImageView类型
@property (nonatomic, weak)   UIView            *visibleView;
@property (nonatomic, assign) NSInteger         selelctIndex;       /// 选中位置
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) NSInteger         currentIndex;
@property (nonatomic, assign) XLPreviewItemType previewItemType;

@property (nonatomic, weak) id<XLImagePreviewProtocol> xlDelegate;
@property (nonatomic, weak) id<XLImagePreviewDataSource> xlDataSource;

@property (nonatomic, assign) XLImagePreviewOpItems currentPreviewOpItems; /// 当前预览状态

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

-(UIButton *)xlMoreButton{
    if (_xlMoreButton == nil) {
        _xlMoreButton = [self createOpButtonWithImgName:@"nav_more_hor_icon" title:nil];
        _xlEditButton.tag = XLPreviewOPButtonTagMore;
    }
    return _xlMoreButton;
}

-(UIButton *)xlDeleteButton{
    if (_xlDeleteButton == nil) {
        _xlDeleteButton = [self createOpButtonWithImgName:@"nav_more_hor_icon" title:nil];
        _xlDeleteButton.tag = XLPreviewOPButtonTagDel;
    }
    return _xlDeleteButton;
}

-(UIButton *)xlEditButton{
    if (_xlEditButton == nil) {
        _xlEditButton = [self createOpButtonWithImgName:@"nav_more_hor_icon" title:nil];
        _xlEditButton.tag = XLPreviewOPButtonTagEdit;
    }
    return _xlEditButton;
}

-(UIButton *)xlDowloadButton{
    if (_xlDowloadButton == nil) {
        _xlDowloadButton = [self createOpButtonWithImgName:@"nav_more_hor_icon" title:nil];
        _xlDowloadButton.tag = XLPreviewOPButtonTagDownload;
        [self.xlDowloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bottomOpBgView.mas_left).offset(XLHMinSpace);
            make.centerY.mas_equalTo(self.bottomOpBgView);
        }];
    }
    return _xlDowloadButton;
}

-(void)setXLMoreButtonHidden:(BOOL)hidden{
    self.xlMoreButton.hidden = hidden;
    if (!hidden) {
        [self.xlMoreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bottomOpBgView).offset(-XLHMargin);
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
            make.centerY.mas_equalTo(self.bottomOpBgView);
        }];
    }
}

-(void)setXLDeleteButtonHidden:(BOOL)hidden{
    self.xlDeleteButton.hidden = hidden;
    if (!hidden) {
        [self.xlDeleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (_xlMoreButton && !_xlMoreButton.hidden) {
                make.right.mas_equalTo(self.xlMoreButton.mas_left).offset(-XLHMinSpace);
            } else {
                make.right.mas_equalTo(self.bottomOpBgView).offset(-XLHMargin);
            }
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
            make.centerY.mas_equalTo(self.bottomOpBgView);
        }];
    }
}

-(void)setXLEditButtonHidden:(BOOL)hidden{
    self.xlEditButton.hidden = hidden;
    if (!hidden) {
        [self.xlEditButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (_xlDeleteButton && !_xlDeleteButton.hidden) {
                make.right.mas_equalTo(self.xlDeleteButton.mas_left).offset(-XLHMinSpace);
            } else if(_xlMoreButton && !_xlMoreButton.hidden){
                make.right.mas_equalTo(self.xlMoreButton.mas_left).offset(-XLHMinSpace);
            } else {
                make.right.mas_equalTo(self.bottomOpBgView).offset(-XLHMargin);
            }
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
            make.centerY.mas_equalTo(self.bottomOpBgView);
        }];
    }
}

-(void)setXLDowloadButtonHidden:(BOOL)hidden{
    self.xlDowloadButton.hidden = hidden;
}

-(UIButton *)createOpButtonWithImgName:(NSString *)imgName title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (![NSString isEmpty:imgName]) {
        UIImage *iconImg = [UIImage imageNamed:imgName];
        [button setImage:iconImg forState:UIControlStateNormal];
    }
    if (![NSString isEmpty:title]) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    [self.bottomOpBgView addSubview:button];
    return button;
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
        
        _transitionImgView = [[UIImageView alloc] init];
        _transitionImgView.backgroundColor = [UIColor blackColor];
        
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
        
        _bottomOpBgView = [[UIView alloc] init];
        _bottomOpBgView.backgroundColor = [UIColor clearColor];
        _bottomOpBgView.hidden = YES;
        
        _xlCountLabel = [[UILabel alloc] init];
        _xlCountLabel.font = XLFont(14.0f);
        _xlCountLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

/// 添加预览事件回调
/// @param delegate <#delegate description#>
-(void)addPreivewDelegate:(id<XLImagePreviewProtocol>)delegate{
    _xlDelegate = delegate;
}

#pragma mark - Menu Button Event
/// 长按事件
/// @param gesture <#gesture description#>
-(void)longPressGesture:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.xlDelegate &&
            [self.xlDelegate respondsToSelector:@selector(showLongPressOperationAtIndex:)]) {
            if (![self.xlDelegate showLongPressOperationAtIndex:self.currentIndex]) {
                return;
            }
        }
        if([self.xlDelegate respondsToSelector:@selector(longPressOperationClickAtIndex:)]){
            [self.xlDelegate longPressOperationClickAtIndex:self.currentIndex];
        }
    }
}

-(void)bottomButtonClick:(UIButton *)button{
    if (button.tag == XLPreviewOPButtonTagMore) {
        [self moreMenuForPreviewAtIndex:self.currentIndex];
    } else if (button.tag == XLPreviewOPButtonTagDel){
        [self deleteMenuForPreviewAtIndex:self.currentIndex];
    } else if (button.tag == XLPreviewOPButtonTagEdit){
        [self editMenuForPreviewAtIndex:self.currentIndex];
    } else if (button.tag == XLPreviewOPButtonTagDownload){
        [self dowloadForPreviewAtIndex:self.currentIndex];
    }
}

/// 预览图片更多操作事件回调
-(void)dowloadForPreviewAtIndex:(NSInteger)index{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(dowloadOperationClickAtIndex:)]) {
        if([self.xlDelegate respondsToSelector:@selector(dowloadOperationClickAtIndex:)]){
            [self.xlDelegate dowloadOperationClickAtIndex:index];
        }
    }
}
  
-(void)editMenuForPreviewAtIndex:(NSInteger)index{
    /// 编辑按钮
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(imageForEditAtIndex:)]) {
        UIImage *image = [self.xlDelegate imageForEditAtIndex:self.currentIndex];
        if (image) {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            [XLImageEditView showImageEditView:image inView:window delegate:self];
        }
    }
}

-(void)deleteMenuForPreviewAtIndex:(NSInteger)index{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(deleteTipsInfo:)]) {
        NSString *tips = [self.xlDelegate deleteTipsInfo:index];
        [self deletePreviewImageWithTips:tips atIndex:index];
    } else {
        [self deleteItemForPreviewAtIndex:index];
    }
}

/// 更多按钮点击
-(void)moreMenuForPreviewAtIndex:(NSInteger)index{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(moreOperationClickAtIndex:)]) {
        if([self.xlDelegate respondsToSelector:@selector(moreOperationClickAtIndex:)]){
            [self.xlDelegate moreOperationClickAtIndex:index];
        }
    }
}

-(void)deleteItemForPreviewAtIndex:(NSInteger)index{
    /// 删除按钮
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(deleteOperationClickAtIndex:)]) {
        [self.xlDelegate deleteOperationClickAtIndex:self.currentIndex];
        [self.previewInfoArray removeObjectAtIndex:self.currentIndex];
        if (self.previewInfoArray.count == 0) {
            [self previewDisappearForDefault];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            [self.xlCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
}

-(void)deletePreviewImageWithTips:(NSString *)tips atIndex:(NSInteger)index{
    XLAlertView *alert = [XLAlertView alertWithTitle:nil message:tips preferredStyle:UIAlertControllerStyleActionSheet];
    
    XLAlertAction *action = [XLAlertAction actionWithTitle:XLNSLocalized(@"确定") style:UIAlertActionStyleDefault handler:^(XLAlertAction * _Nonnull action) {
        [self deleteItemForPreviewAtIndex:index];
    }];
    [alert addAction:action];
    
    action = [XLAlertAction actionWithTitle:XLNSLocalized(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert xlShow];
}

#pragma mark - XLImageEditViewDelegate <NSObject>
-(void)imageEditViewComplete:(UIImage *)editImage{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(editCompleteForPreviewAtIndex:image:)]) {
        [self.xlDelegate editCompleteForPreviewAtIndex:self.currentIndex image:editImage];
        XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.currentIndex];
        
        info.originalImage = editImage;
        info.previewItemType = XLPreviewItemImage;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [self.xlCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}
-(void)imageEditViewCancel{
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
    [self previewImageViewArray:@[imageView] atSelectIndex:0 visibleView:nil];
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

/// 图片预览
/// @param previewImageView <#previewImageView description#>
/// @param atIndex <#atIndex description#>
/// @param visibleView <#visibleView description#>
/// @param dataSource <#dataSource description#>
-(void)previewImageViewAtIndex:(NSInteger)atIndex
                   visibleView:(UIView *)visibleView
                      delegate:(id<XLImagePreviewDataSource>)dataSource{
    
    if (dataSource != nil) {
        _selelctIndex = atIndex;
        _visibleView = visibleView;
        _xlDataSource = dataSource;
        [self initRreviewImageInfoWithDataSource];
        [self showRreviewImageInfo];
    }
}

/// 初始化预览图片：通过代理获取预览图片
-(void)initRreviewImageInfoWithDataSource{
    NSInteger count = [self.xlDataSource countOfPreviewImage];
    _previewItemType = XLPreviewItemSDImageView;
    for (NSInteger index = 0; index < count; index ++) {
        XLPreviewItemInfo *itemInfo = [[XLPreviewItemInfo alloc] init];
        UIImageView *imageView = [self.xlDataSource visablePreviewImageAtIndex:index];
        if (imageView) {
            NSString *path = [self.xlDataSource visablePreviewImagePathAtIndex:index];
            if([NSString isEmpty:path]){
                [itemInfo setPreviewImageView:imageView path:nil atIndex:index];
            } else {
                [itemInfo setPreviewSDImageView:imageView path:path atIndex:index];
            }
        } else {
            NSObject *object = [self.xlDataSource invisablePreviewImageAtIndex:index];
            if ([object isKindOfClass:[NSString class]]) {
                [itemInfo setInvisablePreviewImageUrl:(NSString *)object atVisiableView:self.visibleView atIndex:index];
            } else {
                [itemInfo setInvisablePreviewImage:(UIImage *)object atVisiableView:self.visibleView atIndex:index];
            }
        }
        [self.previewInfoArray addObject:itemInfo];
    }
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
            NSString *path = imageView.sd_imageURL.absoluteString;
            [itemInfo setPreviewSDImageView:imageView path:path atIndex:index];
        } else if (itemType == XLPreviewItemImageView){
            UIImageView *imageView = [imageArrayCopy objectAtIndex:index];
            [itemInfo setPreviewImageView:imageView path:nil atIndex:index];
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
    
    [window addSubview:self.bottomOpBgView];
    [self.bottomOpBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(window).offset(-15.0f);
        if (XLAvailableiOS11) {
            make.bottom.mas_equalTo(window.mas_safeBottom).offset(-15.0f);
        } else {
            make.bottom.mas_equalTo(window.mas_bottom).offset(-15.0f);
        }
        make.left.mas_equalTo(window);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.xlCollectionView reloadData];
    if (self.previewItemType == XLPreviewItemImageView ||
        self.previewItemType == XLPreviewItemSDImageView) {
        [self showAnimateInView:window];
    } else {
        self.xlCollectionView.hidden = NO;
    }
    
    [window addSubview:self.xlCountLabel];
    [self.xlCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(window);
        if (XLAvailableiOS11) {
            make.top.mas_equalTo(window.mas_safeTop).offset(15.0f);
        } else {
            make.top.mas_equalTo(window.mas_top).offset(15.0f);
        }
    }];
}

/// 显示预览开始动画
/// @param view <#view description#>
-(void)showAnimateInView:(UIView *)view{
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.selelctIndex];
    
    [view addSubview:self.backgroundView];
    self.transitionImgView.image = info.originalImage;
    self.transitionImgView.contentMode = info.contentMode;
    self.transitionImgView.frame = info.originalFrame;
    [view addSubview:self.transitionImgView];
    [UIView animateWithDuration:0.35f animations:^{
        [self enlargeOriginalView:info inView:view];
    } completion:^(BOOL finished) {
        [self.xlCollectionView.superview bringSubviewToFront:self.xlCollectionView];
        [self.bottomOpBgView.superview bringSubviewToFront:self.bottomOpBgView];
        [self.xlCountLabel.superview bringSubviewToFront:self.xlCountLabel];
        self.xlCollectionView.hidden = NO;
        self.transitionImgView.hidden = YES;
    }];
}

/// 销毁预览页面
-(void)destoryPreviewCollectionView{
    self.xlCollectionView.hidden = YES;
    [self.xlCollectionView removeFromSuperview];
    self.xlCollectionView = nil;
    self.bottomOpBgView.hidden = YES;
    [self.bottomOpBgView removeFromSuperview];
    self.bottomOpBgView = nil;
    [self.xlCountLabel removeFromSuperview];
    self.xlCountLabel = nil;
}

/// 移除背景
-(void)removeBackgroundView{
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.transitionImgView removeFromSuperview];
    self.transitionImgView = nil;
    [self.bottomOpBgView removeFromSuperview];
    self.bottomOpBgView = nil;
    
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(imagePreviewCanceled)]) {
        [self.xlDelegate imagePreviewCanceled];
    }
}

/// 释放预览信息
-(void)releasePreviewInfo{
    [self.previewInfoArray removeAllObjects];
    previewManager = nil;
}

/// 图片恢复:恢复指定图片缩放状态
-(void)recoveryPreviewInfo{
    self.transitionImgView.transform = CGAffineTransformIdentity;
}

/// 隐藏预览
/// @param gesture gesture description
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
    
    /// 当前预览可见cell：实际上只有一个
    XLImagePreviewCell *cell = [self.xlCollectionView visibleCells].lastObject;
    UIImageView *previewView = cell.previewView.previewImageView;
    
    self.transitionImgView.image = previewView.image;
    
    /// 2.销毁预览页面
    [self destoryPreviewCollectionView];
    
    /// 3.计算中心位置
    CGRect oldFrame = info.originalFrame;
    CGPoint center = CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2, oldFrame.origin.y + oldFrame.size.height / 2);
    self.transitionImgView.hidden = NO;
    [UIView animateWithDuration:0.35f animations:^{
        self.transitionImgView.center = center;
        self.transitionImgView.frame = info.originalFrame;
        self.transitionImgView.clipsToBounds = YES;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        [self releasePreviewInfo];
    }];
}

/// View中可见图片消失:最终预览图片非选中图片，将原图放大后再次执行恢复操作
-(void)previewDisappearForVisable{
    /// 1.首次选中图片恢复:注意顺序
    /// 如果恢复操作在步骤2中的bringPreviewToFront之后
    /// 两张图片控件的父类分支有重叠，则会导致动画结束后resetPreviewZPosition操作结果错误
    [self recoveryPreviewInfo];
    
    /// 当前预览可见cell：实际上只有一个
    XLImagePreviewCell *cell = [self.xlCollectionView visibleCells].lastObject;
    UIImageView *previewView = cell.previewView.previewImageView;
    self.transitionImgView.image = previewView.image;
    
    /// 2.设置当前预览图片放大处理
    XLPreviewItemInfo *currentInfo = [self.previewInfoArray objectAtIndex:self.currentIndex];
    [self enlargeOriginalView:currentInfo inView:nil];
    
    /// 当前预览View销毁
    [self destoryPreviewCollectionView];
    self.transitionImgView.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect currentFrame = currentInfo.originalFrame;
        CGPoint currentCenter = CGPointMake(currentFrame.origin.x + currentFrame.size.width / 2, currentFrame.origin.y + currentFrame.size.height / 2);
        self.transitionImgView.center = currentCenter;
        self.transitionImgView.frame = currentInfo.originalFrame;
        self.transitionImgView.clipsToBounds = YES;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        [self releasePreviewInfo];
    }];
}

/// 选中图片消失
-(void)previewDisappearForSelectIndex{
    /// 1.销毁预览页面
    [self destoryPreviewCollectionView];
    
    /// 2.恢复选中图片位置
    XLPreviewItemInfo *info = [self.previewInfoArray objectAtIndex:self.selelctIndex];
    CGRect oldFrame = info.originalFrame;
    CGPoint center = CGPointMake(oldFrame.origin.x + oldFrame.size.width / 2, oldFrame.origin.y + oldFrame.size.height / 2);
    self.transitionImgView.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.transitionImgView.center = center;
        self.transitionImgView.frame = oldFrame;
        self.transitionImgView.clipsToBounds = YES;
    } completion:^(BOOL finished) {
        [self removeBackgroundView];
        [self releasePreviewInfo];
    }];
}

/// 默认预览画面消失:按透明度慢慢隐去
-(void)previewDisappearForDefault{
    [UIView animateWithDuration:0.3f animations:^{
        self.xlCollectionView.alpha     = 0.0f;
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
    CGRect oldFrame = original.originalFrame;
    
    CGFloat widht = original.imageSize.width;
    CGFloat height = original.imageSize.height;
    if (oldFrame.size.width <= 0 ||
        oldFrame.size.height <= 0) {
        widht = XLScreenWidth;
        height = XLScreenHeight;
    } else {
        CGSize iamgeSize = original.imageSize;
        CGFloat xScale = XLScreenWidth / iamgeSize.width;
        CGFloat yScale = XLScreenHeight / iamgeSize.height;
        /// 按最大边缩放：值越小，边长越大
        if(xScale > yScale){
            xScale = yScale;
        } else {
            yScale = xScale;
        }
        
        widht = iamgeSize.width * xScale;
        height = iamgeSize.height * yScale;
    }
    
    
    self.transitionImgView.frame = CGRectMake(0, 0, widht, height);
    /// 计算最终位置
    if (!supperView) {
        supperView = [UIApplication sharedApplication].delegate.window;
    }
    CGPoint center = supperView.center;
    CGRect endFrame = oldFrame;
    endFrame.origin.x = center.x - endFrame.size.width / 2.0f;
    endFrame.origin.y = center.y - endFrame.size.height / 2.0f;
    CGPoint center1 = CGPointMake(endFrame.origin.x + endFrame.size.width / 2.0f, endFrame.origin.y + endFrame.size.height / 2.0f);
    self.transitionImgView.center = center1;
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.previewInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLImagePreviewCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    XLPreviewItemInfo *itemInfo = [self.previewInfoArray objectAtIndex:index];
    cell.itemInfo = itemInfo;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(XLImagePreviewCell *)cell recoverPreviewView];
    _currentIndex = indexPath.row;
    
    self.xlCountLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)indexPath.row + 1, (long)self.previewInfoArray.count];
    
    if(self.xlDelegate &&
       [self.xlDelegate respondsToSelector:@selector(operationItemsForPreviewImageAtIndex:)]){
        XLImagePreviewOpItems opItems = [self.xlDelegate operationItemsForPreviewImageAtIndex:indexPath.row];
        if (self.currentPreviewOpItems != opItems){
            if (opItems == XLImagePreviewOpNone) {
                self.bottomOpBgView.hidden = YES;
            } else {
                self.bottomOpBgView.hidden = NO;
                [self setXLMoreButtonHidden:!(opItems & XLImagePreviewOpEdit)];
                [self setXLDeleteButtonHidden:!(opItems & XLImagePreviewOpEdit)];
                [self setXLEditButtonHidden:!(opItems & XLImagePreviewOpEdit)];
                
                if (opItems & XLImagePreviewOpDowload != self.currentPreviewOpItems & XLImagePreviewOpDowload) {
                    /// 不相同
                    [self setXLDowloadButtonHidden:!(opItems & XLImagePreviewOpDowload)];
                }
                if (opItems & XLImagePreviewOpDowload) {
                    if(self.xlDelegate &&
                       [self.xlDelegate respondsToSelector:@selector(orignialSizeOfRemoteImageAtIndexPath:)]){
                        CGFloat size = [self.xlDelegate orignialSizeOfRemoteImageAtIndexPath:indexPath.row];
                        NSString *sizeString = [XLFileTools fileSizeFormatWithLength:size];
                        NSString *title = [NSString stringWithFormat:@"查看原图%@", sizeString];
                        [self.xlDowloadButton setTitle:title forState:UIControlStateNormal];
                    }
                }
            }
            self.currentPreviewOpItems = opItems;
        }
        
    }
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

/// 图片预览
/// @param atIndex <#atIndex description#>
/// @param dataSource <#dataSource description#>
-(void)previewImageViewAtIndex:(NSInteger)atIndex
                      delegate:(id<XLImagePreviewDataSource>)dataSource{
    [[XLImagePreviewManager previewManager] previewImageViewAtIndex:atIndex visibleView:self.view delegate:dataSource];;
}
@end
