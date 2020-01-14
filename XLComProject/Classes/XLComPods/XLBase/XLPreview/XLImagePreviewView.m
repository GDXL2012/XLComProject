//
//  XLImagePreviewView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/12/1.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLImagePreviewView.h"
#import "Masonry.h"
#import "XLDeviceMacro.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "NSString+XLCategory.h"
#import "XLComMacro.h"
#import "XLComPods.h"

@interface XLImagePreviewView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView; // 菊花View
@property (nonatomic, strong) UIImageView    *previewImageView;  /// 预览图片
@property (nonatomic, strong) UIScrollView   *xlScrollView;

@end

@implementation XLImagePreviewView

-(UIView *)previewView{
    return _xlScrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _xlScrollView = [[UIScrollView alloc] init];
        _xlScrollView.bouncesZoom = YES;
        _xlScrollView.maximumZoomScale = 2.5;
        _xlScrollView.minimumZoomScale = 1.0;
        _xlScrollView.multipleTouchEnabled = YES;
        _xlScrollView.delegate = self;
        _xlScrollView.scrollsToTop = NO;
        _xlScrollView.showsHorizontalScrollIndicator = NO;
        _xlScrollView.showsVerticalScrollIndicator = YES;
        _xlScrollView.delaysContentTouches = NO;
        _xlScrollView.canCancelContentTouches = YES;
        _xlScrollView.alwaysBounceVertical = NO;
        [self addSubview:_xlScrollView];
        
        [_xlScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(10.0f);
            make.right.mas_equalTo(self).offset(-10.0f);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
        
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.backgroundColor = [UIColor blackColor];
        _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.xlScrollView addSubview:_previewImageView];
        [_previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.xlScrollView);
            make.top.mas_equalTo(self.xlScrollView);
            make.bottom.mas_equalTo(self.xlScrollView);
            make.right.mas_equalTo(self.xlScrollView);
            make.size.mas_equalTo(self.xlScrollView);
        }];
    }
    return self;
}

/// 清理背景
-(void)clearBackgroundColor{
    self.xlScrollView.backgroundColor = [UIColor clearColor];
    self.previewImageView.backgroundColor = [UIColor clearColor];
}

-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.previewImageView addSubview:_indicatorView];
        _indicatorView.frame= CGRectMake(100, 100, 30, 30);
        _indicatorView.color = [UIColor whiteColor];
        _indicatorView.backgroundColor = [UIColor blackColor];
        _indicatorView.hidesWhenStopped = YES;
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.previewImageView);
            make.centerY.mas_equalTo(self.previewImageView);
            make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        }];
    }
    return _indicatorView;
}

-(void)setItemInfo:(XLPreviewItemInfo *)itemInfo{
    if (_itemInfo != itemInfo) {
        _itemInfo = itemInfo;
        self.itemInfo.previewHasShow = NO;
        [self setPreviewHasShow:YES];
    }
}

/// 设置预览图片显示
/// @param previewHasShow <#previewHasShow description#>
-(void)setPreviewHasShow:(BOOL)previewHasShow{
    if (!self.itemInfo.previewHasShow && previewHasShow) {
        /// 设置预览图片显示
        self.itemInfo.previewHasShow = previewHasShow;
        if (self.itemInfo.previewItemType == XLPreviewItemImage) {
            UIImage *image = (UIImage *)self.itemInfo.originalPreviewInfo;
            self.previewImageView.image = image;
        } else if (self.itemInfo.previewItemType == XLPreviewItemImageView) {
            UIImageView *imageView = (UIImageView *)self.itemInfo.originalPreviewInfo;
            self.previewImageView.image = imageView.image;
        } else if (self.itemInfo.previewItemType == XLPreviewItemSDImageView) {
            [self showPreviewSDImageView];
        } else if (self.itemInfo.previewItemType == XLPreviewItemImageUrl) {
            /// 显示图片
            [self showPreviewImageUrl];
        }
    }
}

-(void)showPreviewSDImageView{
    /// 预览图片初始化
    UIImageView *originalImageView = (UIImageView *)self.itemInfo.originalPreviewInfo;
    NSString *imgPath = [originalImageView.sd_imageURL absoluteString];
    if (![NSString isEmpty:imgPath]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        id<XLComConfigDelegate> delegate = [XLComPods manager].comConfig.xlConfigDelegate;
        NSString *original = imgPath;
        if (delegate &&
            [delegate respondsToSelector:@selector(originalRemotePathFromUrl:)]) {
            original = [delegate originalRemotePathFromUrl:original];
        }
        
        NSURL *url = [NSURL URLWithString:original];
        XLWeakSelf
        [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
            XLStrongSelf
            if (!isInCache) {
                [strongSelf.indicatorView startAnimating];
            }
            [self.previewImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                XLStrongSelf
                [strongSelf.indicatorView stopAnimating];
                if (error) { /// 图片加载失败
                    UIImage *image = [XLComPods manager].comConfig.loadingFaileImage;
                    strongSelf.previewImageView.image = image;
                } else {
                    /// 加载成功，赋值原图片
                    UIImageView *originalView = (UIImageView *)strongSelf.itemInfo.originalPreviewInfo;
                    [originalView sd_setImageWithURL:url];
                }
            }];
        }];
    } else {
        self.previewImageView.image = originalImageView.image;
    }
}

-(void)showPreviewImageUrl{
    /// 显示图片
    NSString *urlString = (NSString *)self.itemInfo.originalPreviewInfo;
    NSURL *url = [NSURL URLWithString:urlString];
    XLWeakSelf
    [self.indicatorView startAnimating];
    [self.previewImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        XLStrongSelf
        [strongSelf.indicatorView stopAnimating];
        if (error) { /// 图片加载失败
            UIImage *image = [XLComPods manager].comConfig.loadingFaileImage;
            strongSelf.previewImageView.image = image;
        }
    }];
}

#pragma mark - recoverPreviewView
- (void)recoverPreviewView {
    [self.xlScrollView setZoomScale:self.xlScrollView.minimumZoomScale animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.previewImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
//    CGFloat offsetX = (self.xlScrollView.tz_width > self.xlScrollView.contentSize.width) ? ((self.xlScrollView.tz_width - self.xlScrollView.contentSize.width) * 0.5) : 0.0;
//    CGFloat offsetY = (self.xlScrollView.tz_height > self.xlScrollView.contentSize.height) ? ((_scrollView.tz_height - self.xlScrollView.contentSize.height) * 0.5) : 0.0;
//    self.previewImageView.center = CGPointMake(self.xlScrollView.contentSize.width * 0.5 + offsetX, self.xlScrollView.contentSize.height * 0.5 + offsetY);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
