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
#import "UIImage+XLCategory.h"

typedef NS_ENUM(NSInteger, XLImageEditOpType) {
    XLImageEditOpTypeNone,      // 无选中
    XLImageEditOpTypeLine,      // 画笔
    XLImageEditOpTypeCut,       // 裁剪
    XLImageEditOpTypeRotate,    // 旋转
};

typedef NS_ENUM(NSInteger, XLCutWindowMoveType) {
    XLCutWindowMoveTypeNone,        //  不能移动
    XLCutWindowMoveTypeTopLeft,
    XLCutWindowMoveTypeTopRight,
    XLCutWindowMoveTypeLeftBottom,
    XLCutWindowMoveTypeRightBottom,
};

@interface XLImageEditView () <UIScrollViewDelegate, XLImageMosaicDelegate>

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIView            *imageContainerView;

@property (nonatomic, strong) UIButton       *xlSingLineButton;
@property (nonatomic, strong) UIButton       *xlCutButton;
@property (nonatomic, strong) UIButton       *xlRotateButton;

@property (nonatomic, strong) UIButton       *xlCancelCutButton;
@property (nonatomic, strong) UIButton       *xlCutCompleteButton;
@property (nonatomic, strong) UIView         *xlCutCoverView;
@property (nonatomic, strong) CAShapeLayer   *xlCutMaskLayer;
@property (nonatomic, strong) UIImageView    *xlCutWindowView;

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
@property (nonatomic, assign) XLImageEditOpType editeOpType;
@property (nonatomic, assign) XLCutWindowMoveType cutWindowMoveType;
@property (nonatomic, assign) CGPoint xlStartMovePoint;  // 原始位置
@property (nonatomic, assign) CGFloat xlRotate; // 旋转角度
@property (nonatomic, strong) UIImage *originalImage;  // 原始图片
- (void)recoverSubviews;

@end

CGFloat const kCutWhiteWidth = 1.0f;
CGFloat const kCutAreaHalfWidth = 50.0f;
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
        _editeOpType = XLImageEditOpTypeLine;
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
    _scrollView.backgroundColor = [UIColor blackColor];
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
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
}

-(void)initSingleEidtToolBarView{
    CGFloat offsetHeight = 30.0f;
    CGFloat startAlpha = 0.9f;
    CGRect frame = CGRectMake(0, 0, XLScreenWidth(), XLNavTopHeight() + offsetHeight);
    _editNaviBarView = [[UIView alloc] initWithFrame:frame];
    _editNaviBarView.userInteractionEnabled = NO;
//    _editNaviBarView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _editNaviBarView.backgroundColor = [UIColor clearColor];
    [_editNaviBarView setGradientLayer:[UIColor colorWithWhite:0 alpha:startAlpha] endColor:[UIColor colorWithWhite:0 alpha:0.0f]];
    [self addSubview:_editNaviBarView];
    
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
    [self addSubview:_cancelEditButton];
    [_cancelEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(self.cancelEditButton.mas_height);
        make.left.mas_equalTo(self.editNaviBarView).offset(XLHMargin);;
        make.bottom.mas_equalTo(self.editNaviBarView).offset(-offsetHeight);
    }];
    
    _revokeEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _revokeEditButton.imageEdgeInsets = UIEdgeInsetsMake(7.0f, 7.0f, 7.0f, 7.0f);
//    image = [UIImage imageNamed:@"comm_image_edit_revoke_icon"];
//    [_revokeEditButton setImage:image forState:UIControlStateNormal];
    [_revokeEditButton setTitle:XLNSLocalized(@"撤销") forState:UIControlStateNormal];
    _revokeEditButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [_revokeEditButton addTarget:self action:@selector(revokeEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_revokeEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_revokeEditButton setCornerRadius:buttonHeight / 2.0f];
    [self addSubview:_revokeEditButton];
    [_revokeEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(buttonHeight);
//        make.width.mas_equalTo(self.revokeEditButton.mas_height);
        make.width.mas_equalTo(60.0f);
        make.right.mas_equalTo(self.editNaviBarView).offset(-XLHMargin);
        make.bottom.mas_equalTo(self.editNaviBarView).offset(-offsetHeight);
    }];
    
    CGFloat barHeight = XLNavBarHeight() + XLNavBottomHeight() + offsetHeight;
    frame = CGRectMake(0, XLScreenHeight() - barHeight, XLScreenWidth(), barHeight);
    _editToolBarView = [[UIView alloc] initWithFrame:frame];
    _editToolBarView.userInteractionEnabled = NO;
    _editToolBarView.backgroundColor = [UIColor clearColor];
//    _editToolBarView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    [_editToolBarView setGradientLayer:[UIColor colorWithWhite:0 alpha:0.0f] endColor:[UIColor colorWithWhite:0 alpha:startAlpha]];
    [self addSubview:_editToolBarView];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton setTitle:XLNSLocalized(@"完成") forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _completeButton.titleLabel.font = XLFont(16.0f);
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _completeButton.backgroundColor = XLHexColor(@"#32ca7a");
    [_completeButton setCornerRadius:XLButtonRadius];
    [self addSubview:_completeButton];
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60.0f, 35.0f));
        make.right.mas_equalTo(self.editToolBarView).offset(-XLHMargin);
        make.top.mas_equalTo(self.editToolBarView).offset((XLNavBarHeight() - 35.0f) / 2.0f + offsetHeight);
    }];
    
    CGFloat opButtonHeight = 40.0f;
    UIEdgeInsets insets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    
    SEL sel = @selector(xlLineButtonClick);
    _xlSingLineButton = [self xlBtnForEditToolBar:@"comm_iamge_edit_line_unsel_icon"
                                      highlighted:@"comm_iamge_edit_line_icon"
                                           action:sel
                                        imgInsets:insets
                                       leftButton:nil
                                           height:opButtonHeight];
    
    sel = @selector(xlCutButtonClick);
    _xlCutButton = [self xlBtnForEditToolBar:@"comm_iamge_edit_cut_unsel_icon"
                                 highlighted:@"comm_iamge_edit_cut_icon"
                                      action:sel
                                   imgInsets:insets
                                  leftButton:self.xlSingLineButton
                                      height:opButtonHeight];
    
    sel = @selector(xlRotateButtonClick);
    _xlRotateButton = [self xlBtnForEditToolBar:@"comm_iamge_edit_rotate_unsel_icon"
                                    highlighted:@"comm_iamge_edit_rotate_icon"
                                         action:sel
                                      imgInsets:insets
                                     leftButton:self.xlCutButton
                                         height:opButtonHeight];
    
    sel = @selector(xlCancelCutButtonClick);
    _xlCancelCutButton = [self xlBtnWithNormal:@"comm_iamge_edit_cut_cancel_icon"
                                   highlighted:nil
                                        action:sel
                                     imgInsets:insets
                                        height:opButtonHeight];
    _xlCancelCutButton.hidden = YES;
    [_xlCancelCutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(opButtonHeight, opButtonHeight));
        make.left.mas_equalTo(self).offset(XLHMargin);
        make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-XLHMargin);
    }];
    
    sel = @selector(xlCutCompleteButtonClick);
    _xlCutCompleteButton = [self xlBtnWithNormal:@"comm_iamge_edit_cut_sure_icon"
                                     highlighted:nil
                                          action:sel
                                       imgInsets:insets
                                          height:opButtonHeight];
    _xlCutCompleteButton.hidden = YES;
    [_xlCutCompleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(opButtonHeight, opButtonHeight));
        make.right.mas_equalTo(self.mas_right).offset(-XLHMargin);
        make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-XLHMargin);
    }];
    
    [self xlCutBarViewHidden:YES animate:NO];
    [self updateOpButton:self.editeOpType forHighlighted:YES];
}

-(UIButton *)xlBtnForEditToolBar:(NSString *)normal
                     highlighted:(NSString *)highlighted
                          action:(SEL)sel
                       imgInsets:(UIEdgeInsets)insets
                      leftButton:(nullable UIButton *)leftButton
                          height:(CGFloat)opButtonHeight{
    UIButton *button = [self xlBtnWithNormal:normal highlighted:highlighted action:sel imgInsets:insets height:opButtonHeight];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(opButtonHeight, opButtonHeight));
        if(leftButton){
            make.left.mas_equalTo(leftButton.mas_right).offset(XLHMargin);
        } else {
            make.left.mas_equalTo(self.editToolBarView.mas_left).offset(XLHMargin);
        }
        make.centerY.mas_equalTo(self.completeButton);
    }];
    return button;
}

-(UIButton *)xlBtnWithNormal:(nullable NSString *)normal
                 highlighted:(nullable NSString *)highlighted
                      action:(SEL)sel
                   imgInsets:(UIEdgeInsets)insets
                      height:(CGFloat)opButtonHeight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(normal != nil){
        UIImage *image = [UIImage imageNamed:normal];
        [button setImage:image forState:UIControlStateNormal];
    }
    if(highlighted != nil){
        UIImage *image = [UIImage imageNamed:highlighted];
        [button setImage:image forState:UIControlStateHighlighted];
    }
    [self addSubview:button];
    [button setImageEdgeInsets:insets];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
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

- (void)setEditeOpType:(XLImageEditViewStyle)editeOpType{
    if(_editeOpType == editeOpType ||
       editeOpType == XLImageEditOpTypeNone){
        return;
    }
    [self updateOpButton:_editeOpType forHighlighted:NO];
    _editeOpType = editeOpType;
    [self updateOpButton:editeOpType forHighlighted:YES];
}

-(void)updateOpButton:(XLImageEditViewStyle)editeOpType
       forHighlighted:(BOOL)highlighted{
    if(editeOpType == XLImageEditOpTypeNone){
        return;
    }
    if(editeOpType == XLImageEditOpTypeLine){
        [self.xlSingLineButton setHighlighted:highlighted];
    } else if (editeOpType == XLImageEditOpTypeCut){
        [self.xlCutButton setHighlighted:highlighted];
    } else {
        [self.xlRotateButton setHighlighted:highlighted];
    }
}

#pragma mark - Button Click
-(void)xlLineButtonClick{
    self.editeOpType = XLImageEditOpTypeLine;
}

-(void)xlCutButtonClick{
    if (self.xlImgMosaicTools.xlmosaicImage) {
        self.cmPreviewImage = self.xlImgMosaicTools.xlmosaicImage;
        [self.xlImgMosaicTools updateImageView:self.imageView];
    }
    self.editeOpType = XLImageEditOpTypeCut;
    self.originalImage = self.cmPreviewImage;
    [self xlTopBarViewHidden:YES animate:YES];
    [self xlEditBarViewHidden:YES animate:NO];
    [self xlCutBarViewHidden:NO animate:YES];
    self.scrollView.userInteractionEnabled = NO;
    [self updateScrollViewFrameWithAnimate:YES completion:^(BOOL finished) {
        [self xlSetCutCoverViewShow:YES];
    }];
}

-(void)xlRotateButtonClick{
    if (self.xlImgMosaicTools.xlmosaicImage) {
        self.cmPreviewImage = self.xlImgMosaicTools.xlmosaicImage;
        [self.xlImgMosaicTools updateImageView:self.imageView];
    }
//    self.xlRotate = self.xlRotate + 90.0f;
    self.cmPreviewImage = [self.cmPreviewImage xlRotateImageRight];
}

-(void)xlCancelCutButtonClick{
    self.editeOpType = XLImageEditOpTypeLine;
    [self xlTopBarViewHidden:NO animate:YES];
    [self xlCutBarViewHidden:YES animate:NO];
    [self xlEditBarViewHidden:NO animate:YES];
    self.cmPreviewImage = self.originalImage;
    self.scrollView.userInteractionEnabled = YES;
    [self updateScrollViewFrameWithAnimate:YES completion:nil];
    [self xlSetCutCoverViewShow:NO];
    
}

-(void)xlCutCompleteButtonClick{
    [self xlCutPreviewImage];
    self.editeOpType = XLImageEditOpTypeLine;
    [self updateScrollViewFrameWithAnimate:YES completion:nil];
    [self xlTopBarViewHidden:NO animate:YES];
    [self xlCutBarViewHidden:YES animate:NO];
    [self xlEditBarViewHidden:NO animate:YES];
    self.scrollView.userInteractionEnabled = YES;
    [self xlSetCutCoverViewShow:NO];
}

-(void)xlCutPreviewImage{
    CGRect frame = self.xlCutWindowView.frame;
    CGRect covertFrame = self.xlCutCoverView.frame;
    if(frame.origin.x <= CGFLOAT_MIN &&
       frame.origin.y <= CGFLOAT_MIN &&
       (covertFrame.size.width - frame.size.width)<= CGFLOAT_MIN &&
       (covertFrame.size.height - frame.size.height)<= CGFLOAT_MIN){
        // 全屏不执行剪切
        return;
    }
    CGFloat imgWidth = self.cmPreviewImage.size.width;
    CGFloat scale = imgWidth / self.imageView.frame.size.width;
    CGRect rect = CGRectMake(frame.origin.x * scale,
                             frame.origin.y * scale,
                             (frame.size.width - kCutWhiteWidth * 2) * scale,
                             (frame.size.height - kCutWhiteWidth * 2) * scale);
    UIImage *image = [UIImage image:self.cmPreviewImage toRect:rect];
    self.cmPreviewImage = image;
    self.originalImage = nil;
}

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
        _xlImgMosaicTools = [[XLImageMosaicTools alloc] initMosaictoolsWithImgView:self.imageView forMosaic:YES];
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
    CGFloat width = self.scrollView.tz_width;
    CGFloat height = self.scrollView.tz_height;
    
    _imageContainerView.tz_origin = CGPointZero;
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > height / width) {
        // 高度修正
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_width = floor(height / (image.size.height / image.size.width));
//        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / width));
    } else {
        _imageContainerView.tz_width = width;
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / width));
//        CGFloat height = image.size.height / image.size.width * width;
//        if (height < 1 || isnan(height)) height = height;
//        height = floor(height);
//        _imageContainerView.tz_height = height;
    }
    _imageContainerView.tz_centerX = width / 2;
    _imageContainerView.tz_centerY = height / 2;
    
    // 是阅览能够上下滑动
//    if (_imageContainerView.tz_height > height && _imageContainerView.tz_height - height <= 1) {
//        _imageContainerView.tz_height = height;
//    }
    
    CGFloat contentSizeH = MAX(_imageContainerView.tz_height, height);
    _scrollView.contentSize = CGSizeMake(width, contentSizeH);
    [_scrollView scrollRectToVisible:self.scrollView.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= height ? NO : YES;
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
    [self updateScrollViewFrame];
    [self cmInitEditColor];
}

-(void)updateScrollViewFrameWithAnimate:(BOOL)animate completion:(void (^ __nullable)(BOOL finished))completion{
    if(animate){
        [UIView animateWithDuration:0.35f animations:^{
            [self updateScrollViewFrame];
        } completion:completion];
    } else {
        [self updateScrollViewFrame];
    }
}

-(void)updateScrollViewFrame{
    if(self.editeOpType == XLImageEditOpTypeCut){
        CGFloat top = XLStatusBarHeight() + 10.0f;
        CGFloat bottom = XLNavBottomHeight() + 15.0f + 40.0f + 30.0f;
        _scrollView.frame = CGRectMake(20.0f, top, self.tz_width - 20.0f * 2.0f, self.tz_height - top - bottom);
    } else {
        _scrollView.frame = CGRectMake(0, 0, self.tz_width, self.tz_height);
    }
    [self recoverSubviews];
}

-(void)xlSetCutCoverViewShow:(BOOL)show{
    if(show){
        if(_xlCutCoverView == nil){
            _xlCutCoverView = [[UIView alloc] init];
            _xlCutCoverView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
            _xlCutCoverView.userInteractionEnabled = YES;
            
            /// 单指拖动手势
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveWindowViewForRecognizer:)];
            pan.delegate = self;
            pan.minimumNumberOfTouches = 1;
            pan.maximumNumberOfTouches = 1;
            [_xlCutCoverView addGestureRecognizer:pan];
        }
        if(_xlCutWindowView == nil){
            _xlCutWindowView = [[UIImageView alloc] init];
            UIImage *image = [UIImage imageNamed:@"comm_cut_window_icon"];
            // 设置左边端盖宽度
            NSInteger leftCapWidth = image.size.width * 0.5;
            // 设置上边端盖高度
            NSInteger topCapHeight = image.size.height * 0.5;
            UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
            _xlCutWindowView.image = newImage;
//            _xlCutWindowView.contentMode = UIViewContentModeScaleAspectFill;
            _xlCutWindowView.userInteractionEnabled = NO;
            [_xlCutCoverView addSubview:_xlCutWindowView];
        }
        if(_xlCutMaskLayer == nil){
            _xlCutMaskLayer = [[CAShapeLayer alloc] init];
            _xlCutCoverView.layer.mask = _xlCutMaskLayer;
        }
        
        CGRect convertRect = [self.scrollView convertRect:self.imageContainerView.frame toView:self];
        CGFloat width = convertRect.size.width + kCutWhiteWidth * 2;
        CGFloat height = convertRect.size.height + kCutWhiteWidth * 2;
        
        CGRect frame = CGRectMake(convertRect.origin.x - kCutWhiteWidth,
                                  convertRect.origin.y - kCutWhiteWidth,
                                  width, height);
        _xlCutCoverView.frame = frame;
        _xlCutWindowView.frame = _xlCutCoverView.bounds;
        
        [self updateCutMaskLayerPath];
        _xlCutCoverView.userInteractionEnabled = YES;
        [self addSubview:_xlCutCoverView];
    } else {
        if(_xlCutCoverView != nil &&
           _xlCutCoverView.superview != nil){
            [_xlCutCoverView removeFromSuperview];
        }
    }
}

-(void)updateCutMaskLayerPath{
    CGFloat width = _xlCutCoverView.bounds.size.width;
    CGFloat height = _xlCutCoverView.bounds.size.height;
    CGFloat windowX = _xlCutWindowView.frame.origin.x;
    CGFloat windowY = _xlCutWindowView.frame.origin.y;
    CGFloat windowMaxX = CGRectGetMaxX(_xlCutWindowView.frame);
    CGFloat windowMaxY = CGRectGetMaxY(_xlCutWindowView.frame);
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    // 左侧矩形
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(0.0f, height)];
    [path addLineToPoint:CGPointMake(windowX + kCutWhiteWidth, height)];
    [path addLineToPoint:CGPointMake(windowX + kCutWhiteWidth, 0.0f)];
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    
    // 上部矩形
    [path moveToPoint:CGPointMake(windowX + kCutWhiteWidth, 0.0f)];
    [path addLineToPoint:CGPointMake(windowX + kCutWhiteWidth, windowY + kCutWhiteWidth)];
    [path addLineToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, windowY + kCutWhiteWidth)];
    [path addLineToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, 0.0f)];
    [path addLineToPoint:CGPointMake(windowX + kCutWhiteWidth, 0.0f)];
    
    // 下部矩形
    [path moveToPoint:CGPointMake(windowX + kCutWhiteWidth, windowMaxY - kCutWhiteWidth)];
    [path addLineToPoint:CGPointMake(windowX + kCutWhiteWidth, height)];
    [path addLineToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, height)];
    [path addLineToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, windowMaxY - kCutWhiteWidth)];
    [path addLineToPoint:CGPointMake(windowX + kCutWhiteWidth, windowMaxY - kCutWhiteWidth)];
    
    // 左侧矩形
    [path moveToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, 0.0f)];
    [path addLineToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, height)];
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(width, 0.0f)];
    [path addLineToPoint:CGPointMake(windowMaxX - kCutWhiteWidth, 0.0f)];
    
    _xlCutMaskLayer.path = path.CGPath;
    _xlCutMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    _xlCutMaskLayer.strokeColor = [UIColor whiteColor].CGColor;
    _xlCutMaskLayer.lineWidth = 1.0f;
    _xlCutMaskLayer.backgroundColor = [UIColor clearColor].CGColor;
}

/// 根据手势移动
/// @param panGesture panGesture description
-(void)moveWindowViewForRecognizer:(UIPanGestureRecognizer *)panGesture{
    UIView *view = panGesture.view;
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint transPoint = [panGesture translationInView:view];  //移动点
        [self xlCutWindowMoveForPoint:transPoint];
        [panGesture setTranslation:CGPointZero inView:view];
    } else if(panGesture.state == UIGestureRecognizerStateBegan){
        self.xlStartMovePoint = [panGesture locationInView:view];
    }
}

#pragma mark - UIGestureRecognizerDelegate <NSObject>
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.view == _xlCutCoverView &&
       [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        //移动点
        CGPoint translationPoint = [panGesture locationInView:self.xlCutCoverView];
        self.cutWindowMoveType = [self xlCutWindowMoveTypeForPoint:translationPoint];
        return self.cutWindowMoveType != XLCutWindowMoveTypeNone;
    }
    return YES;
}

-(void)xlCutWindowMoveForPoint:(CGPoint)point{
    CGFloat windowX = self.xlCutWindowView.frame.origin.x;
    CGFloat windowY = self.xlCutWindowView.frame.origin.y;
    CGFloat windowMaxX = CGRectGetMaxX(self.xlCutWindowView.frame);
    CGFloat windowMaxY = CGRectGetMaxY(self.xlCutWindowView.frame);
    
    CGFloat datX = point.x;
    CGFloat datY = point.y;
    // 记录上一个位移
    self.xlStartMovePoint = point;
    CGFloat width = self.xlCutWindowView.frame.size.width;
    CGFloat height = self.xlCutWindowView.frame.size.height;
    
    if(self.cutWindowMoveType == XLCutWindowMoveTypeTopLeft ||
       self.cutWindowMoveType == XLCutWindowMoveTypeLeftBottom){
        windowX = windowX + datX;
        if(windowX < 0){
            windowX = 0;
        } else if (windowX > windowMaxX - kCutAreaHalfWidth * 2){
            windowX = windowMaxX - kCutAreaHalfWidth * 2;
        }
        width = windowMaxX - windowX; // 修正X轴方向width
    }
    if(self.cutWindowMoveType == XLCutWindowMoveTypeTopRight ||
       self.cutWindowMoveType == XLCutWindowMoveTypeTopLeft){
        windowY = windowY + datY;
        if(windowY < 0){
            windowY = 0;
        } else if (windowY > windowMaxY - kCutAreaHalfWidth * 2){
            windowY = windowMaxY - kCutAreaHalfWidth * 2;
        }
        height = windowMaxY - windowY; // 修正y轴方向width
    }
    if(self.cutWindowMoveType == XLCutWindowMoveTypeTopRight ||
       self.cutWindowMoveType == XLCutWindowMoveTypeRightBottom){
        width = width + datX;
        if(width < kCutAreaHalfWidth * 2){
            width = kCutAreaHalfWidth * 2;
        } else if (width > self.xlCutCoverView.frame.size.width - windowX){
            width = self.xlCutCoverView.frame.size.width - windowX;
        }
    }
    if(self.cutWindowMoveType == XLCutWindowMoveTypeLeftBottom ||
       self.cutWindowMoveType == XLCutWindowMoveTypeRightBottom){
        height = height + datY;
        if(height < kCutAreaHalfWidth * 2){
            height = kCutAreaHalfWidth * 2;
        } else if (height > self.xlCutCoverView.frame.size.height - windowY){
            height = self.xlCutCoverView.frame.size.height - windowY;
        }
    }
    self.xlCutWindowView.frame = CGRectMake(windowX, windowY, width, height);
    
    [self updateCutMaskLayerPath];
}

-(XLCutWindowMoveType)xlCutWindowMoveTypeForPoint:(CGPoint)point{
    CGFloat windowX = _xlCutWindowView.frame.origin.x;
    CGFloat windowY = _xlCutWindowView.frame.origin.y;
    CGFloat windowMaxX = CGRectGetMaxX(_xlCutWindowView.frame);
    CGFloat windowMaxY = CGRectGetMaxY(_xlCutWindowView.frame);
    CGFloat itemOffset = 5.0f;
    CGFloat itemHeight = kCutAreaHalfWidth + itemOffset;
    CGRect frame = CGRectMake(windowX - itemOffset, windowY - itemOffset, itemHeight, itemHeight);
    if(CGRectContainsPoint(frame, point)){
        return XLCutWindowMoveTypeTopLeft;
    }
    frame = CGRectMake(windowX - itemOffset, windowMaxY - itemHeight, itemHeight, itemHeight);
    if(CGRectContainsPoint(frame, point)){
        return XLCutWindowMoveTypeLeftBottom;
    }
    frame = CGRectMake(windowMaxX - itemHeight, windowMaxY - itemHeight, itemHeight, itemHeight);
    if(CGRectContainsPoint(frame, point)){
        return XLCutWindowMoveTypeRightBottom;
    }
    frame = CGRectMake(windowMaxX - itemHeight, windowY - itemOffset, itemHeight, itemHeight);
    if(CGRectContainsPoint(frame, point)){
        return XLCutWindowMoveTypeTopRight;
    }
    return XLCutWindowMoveTypeNone;
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
    if(self.editeOpType != XLImageEditOpTypeLine){
        return;
    }
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.scrollView.frame.size.width / newZoomScale;
        CGFloat ysize = self.scrollView.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if(self.editeOpType != XLImageEditOpTypeLine){
        return;
    }
    if(self.editeOpType == XLImageEditOpTypeLine){
        if(self.editNaviBarView.alpha <= CGFLOAT_MIN){
            [UIView animateWithDuration:0.35f animations:^{
                self.editNaviBarView.alpha = 1.0f;
                self.editToolBarView.alpha = 1.0f;
                self.cancelEditButton.alpha = 1.0f;
                self.revokeEditButton.alpha = 1.0f;
                self.xlSingLineButton.alpha = 1.0f;
                self.xlCutButton.alpha = 1.0f;
                self.xlRotateButton.alpha = 1.0f;
                self.completeButton.alpha = 1.0f;
            } completion:^(BOOL finished) {
            }];
        } else {
            [UIView animateWithDuration:0.35f animations:^{
                self.editNaviBarView.alpha = 0.0f;
                self.editToolBarView.alpha = 0.0f;
                self.cancelEditButton.alpha = 0.0f;
                self.revokeEditButton.alpha = 0.0f;
                self.xlSingLineButton.alpha = 0.0f;
                self.xlCutButton.alpha = 0.0f;
                self.xlRotateButton.alpha = 0.0f;
                self.completeButton.alpha = 0.0f;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

#pragma mark - View Hidden
-(void)xlTopBarViewHidden:(BOOL)hidden animate:(BOOL)animate{
    // TODO：需要有个动画，所以有这个透明度，需要考虑优化
    CGFloat alpha = hidden ? 0.0f : 1.0f;
    if(animate){
        if(!hidden){ // 显示：需要先取消隐藏，在处理透明度
            [self xlTopBarViewHidden:NO];
        }
        [UIView animateWithDuration:0.35f animations:^{
            [self xlTopBarViewAlpha:alpha];
        } completion:^(BOOL finished) {
            [self xlTopBarViewHidden:hidden];
        }];
    } else {
        [self xlTopBarViewAlpha:alpha];
        [self xlTopBarViewHidden:hidden];
    }
}

-(void)xlTopBarViewAlpha:(BOOL)alpha{
    self.editNaviBarView.alpha = alpha;
    self.cancelEditButton.alpha = alpha;
    self.revokeEditButton.alpha = alpha;
}

-(void)xlTopBarViewHidden:(BOOL)hidden{
    self.editNaviBarView.hidden = hidden;
    self.cancelEditButton.hidden = hidden;
    self.revokeEditButton.hidden = hidden;
}

-(void)xlEditBarViewHidden:(BOOL)hidden animate:(BOOL)animate{
    // TODO：需要有个动画，所以有这个透明度，需要考虑优化
    CGFloat alpha = hidden ? 0.0f : 1.0f;
    if(animate){
        if(!hidden){ // 显示：需要先取消隐藏，在处理透明度
            [self xlEditBarViewHidden:NO];
        }
        [UIView animateWithDuration:0.35f animations:^{
            [self xlEditBarViewAlpha:alpha];
        } completion:^(BOOL finished) {
            [self xlEditBarViewHidden:hidden];
        }];
    } else {
        [self xlEditBarViewAlpha:alpha];
        [self xlEditBarViewHidden:hidden];
    }
}

-(void)xlEditBarViewAlpha:(BOOL)alpha{
    self.editToolBarView.alpha = alpha;
    self.xlSingLineButton.alpha = alpha;
    self.xlCutButton.alpha = alpha;
    self.xlRotateButton.alpha = alpha;
    self.completeButton.alpha = alpha;
}

-(void)xlEditBarViewHidden:(BOOL)hidden{
    self.editToolBarView.hidden = hidden;
    self.xlSingLineButton.hidden = hidden;
    self.xlCutButton.hidden = hidden;
    self.xlRotateButton.hidden = hidden;
    self.completeButton.hidden = hidden;
}

-(void)xlCutBarViewHidden:(BOOL)hidden animate:(BOOL)animate{
    // TODO：需要有个动画，所以有这个透明度，需要考虑优化
    CGFloat alpha = hidden ? 0.0f : 1.0f;
    if(animate){
        if(!hidden){ // 显示：需要先取消隐藏，在处理透明度
            [self xlCutBarViewAlpha:NO];
        }
        [UIView animateWithDuration:0.35f animations:^{
            [self xlCutBarViewAlpha:alpha];
        } completion:^(BOOL finished) {
            [self xlCutBarViewHidden:hidden];
        }];
    } else {
        [self xlCutBarViewAlpha:alpha];
        [self xlCutBarViewHidden:hidden];
    }
}

-(void)xlCutBarViewAlpha:(CGFloat)alpha{
    self.xlCutCompleteButton.alpha = alpha;
    self.xlCancelCutButton.alpha = alpha;
}

-(void)xlCutBarViewHidden:(BOOL)hidden{
    self.xlCutCompleteButton.hidden = hidden;
    self.xlCancelCutButton.hidden = hidden;
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
    
    NSLog(@"-------------------------------------------------------");
    NSLog(@"scrollView.contentSize w = %f, h = %f", _scrollView.contentSize.width, _scrollView.contentSize.height);
    
    NSLog(@"scrollView.contentOffset x = %f, y = %f", _scrollView.contentOffset.x, _scrollView.contentOffset.y);
    
    NSLog(@"scrollView.size w = %f, y = %f", _scrollView.frame.size.width, _scrollView.frame.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
