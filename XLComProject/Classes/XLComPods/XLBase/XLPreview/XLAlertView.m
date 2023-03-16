//
//  XLAlertView.m
//  XLComProject
//
//  Created by GDXL2012 on 2021/7/29.
//

#import "XLAlertView.h"
#import "XLTableView.h"
#import "Masonry.h"
#import "XLAdaptation.h"
#import "XLMacroColor.h"
#import "XLTableViewCell.h"
#import "XLCollectionView.h"
#import "XLMacroFont.h"
#import "XLMacroLayout.h"

typedef void(^XLAlertActionHandler)(XLAlertAction *action);

@interface XLAlertAction ()
@property (nonatomic, copy) XLAlertActionHandler handler;

@property (nonatomic, copy)     NSString *title;
@property (nonatomic, assign)   UIAlertActionStyle style;
@end

#pragma mark - XLAlertView
@interface XLAlertView () <UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *xlTitle;
@property (nonatomic, copy) NSString *xlMessage;
@property (nonatomic, copy) UILabel  *xlTitleLabel;
@property (nonatomic, copy) UILabel  *xlMessageLabel;

@property (nonatomic, strong) NSMutableArray <XLAlertAction *>  *actionArray;
@property (nonatomic, strong) XLAlertAction                     *cancelAction;

@property (nonatomic, strong) UIView            *whiteBgView;
@property (nonatomic, strong) UIView            *sepView;

@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;

+(instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
@end

static CGFloat kXLAlertTopSpace        = 25.0f;
@implementation XLAlertView

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle{
    if (preferredStyle == UIAlertControllerStyleActionSheet) {
        return [XLAlertSheetView alertWithTitle:title message:message];
    } else {
        return [XLAlertAlertView alertWithTitle:title message:message];
    }
}

+(instancetype)alertWithTitle:(NSString *)title message:(NSString *)message{
    return nil;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
        
        _actionArray = [NSMutableArray array];
        _messageTextAlignment = NSTextAlignmentCenter;
        
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.layer.masksToBounds = YES;
        [self addSubview:_whiteBgView];
        
        [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([self isKindOfClass:[XLAlertSheetView class]]) {
                make.left.mas_equalTo(self);
                make.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self.mas_bottom);
            } else {
                if (XLMiniScreen()) {
                    make.left.mas_equalTo(self).offset(35.0f);
                    make.right.mas_equalTo(self).offset(-35.0f);
                } else {
                    make.left.mas_equalTo(self).offset(55.0f);
                    make.right.mas_equalTo(self).offset(-55.0f);
                }
                make.centerX.mas_equalTo(self);
                make.centerY.mas_equalTo(self);
            }
        }];
        if([self isKindOfClass:[XLAlertSheetView class]]){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapAction)];
            tap.delegate = self;
            [self addGestureRecognizer:tap];
            self.userInteractionEnabled = YES;
        }
        
    }
    return self;
}

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment{
    _messageTextAlignment = messageTextAlignment;
    if (_xlMessageLabel) {
        _xlMessageLabel.textAlignment = messageTextAlignment;
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(void)alertTapAction{
    [self xlHidden];
}

-(void)xlShow{
}

-(void)xlHidden{
    [self.actionArray removeAllObjects];
    self.cancelAction = nil;
    [self removeFromSuperview];
}

-(void)addAction:(XLAlertAction *)action{
    if (action.style == UIAlertActionStyleCancel) {
        self.cancelAction = action;
    } else {
        [_actionArray addObject:action];
    }
}

-(void)setXlTitle:(NSString *)xlTitle{
    _xlTitle = xlTitle;
    if (xlTitle && xlTitle.length > 0) {
        if (_xlTitleLabel == nil) {
            _xlTitleLabel = [[UILabel alloc] init];
            _xlTitleLabel.textAlignment = NSTextAlignmentCenter;
            _xlTitleLabel.font = XLFont(16.0f);
            _xlTitleLabel.textColor = XLTitleColor;
            _xlTitleLabel.numberOfLines = 1;
        }
        _xlTitleLabel.text = xlTitle;
        
        [self addSubview:_xlTitleLabel];
        
        [self.xlTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.whiteBgView).offset(15.0f);
            make.right.mas_equalTo(self.whiteBgView).offset(-15.0f);
            make.top.mas_equalTo(self.whiteBgView).offset(kXLAlertTopSpace);
        }];
    }
}

-(void)setXlMessage:(NSString *)xlMessage{
    _xlMessage = xlMessage;
    if (xlMessage && xlMessage.length > 0) {
        if (_xlMessageLabel == nil) {
            _xlMessageLabel = [[UILabel alloc] init];
            _xlMessageLabel.textAlignment = self.messageTextAlignment;
            _xlMessageLabel.font = XLFont(15.0f);
            _xlMessageLabel.textColor = XLTitleColor;
            _xlMessageLabel.numberOfLines = 0;
        }
        _xlMessageLabel.text = xlMessage;
        [self addSubview:_xlMessageLabel];
        
        [self.xlMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.whiteBgView).offset(15.0f);
            make.right.mas_equalTo(self.whiteBgView).offset(-15.0f);
            if (self.xlTitleLabel) {
                make.top.mas_equalTo(self.xlTitleLabel.mas_bottom).offset(15.0f);
            } else {
                make.top.mas_equalTo(self.whiteBgView).offset(kXLAlertTopSpace);
            }
        }];
    }
}

@end

#pragma mark - XLAlertAlertView
@interface XLAlertAlertView ()
@property (nonatomic, strong) UILabel   *xlTitleLabel;
@property (nonatomic, strong) UILabel   *xlMessageLabel;
@property (nonatomic, strong) UIButton  *cancelButton;

@property (nonatomic, strong) UIView    *sepView1;
@end

static CGFloat kXLAlertItemHeight      = 48.0f;
static CGFloat kXLAlertCancelSpace     = 8.0f;
static CGFloat kXLAlertCornerRadius    = 6.0f;
@implementation XLAlertAlertView

+(instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    XLAlertAlertView *view = [[XLAlertAlertView alloc] initWithFrame:CGRectZero];
    view.xlTitle = title;
    view.xlMessage = message;
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.whiteBgView.layer.cornerRadius = kXLAlertCornerRadius;
        
        self.sepView = [[UIView alloc] init];
        self.sepView.backgroundColor = XLComSepColor;
        [self addSubview:self.sepView];
        
        self.sepView1 = [[UIView alloc] init];
        self.sepView1.backgroundColor = XLComSepColor;
        [self addSubview:self.sepView1];
    }
    return self;
}

-(void)xlShow{
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteBgView);
        make.right.mas_equalTo(self.whiteBgView);
        if (self.xlMessageLabel) {
            make.top.mas_equalTo(self.xlMessageLabel.mas_bottom).offset(kXLAlertTopSpace);
        } else {
            make.top.mas_equalTo(self.xlTitleLabel.mas_bottom).offset(kXLAlertTopSpace);
        }
        make.height.mas_equalTo(XLCellSepHeight);
    }];
    
    NSInteger itemCount = self.actionArray.count;
    NSInteger totalCount = itemCount;
    if (self.cancelAction) {
        totalCount ++;
    }
    BOOL fullWidth = totalCount != 2;
    BOOL addCancelButton = NO;
    
    UIButton *lastButton = nil;
    if (self.cancelAction) { /// 取消
        addCancelButton = YES;
        self.cancelButton = [self cancelButtonWithTitle:self.cancelAction.title];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.whiteBgView);
            if (self.xlMessageLabel) {
                make.top.mas_equalTo(self.xlMessageLabel.mas_bottom).offset(kXLAlertTopSpace);
            } else {
                make.top.mas_equalTo(self.xlTitleLabel.mas_bottom).offset(kXLAlertTopSpace);
            }
            make.height.mas_equalTo(kXLAlertItemHeight);
            if (fullWidth) {
                make.width.mas_equalTo(self.whiteBgView.mas_width);
            } else {
                make.width.mas_equalTo(self.whiteBgView.mas_width).multipliedBy(0.5f);
            }
            if (totalCount == 1) {
                make.bottom.mas_equalTo(self.whiteBgView);
            }
        }];
        addCancelButton = YES;
        
        lastButton = self.cancelButton;
    }
    
    for (NSInteger index = 0; index < itemCount; index ++) {
        XLAlertAction *action = self.actionArray[index];
        UIButton *button = [self otherButtonWithTitle:action.title];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kXLAlertItemHeight);
            make.right.mas_equalTo(self.whiteBgView);
            if (fullWidth) {
                make.left.mas_equalTo(self.whiteBgView);
            } else {
                make.width.mas_equalTo(self.whiteBgView.mas_width).multipliedBy(0.5f);
            }
            if (lastButton) {
                if (fullWidth) {
                    make.top.mas_equalTo(lastButton.mas_bottom);
                } else {
                    make.top.mas_equalTo(lastButton);
                }
            } else if (self.xlMessageLabel) {
                make.top.mas_equalTo(self.xlMessageLabel.mas_bottom).offset(kXLAlertTopSpace);
            } else {
                make.top.mas_equalTo(self.xlTitleLabel.mas_bottom).offset(kXLAlertTopSpace);
            }
            if (index == itemCount - 1) {
                make.bottom.mas_equalTo(self.whiteBgView);
            }
        }];
        button.tag = index;
    }
    if (totalCount == 2) {
        self.sepView1.hidden = NO;
        [self.sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.whiteBgView);
            make.top.mas_equalTo(lastButton);
            make.bottom.mas_equalTo(lastButton);
            make.width.mas_equalTo(XLCellSepHeight);
        }];
    } else {
        self.sepView1.hidden = YES;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    self.frame = window.bounds;
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.0f;
    }];
}

-(UIButton *)otherButtonWithTitle:(NSString *)title{
    UIButton *button = [self buttonWithTitle:title whithColor:XLHexColor(@"#005B80")];
    [button addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(UIButton *)cancelButtonWithTitle:(NSString *)title{
    UIButton *btn = [self buttonWithTitle:title whithColor:XLTitleColor];
    [btn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UIButton *)buttonWithTitle:(NSString *)title  whithColor:(UIColor *)color{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = XLFont(15.0f);
    [self addSubview:button];
    return button;
}

-(void)otherButtonClick:(UIButton *)button{
    NSInteger tag = button.tag;
    XLAlertAction *action = self.actionArray[tag];
    if (action.handler) {
        action.handler(action);
    }
    [self xlHidden];
}

-(void)cancelButtonClick:(UIButton *)button{
    if (self.cancelAction && self.cancelAction.handler) {
        self.cancelAction.handler(self.cancelAction);
    }
    [self xlHidden];
}

@end

#pragma mark - XLAlertSheetView
@interface XLAlertSheetView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLTableView *actionTableView;
@end

static CGFloat kXLAlertSheetItemHeight      = 55.0f;
static CGFloat kXLAlertSheetCancelSpace     = 8.0f;
static CGFloat kXLAlertSheetCornerRadius    = 10.0f;

@implementation XLAlertSheetView

+(instancetype)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message{
    XLAlertSheetView *view = [[XLAlertSheetView alloc] initWithFrame:CGRectZero];
    view.xlTitle = title;
    view.xlMessage = message;
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.whiteBgView.layer.cornerRadius = kXLAlertSheetCornerRadius;
        
        _actionTableView = [[XLTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _actionTableView.delegate = self;
        _actionTableView.bounces = NO;
        _actionTableView.dataSource = self;
        _actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_actionTableView];
        
        [_actionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.whiteBgView);
            make.right.mas_equalTo(self.whiteBgView);
            if (XLAvailableiOS11) {
                make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.mas_equalTo(self.mas_bottom);
            }
        }];
    }
    return self;
}

-(void)xlShow{
    [self.actionTableView reloadData];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [window addSubview:self];
    self.frame = window.bounds;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    NSInteger itemCount = self.actionArray.count;
    CGFloat contentHeight = kXLAlertSheetCornerRadius;
    if (itemCount > 0) {
        contentHeight = contentHeight + itemCount * kXLAlertSheetItemHeight;
    }
    if (self.cancelAction) {
        if (itemCount > 0) {
            contentHeight = contentHeight + kXLAlertSheetCancelSpace;
        }
        contentHeight = contentHeight + kXLAlertSheetItemHeight;
    }
    
    [_actionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.xlMessageLabel) {
            make.top.mas_equalTo(self.xlMessageLabel.mas_bottom).offset(12.0f);
        } else if (self.xlTitleLabel){
            make.top.mas_equalTo(self.xlTitleLabel.mas_bottom).offset(12.0f);
        } else {
            make.top.mas_equalTo(self.whiteBgView).offset(kXLAlertSheetCornerRadius);
        }
        make.height.mas_equalTo(contentHeight);
    }];
//    _actionTableView.frame = CGRectMake(0, screenSize.height, screenSize.width, contentHeight);
//
//    CGFloat bgHeight = contentHeight + kXLAlertSheetCornerRadius + XLNavBottomHeight();
//    self.whiteBgView.frame = CGRectMake(0, screenSize.height - kXLAlertSheetCornerRadius, screenSize.width,  contentHeight);
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.0f;
        CGFloat datY = screenSize.height - contentHeight - XLNavBottomHeight();
//        self.actionTableView.frame = CGRectMake(0, datY , screenSize.width, contentHeight);
//        self.whiteBgView.frame = CGRectMake(0, datY - kXLAlertSheetCornerRadius, screenSize.width, bgHeight);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger itemCount = self.actionArray.count;
    if (itemCount > 0 && self.cancelAction) {
        return 2;
    } else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger itemCount = self.actionArray.count;
    if (itemCount > 0 && section == 0) {
        return itemCount;
    } else {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return kXLAlertSheetCancelSpace;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kXLAlertSheetItemHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headViewID"];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headViewID"];
        headView.contentView.backgroundColor = XLComBGColor;
    }
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = XLFont(16.0f);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell.contentView);
            make.centerY.mas_equalTo(cell.contentView);
        }];
        titleLabel.tag = 1001;
        
        if (indexPath.section == 0 && indexPath.row != self.actionArray.count - 1) {
            UIView *xlSepView = [[UIView alloc] init];
            xlSepView.backgroundColor = XLComSepColor;
            [cell addSubview:xlSepView];
            [xlSepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell);
                make.right.mas_equalTo(cell);
                make.bottom.mas_equalTo(cell);
                make.height.mas_equalTo(XLCellSepHeight);
            }];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *tmpTitleLabel = [cell.contentView viewWithTag:1001];
    NSInteger itemCount = self.actionArray.count;
    if (itemCount > 0 && indexPath.section == 0) {
        XLAlertAction *acton = self.actionArray[indexPath.row];
        tmpTitleLabel.text = acton.title;
        if (acton.style == UIAlertActionStyleDefault) {
            tmpTitleLabel.textColor = XLTitleColor;
        } else {
            tmpTitleLabel.textColor = XLWarningColor;
        }
    } else {
        tmpTitleLabel.text = self.cancelAction.title;
        tmpTitleLabel.textColor = XLTitleColor;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger itemCount = self.actionArray.count;
    if (itemCount > 0 && indexPath.section == 0) {
        XLAlertAction *acton = self.actionArray[indexPath.row];
        if (acton.handler) {
            acton.handler(acton);
        }
    } else {
        if (self.cancelAction && self.cancelAction.handler) {
            self.cancelAction.handler(self.cancelAction);
        }
    }
    
    [self xlHidden];
}

#pragma mark - Ac

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation XLAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(XLAlertAction * _Nonnull))handler{
    XLAlertAction *action = [[XLAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}
@end
