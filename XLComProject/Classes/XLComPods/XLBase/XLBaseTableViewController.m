//
//  XLBaseTableViewController.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseTableViewController.h"
#import "XLDeviceMacro.h"
#import "UIView+XLConstraints.h"

@interface XLBaseTableViewController ()
@property (nonatomic, assign) UITableViewStyle xlTableStyle;
@end

@implementation XLBaseTableViewController
-(instancetype)init{
    return [self initWithTableViewStyle:UITableViewStylePlain];
}

/// 初始化
/// @param style <#style description#>
-(instancetype)initWithTableViewStyle:(UITableViewStyle)style{
    self = [super init];
    if (self) {
        self.xlTableStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self xlUserCustomizationView];
}

-(void)initViewDisplay{
    _xlTableView = [[XLTableView alloc] initWithFrame:CGRectZero style:self.xlTableStyle];
    [_xlTableView configDelegate:self];
    [self.view addSubview:_xlTableView];
    [_xlTableView setEstimatedEnable:NO];
    [self xlConfigEmptyHeadFooterView];
    [self xlMakeTableViewConstraints];
    _xlTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 用户自定义View：取代基类的initViewDisplay，子类继承后不要复写initViewDisplay
 */
-(void)xlUserCustomizationView{
    // 子类继承
}

/// 子类实现后可设置TableView控件位置
-(void)xlMakeTableViewConstraints{
    [self.xlTableView makeConstraintsWithView:self.view];
}

/**
 配置Empty HeadFooter View
 */
-(void)xlConfigEmptyHeadFooterView{
    CGRect minRect = CGRectMake(0, 0, XLScreenWidth, CGFLOAT_MIN);
    self.xlTableView.tableHeaderView = [[UIView alloc] initWithFrame:minRect];
    self.xlTableView.tableFooterView = [[UIView alloc] initWithFrame:minRect];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain) {
        return 0.0f;
    } else {
        return CGFLOAT_MIN;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.style == UITableViewStylePlain) {
        return 0.0f;
    } else {
        return CGFLOAT_MIN;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
