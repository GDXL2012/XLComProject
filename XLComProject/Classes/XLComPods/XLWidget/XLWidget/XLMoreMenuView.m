//
//  XLMoreMenuView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLMoreMenuView.h"
#import "Masonry.h"
#import "XLMacroFont.h"
#import "NSString+XLCategory.h"
#import "UIColor+XLCategory.h"
#import "XLMacroLayout.h"

@interface XLMoreMenuView()
@property (nonatomic, strong)   UIImageView *blackView;
@property (nonatomic, strong)   UIView *arrowView;
@property (nonatomic, weak)     UIView *underView;
@property (nonatomic, weak)     UIView *showView;
@property (nonatomic, assign)   CGFloat xlMaxWidth;
@end

static NSInteger MoreMenuItemTag     = 1000;     // 菜单按钮tag基础值
//static CGFloat   MoreMenuItemWidth   = 150.0f; // 菜单宽度
static CGFloat   MoreMenuLeftMargin      = 15.0f;    // 菜单项左间距
static CGFloat   MoreMenuRightMargin     = 20.0f;    // 菜单项右间距
static CGFloat   MoreMenuItemMargin  = 12.0f;    // 菜单项内容间距
static CGFloat   MoreMenuItemHeight  = 48.0f;    // 菜单单项高度
static CGFloat   MoreMenuIcoHeight   = 24.0f;    // 菜单图标单项高度
static CGFloat   MoreMenuTopMargin   = 5.0f;     // 菜单上下两项多出的高度
static CGFloat   MoreMenuArrowHeight = 10.0f;    // 菜单上部箭头高度
static CGFloat   MoreMenuArrowWidth  = 20.0f;    // 菜单上部箭头宽度

static XLMoreMenuView *moreMenuView;

@implementation XLMoreMenuView

/**
 显示菜单
 
 @param titles <#titles description#>
 @param icos <#icos description#>
 @param view <#view description#>
 @param delegate <#delegate description#>
 */
+(void)showMenuView:(NSArray *)titles
               icos:(NSArray *)icos
             inView:(UIView *)view
           delegate:(id<XLMoreMenuViewDelegate>)delegate{
    [XLMoreMenuView showMenuView:titles icos:icos inView:view underView:nil delegate:delegate];
}
/**
 显示菜单
 */
+(void)showMenuView:(NSArray *)titles
               icos:(NSArray *)icos
             inView:(UIView *)view
          underView:(UIView *)underView
           delegate:(id<XLMoreMenuViewDelegate>)delegate{
    moreMenuView = [[XLMoreMenuView alloc] initWithTitles:titles icos:icos underView:underView inView:view];
    [view addSubview:moreMenuView];
    moreMenuView.menuDelegate = delegate;
    [moreMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
}

+(void)hiddenMenuView{
    if(moreMenuView){
        [moreMenuView removeFromSuperview];
        moreMenuView = nil;
    }
}

/**
 初始化
 
 @param titles 标题
 @param icos 图标
 @return <#return value description#>
 */
-(instancetype)initWithTitles:(NSArray *)titles
                         icos:(NSArray *)icos
                    underView:(UIView *)underView
                       inView:(UIView *)view{
    self = [super init];
    if (self) {
        self.underView = underView;
        self.showView = view;
        [self displayViewWithTitles:titles icos:icos];
        [self addTap];
    }
    return self;
}

-(void)addTap{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self addGestureRecognizer:gesture];
}

-(void)tapGesture{
    if(self.menuDelegate &&
       [self.menuDelegate respondsToSelector:@selector(moreMenuViewCancel)]){
        [self.menuDelegate moreMenuViewCancel];
    }
    [XLMoreMenuView hiddenMenuView];
}

-(void)xlUpdateMenuViewWidthWithTitles:(NSArray *)titles{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    self.xlMaxWidth = 0;
    for (NSString *title in titles) {
        CGSize size = [NSString sizeWithFont:XLGFont(17.0f) maxSize:maxSize string:title];
        CGFloat tmpWidth = MoreMenuLeftMargin + MoreMenuIcoHeight + MoreMenuItemMargin + ceil(size.width) + MoreMenuRightMargin;
        if (tmpWidth > self.xlMaxWidth) {
            self.xlMaxWidth = tmpWidth;
        }
    }
}

-(void)displayViewWithTitles:(NSArray *)titles icos:(NSArray *)icos{
    self.backgroundColor = [UIColor clearColor];
    NSInteger count = titles.count;
    
    [self xlUpdateMenuViewWidthWithTitles:titles];
    
    _blackView = [[UIImageView alloc] init];
    _blackView.backgroundColor = [UIColor colorWithHexString:@"#4C4C4C"];
    _blackView.layer.cornerRadius = XLButtonRadius;
    _blackView.layer.masksToBounds = YES;
    
    /// 替换为图片
//    UIImage *image = [UIImage imageNamed:@"xl_icon_common_pop"];
//    _blackView.image = image;
    [self addSubview:_blackView];
    
    CGFloat offset = 3.0f;
    if (self.underView != nil) {
        CGRect frame = [self.underView.superview convertRect:self.underView.frame toView:self.showView];
//        frame = [self.showView convertRect:self.underView.frame fromView:self.underView.superview];
        offset = offset + frame.size.height + frame.origin.y;
        
        if (MoreMenuArrowHeight > 0) {
            _arrowView = [[UIView alloc] init];
            _arrowView.backgroundColor = [UIColor clearColor];
            [self addSubview:_arrowView];
            CGFloat datX = frame.origin.x + frame.size.width / 2.0f - MoreMenuArrowWidth / 2.0f;
            [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(offset);
                make.left.mas_equalTo(datX);
                make.size.mas_equalTo(CGSizeMake(MoreMenuArrowWidth, MoreMenuArrowHeight));
            }];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(MoreMenuArrowWidth / 2.0f, 0.0f)];
            [path addLineToPoint:CGPointMake(MoreMenuArrowWidth, MoreMenuArrowHeight)];
            [path addLineToPoint:CGPointMake(0.0f, MoreMenuArrowHeight)];
            [path closePath];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.fillColor = [UIColor colorWithHexString:@"#4C4C4C"].CGColor;
            layer.path = path.CGPath;

            [_arrowView.layer addSublayer:layer];
            
            offset = offset + MoreMenuArrowHeight;
        }
    }
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-12.0f);
        make.top.mas_equalTo(self).offset(offset);
        make.width.mas_equalTo(self.xlMaxWidth);
        make.height.mas_equalTo(MoreMenuItemHeight * count + MoreMenuTopMargin * 2);
    }];
    
    for (NSInteger index = 0; index < count; index ++) {
        NSString *icoName = icos[index];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:icoName];
        [self addSubview:imageView];
        CGFloat height = MoreMenuIcoHeight;
        // Item整体偏移量
        CGFloat itemOffset = index * MoreMenuItemHeight + MoreMenuTopMargin;
        // Item图标偏移量
        CGFloat icoOffset = itemOffset + (MoreMenuItemHeight - height) / 2.0f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.blackView).offset(MoreMenuLeftMargin);
            make.size.mas_equalTo(CGSizeMake(height, height));
            make.top.mas_equalTo(self.blackView).offset(icoOffset);
        }];
        
        NSString *title = titles[index];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = XLGFont(17.0f);
        [self addSubview:titleLabel];
        titleLabel.text = title;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(MoreMenuItemMargin);
            make.centerY.mas_equalTo(imageView);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = MoreMenuItemTag + index;
        [self addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.blackView);
            make.top.mas_equalTo(self.blackView).offset(itemOffset);
            make.right.mas_equalTo(self.blackView);
            make.height.mas_equalTo(MoreMenuItemHeight);
        }];
        [button addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (count > 1 && index < count - 1) {
            UIView *sepView = [[UIView alloc] init];
//            sepView.backgroundColor = [UIColor colorWithHexString:@"#6f6f6f"];
            sepView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
            [self addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel);
                make.bottom.mas_equalTo(button);
                make.right.mas_equalTo(self.blackView).offset(-5.0f);
                make.height.mas_equalTo(XLCellSepHeight);
            }];
        }
    }
}

/**
 按钮点击事件

 @param button <#button description#>
 */
-(void)menuButtonClick:(UIButton *)button{
    if (self.menuDelegate &&
        [self.menuDelegate respondsToSelector:@selector(moreMenuView:clickAtIndex:)]) {
        NSInteger index = button.tag - MoreMenuItemTag;
        [self.menuDelegate moreMenuView:self clickAtIndex:index];
    }
    [XLMoreMenuView hiddenMenuView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
