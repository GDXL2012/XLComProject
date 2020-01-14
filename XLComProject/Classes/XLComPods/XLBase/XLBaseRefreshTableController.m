//
//  XLBaseRefreshTableController.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/27.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLBaseRefreshTableController.h"
#import "XLDeviceMacro.h"
#import "UIView+XLConstraints.h"

@interface XLBaseRefreshTableController ()
@property (nonatomic, assign) UITableViewStyle xlTableStyle;
@end

@implementation XLBaseRefreshTableController
-(instancetype)init{
    return [self initWithTableViewStyle:UITableViewStylePlain];
}

/**
 初始化
 
 @param style 列表类型
 @return 实例对象
 */
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

/**
 初始化列表
 */
-(void)initViewDisplay{
    _xlRefreshTableView = [[XLRefreshTableView alloc] initWithFrame:CGRectZero style:self.xlTableStyle];
    [_xlRefreshTableView configDelegate:self];
    [self.view addSubview:self.xlRefreshTableView];
    [self.xlRefreshTableView setEstimatedEnable:NO];
    [self xlConfigEmptyHeadFooterView];
    [self xlMakeTableViewConstraints];
}

/**
 配置Empty HeadFooter View
 */
-(void)xlConfigEmptyHeadFooterView{
    CGRect minRect = CGRectMake(0, 0, XLScreenWidth, CGFLOAT_MIN);
    self.xlRefreshTableView.tableHeaderView = [[UIView alloc] initWithFrame:minRect];
    self.xlRefreshTableView.tableFooterView = [[UIView alloc] initWithFrame:minRect];
}

/**
 用户自定义View：取代基类的initViewDisplay，子类继承后不要复写initViewDisplay
 */
-(void)xlUserCustomizationView{
    // 子类继承
}

/// 子类实现后可设置TableView控件位置
-(void)xlMakeTableViewConstraints{
    [self.xlRefreshTableView makeConstraintsWithView:self.view];
}

// 下拉刷新
-(void)reloadTableViewForRefresh{
    [self.xlRefreshTableView reloadData];
    [self.xlRefreshTableView endRefreshing];
}

// 上拉刷新
-(void)reloadTableViewForLoadmore{
    [self.xlRefreshTableView reloadData];
    [self.xlRefreshTableView stopLoadingView];
}

#pragma mark - MORefreshTableViewDelegate
// 下拉/上拉回调
-(void)refreshTableViewDidRefresh:(XLRefreshTableView *)refreshTableView{
    // TODO:
    [self.xlRefreshTableView endRefreshing];
}

-(void)refreshTableViewDidLoadMore:(XLRefreshTableView *)refreshTableView{
    // TODO:
    [self.xlRefreshTableView stopLoadingView];
}

// 设置是否需要下拉/上拉刷新
- (BOOL)isSetupRefreshModule:(XLRefreshTableView*)refreshTableView{
    return YES;
}

- (BOOL)isSetupLoadmoreModule:(XLRefreshTableView*)refreshTableView{
    return YES;
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
    // Dispose of any resources that can be recreated.
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
