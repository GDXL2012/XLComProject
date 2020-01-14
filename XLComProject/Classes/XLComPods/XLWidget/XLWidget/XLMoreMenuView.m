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

@interface XLMoreMenuView()
@property (nonatomic, strong) UIImageView *blackView;
@end

static NSInteger MoreMenuItemTag     = 1000;     // 菜单按钮tag基础值
static CGFloat   MoreMenuItemWidth   = 150.0f;   // 菜单宽度
static CGFloat   MoreMenuItemHeight  = 45.0f;    // 菜单单项高度
static CGFloat   MoreMenuIcoHeight   = 18.0f;    // 菜单单项高度
static CGFloat   MoreMenuTopMargin   = 5.0f;     // 菜单上下两项多出的高度
static CGFloat   MoreMenuArrowHeight = 0.0f;     // 菜单上部箭头高度

static XLMoreMenuView *moreMenuView;

@implementation XLMoreMenuView
/**
 显示菜单
 
 @param titles <#titles description#>
 @param icos <#icos description#>
 @param view <#view description#>
 @param delegate <#delegate description#>
 */
+(void)showMenuView:(NSArray *)titles icos:(NSArray *)icos inView:(UIView *)view delegate:(id<XLMoreMenuViewDelegate>)delegate{
    moreMenuView = [[XLMoreMenuView alloc] initWithTitles:titles icos:icos];
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
-(instancetype)initWithTitles:(NSArray *)titles icos:(NSArray *)icos{
    self = [super init];
    if (self) {
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

-(void)displayViewWithTitles:(NSArray *)titles icos:(NSArray *)icos{
    self.backgroundColor = [UIColor clearColor];
    NSInteger count = titles.count;
    
    _blackView = [[UIImageView alloc] init];
    _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    _blackView.layer.cornerRadius = 4.0f;
    _blackView.layer.masksToBounds = YES;
    /// 替换为图片
//    UIImage *image = [UIImage imageNamed:@"xl_icon_common_pop"];
//    _blackView.image = image;
    [self addSubview:_blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-8.0f);
        make.top.mas_equalTo(self).offset(3.0f);
        make.width.mas_equalTo(MoreMenuItemWidth);
        make.height.mas_equalTo(MoreMenuArrowHeight + MoreMenuItemHeight * count + MoreMenuTopMargin * 2);
    }];
    for (NSInteger index = 0; index < count; index ++) {
        NSString *icoName = icos[index];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:icoName];
        [self addSubview:imageView];
        CGFloat height = MoreMenuIcoHeight;
        // Item整体偏移量
        CGFloat itemOffset = index * MoreMenuItemHeight + MoreMenuTopMargin + MoreMenuArrowHeight;
        // Item图标偏移量
        CGFloat icoOffset = itemOffset + (MoreMenuItemHeight - height) / 2.0f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.blackView).offset(16.0f);
            make.size.mas_equalTo(CGSizeMake(height, height));
            make.top.mas_equalTo(self.blackView).offset(icoOffset);
        }];
        
        NSString *title = titles[index];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = XLGFont(15.0f);
        [self addSubview:titleLabel];
        titleLabel.text = title;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(16.0f);
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
            sepView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];;
            [self addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(imageView);
                make.bottom.mas_equalTo(button);
                make.right.mas_equalTo(self.blackView);
                make.height.mas_equalTo(0.5f);
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
