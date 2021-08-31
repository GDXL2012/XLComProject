//
//  XLAlertSheetView.m
//  XLComProject
//
//  Created by GDXL2012 on 2021/7/29.
//

#import "XLAlertSheetView.h"
#import "XLTableView.h"
#import "Masonry.h"
#import "XLSystemMacro.h"
#import "XLDeviceMacro.h"
#import "XLMacroColor.h"
#import "XLTableViewCell.h"
#import "XLMacroFont.h"

typedef void(^XLAlertActionHandler)(XLAlertAction *action);

@interface XLAlertAction ()
@property (nonatomic, copy) XLAlertActionHandler handler;

@property (nonatomic, copy)     NSString *title;
@property (nonatomic, assign)   UIAlertActionStyle style;
@end

@interface XLAlertSheetView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <XLAlertAction *>  *actionArray;
@property (nonatomic, strong) XLAlertAction                     *cancelAction;

@property (nonatomic, strong) UIView *whiteBgView;
@property (nonatomic, strong) XLTableView *actionTableView;
@end

static CGFloat kXLAlertSheetItemHeight      = 55.0f;
static CGFloat kXLAlertSheetCancelSpace     = 8.0f;
static CGFloat kXLAlertSheetCornerRadius    = 10.0f;

@implementation XLAlertSheetView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
        
        _actionArray = [NSMutableArray array];
        
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
        _whiteBgView.layer.masksToBounds = YES;
        _whiteBgView.layer.cornerRadius = kXLAlertSheetCornerRadius;
        [self addSubview:_whiteBgView];
        
        _actionTableView = [[XLTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _actionTableView.delegate = self;
        _actionTableView.bounces = NO;
        _actionTableView.dataSource = self;
        _actionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_actionTableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertTapAction)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)alertTapAction{
    [self xlHidden];
}

-(void)addAction:(XLAlertAction *)action{
    if (action.style == UIAlertActionStyleCancel) {
        self.cancelAction = action;
    } else {
        [_actionArray addObject:action];
    }
}

-(void)xlShow{
    [self.actionTableView reloadData];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
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
    [window addSubview:self];
    self.frame = window.bounds;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _actionTableView.frame = CGRectMake(0, screenSize.height, screenSize.width, contentHeight);
    
    CGFloat bgHeight = contentHeight + kXLAlertSheetCornerRadius + XLNavBottomHeight;
    _whiteBgView.frame = CGRectMake(0, screenSize.height - kXLAlertSheetCornerRadius, screenSize.width,  contentHeight);
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1.0f;
        CGFloat datY = screenSize.height - contentHeight - XLNavBottomHeight;
        self.actionTableView.frame = CGRectMake(0, datY , screenSize.width, contentHeight);
        _whiteBgView.frame = CGRectMake(0, datY - kXLAlertSheetCornerRadius, screenSize.width, bgHeight);
    }];
}

-(void)xlHidden{
    [self.actionArray removeAllObjects];
    self.cancelAction = nil;
    [self removeFromSuperview];
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
        headView.contentView.backgroundColor = XLContBGColor;
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
