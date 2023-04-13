//
//  XLImageEditView.m
//  CHNMed
//
//  Created by GDXL2012 on 2020/8/27.
//  Copyright © 2020 GDXL2012. All rights reserved.
//

#import "XLImageEditView.h"
#import <MediaPlayer/MediaPlayer.h>

#import "XLImageMosaicTools.h"
#import "XLMacroColor.h"
#import "XLSystemMacro.h"
#import "Masonry.h"
#import "XLDeviceMacro.h"
#import "XLAdaptation.h"
#import "XLMacroLayout.h"
#import "UIView+Layout.h"
#import "UIView+XLCategory.h"
#import "XLMacroFont.h"

@interface XLImageEditView () <UIScrollViewDelegate, XLImageMosaicDelegate>

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIView            *imageContainerView;
@property (nonatomic, strong) UIImageView       *singLineImageView;

@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

@property (strong, nonatomic) UIView     *editNaviBarView;
@property (strong, nonatomic) UIButton   *revokeEditButton;
@property (strong, nonatomic) UIButton   *cancelEditButton;

@property (strong, nonatomic) UIView     *editToolBarView;
@property (strong, nonatomic) UIButton   *completeButton;

@property (nonatomic, weak) UIButton    *selectedColorButton;

@property (strong, nonatomic) NSArray <UIButton *> *editColorButtonArray;

@property (nonatomic, strong) XLImageMosaicTools *xlImgMosaicTools;
@property (nonatomic, strong) NSArray            *editColorArray;

@property (nonatomic, assign) XLImageEditViewStyle imageEditViewStyle;

- (void)recoverSubviews;

@end

NSInteger const kEditColorButtonPreTag = 1001;

@implementation XLImageEditView

+(void)showImageEditView:(UIImage *)image
                  inView:(UIView *)view
                delegate:(id<XLImageEditViewDelegate>)delegate{
    XLImageEditView *editView = [[XLImageEditView alloc] initWithFrame:view.bounds style:XLImageEditViewDefault];
    editView.cmPreviewImage = image;
    editView.cmDelegate = delegate;
    [view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
}

/// 显示图片编辑
+(void)showSingImageEditView:(UIImage *)image
                      inView:(UIView *)view
                    delegate:(id<XLImageEditViewDelegate>)delegate{
    XLImageEditView *editView = [[XLImageEditView alloc] initWithFrame:view.bounds style:XLImageEditViewSingle];
    editView.cmPreviewImage = image;
    editView.cmDelegate = delegate;
    [view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
}

-(instancetype)initWithFrame:(CGRect)frame style:(XLImageEditViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        _imageEditViewStyle = style;
        
        [self initPreviewView];
        if(style == XLImageEditViewDefault){
            self.editColorArray = @[XLHexColor(@"#D8D8D8"),
                                    XLHexColor(@"#000000"),
                                    XLHexColor(@"#FF0000"),
                                    XLHexColor(@"#00FF23"),
                                    XLHexColor(@"#FFE500"),
                                    [UIColor clearColor]];
            [self initEidtToolBarView];
        } else {
            self.editColorArray = @[XLHexColor(@"#32ca7a")];
            [self initSingleEidtToolBarView];
        }
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

-(void)initPreviewView{
    self.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    if (XLAvailableiOS11) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
}

-(void)initSingleEidtToolBarView{
    _editNaviBarView = [[UIView alloc] init];
    _editNaviBarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_editNaviBarView];
    [_editNaviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(XLNavTopHeight());
    }];
    
    CGFloat buttonHeight = XLNavBarHeight() - 10;
    UIImage *image = [UIImage imageNamed:@"comm_image_edit_back_icon"];
    _cancelEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelEditButton.backgroundColor = [UIColor whiteColor];
    _cancelEditButton.imageEdgeInsets = UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f);
    [_cancelEditButton setImage:image forState:UIControlStateNormal];
    [_cancelEditButton addTarget:self action:@selector(cancelEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelEditButton.layer.cornerRadius = buttonHeight / 2.0f;
    _cancelEditButton.layer.masksToBounds = YES;
    [self.editNaviBarView addSubview:_cancelEditButton];
    [_cancelEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(self.cancelEditButton.mas_height);
        make.left.mas_equalTo(self.editNaviBarView).offset(XLHMargin);;
        make.bottom.mas_equalTo(self.editNaviBarView);
    }];
    
    _revokeEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _revokeEditButton.backgroundColor = [UIColor whiteColor];
    _revokeEditButton.imageEdgeInsets = UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f);
    image = [UIImage imageNamed:@"comm_image_edit_revoke_icon"];
    [_revokeEditButton setImage:image forState:UIControlStateNormal];
    [_revokeEditButton addTarget:self action:@selector(revokeEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_revokeEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_revokeEditButton setCornerRadius:buttonHeight / 2.0f];
    [self.editNaviBarView addSubview:_revokeEditButton];
    [_revokeEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(self.revokeEditButton.mas_height);
        make.right.mas_equalTo(self.editNaviBarView).offset(-XLHMargin);
        make.bottom.mas_equalTo(self.editNaviBarView);
    }];
    
    _editToolBarView = [[UIView alloc] init];
    _editToolBarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_editToolBarView];
    [_editToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(XLNavTopHeight());
    }];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton setTitle:XLNSLocalized(@"完成") forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _completeButton.titleLabel.font = XLFont(16.0f);
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _completeButton.backgroundColor = XLHexColor(@"#32ca7a");
    [_completeButton setCornerRadius:XLButtonRadius];
    [_editToolBarView addSubview:_completeButton];
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.0f, 35.0f));
        make.right.mas_equalTo(self.editToolBarView).offset(-XLHMargin);
        make.top.mas_equalTo(self.editToolBarView).offset((XLNavBarHeight() - 35.0f) / 2.0f);
    }];
    
    _singLineImageView = [[UIImageView alloc] init];
    _singLineImageView.image = [UIImage imageNamed:@"comm_iamge_edit_line_icon"];
    [_editToolBarView addSubview:_singLineImageView];
    [_singLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.0f, 35.0f));
        make.left.mas_equalTo(self.editToolBarView.mas_left).offset(XLHMargin);
        make.centerY.mas_equalTo(self.completeButton);
    }];
}

-(void)initEidtToolBarView{
    _editNaviBarView = [[UIView alloc] init];
    _editNaviBarView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:_editNaviBarView];
    [_editNaviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(XLNavTopHeight());
    }];
    
    _cancelEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelEditButton setTitle:XLNSLocalized(@"取消") forState:UIControlStateNormal];
    [_cancelEditButton addTarget:self action:@selector(cancelEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editNaviBarView addSubview:_cancelEditButton];
    [_cancelEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(XLNavBarHeight());
        make.left.mas_equalTo(self.editNaviBarView).offset(XLHMargin);;
        make.bottom.mas_equalTo(self.editNaviBarView);
    }];
    
    _revokeEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_revokeEditButton setTitle:XLNSLocalized(@"撤销") forState:UIControlStateNormal];
    [_revokeEditButton addTarget:self action:@selector(revokeEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_revokeEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editNaviBarView addSubview:_revokeEditButton];
    [_revokeEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(XLNavBarHeight());
        make.right.mas_equalTo(self.editNaviBarView).offset(-XLHMargin);
        make.bottom.mas_equalTo(self.editNaviBarView);
    }];
    
    _editToolBarView = [[UIView alloc] init];
    _editToolBarView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self addSubview:_editToolBarView];
    [_editToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(XLNavTopHeight());
    }];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton setTitle:XLNSLocalized(@"完成") forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_editToolBarView addSubview:_completeButton];
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.0f, 35.0f));
        make.right.mas_equalTo(self.editToolBarView).offset(-XLHMargin);
        make.top.mas_equalTo(self.editToolBarView).offset((XLNavBarHeight() - 35.0f) / 2.0f);
    }];
    
    NSInteger count = self.editColorArray.count;
    CGFloat datX = XLHMargin;
    CGFloat editButtonWidth = XLMiniScreen() ? 28.0f : 36.0f;
    CGFloat datY = (XLNavBarHeight() - editButtonWidth) / 2.0f;
    
    CGFloat layerWidht = XLMiniScreen() ? 20.0f : 25.0f;
    CGFloat layerDatX = (editButtonWidth - layerWidht) / 2.0f;
    for (NSInteger index = 0; index < count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editToolBarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(editButtonWidth, editButtonWidth));
            make.left.mas_equalTo(self.editToolBarView.mas_left).offset(datX);
            make.top.mas_equalTo(self.editToolBarView).offset(datY);
        }];
        button.tag = kEditColorButtonPreTag + index;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(editColorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIColor *color = [self.editColorArray objectAtIndex:index];
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(layerDatX, layerDatX, layerWidht, layerWidht);
        layer.backgroundColor = color.CGColor;
        layer.cornerRadius = layerWidht / 2.0f;
        layer.masksToBounds = YES;
        layer.borderWidth = 2.0f;
        layer.borderColor = [UIColor whiteColor].CGColor;
        [button.layer addSublayer:layer];
        datX = datX + editButtonWidth;
    }
}

#pragma mark - Button Click
-(void)cancelEditButtonClick{
    if (self.cmDelegate &&
        [self.cmDelegate respondsToSelector:@selector(imageEditViewCancel)]) {
        [self.cmDelegate imageEditViewCancel];
    }
    [self removeFromSuperview];
}

-(void)revokeEditButtonClick{
    if (self.xlImgMosaicTools) {
        [self.xlImgMosaicTools xlPreviousStep];
    }
}

-(void)completeButtonClick{
    UIImage *image = self.cmPreviewImage;
    if (self.xlImgMosaicTools.xlmosaicImage) {
        image = self.xlImgMosaicTools.xlmosaicImage;
    }
    if (self.cmDelegate &&
        [self.cmDelegate respondsToSelector:@selector(imageEditViewComplete:)]) {
        [self.cmDelegate imageEditViewComplete:image];
    }
    [self removeFromSuperview];
}

-(void)editColorButtonClick:(UIButton *)button{
    NSLog(@"editColorButtonClick start");
    NSInteger tagIndex = button.tag - kEditColorButtonPreTag;
    UIColor *color = [self.editColorArray objectAtIndex:tagIndex];
    if (color) {
        CGFloat width = 3.0f * [UIScreen mainScreen].scale;
        [self.xlImgMosaicTools setMosaicStrokeColor:color width:width];
    }
    
    if (self.selectedColorButton) {
        CALayer *layer = self.selectedColorButton.layer.sublayers.firstObject;
        layer.transform = CATransform3DIdentity;
    }
    self.selectedColorButton = button;
    
    CALayer *layer = self.selectedColorButton.layer.sublayers.firstObject;
    layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    NSLog(@"editColorButtonClick end");
}

-(void)cmInitEditColor{
    if (!_xlImgMosaicTools) {
        _xlImgMosaicTools = [[XLImageMosaicTools alloc] initMosaictoolsWithImgView:self.imageView];
        _xlImgMosaicTools.xlMosaicDelegate = self;
        [_xlImgMosaicTools xlBeganMosaic];
        
        if(self.imageEditViewStyle == XLImageEditViewSingle){
            CGFloat width = 3.0f * [UIScreen mainScreen].scale;
            UIColor *color = [self.editColorArray objectAtIndex:0];
            [self.xlImgMosaicTools setMosaicStrokeColor:color width:width];
        } else {
            UIColor *color = [self.editColorArray objectAtIndex:0];
            if (color) {
                CGFloat width = 3.0f * [UIScreen mainScreen].scale;
                [self.xlImgMosaicTools setMosaicStrokeColor:color width:width];
            }
            
            if (self.selectedColorButton == nil) {
                self.selectedColorButton = [self.editToolBarView viewWithTag:kEditColorButtonPreTag];
            }
            CALayer *layer = self.selectedColorButton.layer.sublayers.firstObject;
            layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        }
    }
}

- (void)setCmPreviewImage:(UIImage *)cmPreviewImage {
    _cmPreviewImage = cmPreviewImage;
    [_scrollView setZoomScale:1.0 animated:NO];
    self.imageView.image = cmPreviewImage;
    [self resizeSubviews];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.tz_origin = CGPointZero;
    _imageContainerView.tz_width = self.scrollView.tz_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.tz_height / self.scrollView.tz_width) {
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.scrollView.tz_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (_imageContainerView.tz_height > self.tz_height && _imageContainerView.tz_height - self.tz_height <= 1) {
        _imageContainerView.tz_height = self.tz_height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.tz_height, self.tz_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.tz_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= self.tz_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

- (void)configMaximumZoomScale {
    _scrollView.maximumZoomScale = 3.0f;
    
    CGFloat aspectRatio = self.cmPreviewImage.size.width / self.cmPreviewImage.size.height;
    // 优化超宽图片的显示
    if (aspectRatio > 1.5) {
        self.scrollView.maximumZoomScale *= aspectRatio / 1.5;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.tz_width, self.tz_height);
    
    [self recoverSubviews];
    
    [self cmInitEditColor];
}

#pragma mark - XLImageMosaicDelegate <NSObject>

/// 涂鸦开始
/// @param mosaicTools <#mosaicTools description#>
-(void)xlImageMosaicBegain:(XLImageMosaicTools *)mosaicTools{
    [UIView animateWithDuration:0.35f animations:^{
        self.editNaviBarView.alpha = 0.0f;
        self.editToolBarView.alpha = 0.0f;
    } completion:^(BOOL finished) {
    }];
}

/// 涂鸦结束
/// @param mosaicTools <#mosaicTools description#>
-(void)xlImageMosaicEnd:(XLImageMosaicTools *)mosaicTools{
    [UIView animateWithDuration:0.35f animations:^{
        self.editNaviBarView.alpha = 1;
        self.editToolBarView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
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
    CGFloat offsetX = (_scrollView.tz_width > _scrollView.contentSize.width) ? ((_scrollView.tz_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.tz_height > _scrollView.contentSize.height) ? ((_scrollView.tz_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
