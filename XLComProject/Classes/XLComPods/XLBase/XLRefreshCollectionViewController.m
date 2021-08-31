//
//  XLRefreshCollectionViewController.m
//  AFNetworking
//
//  Created by GDXL2012 on 2020/9/9.
//

#import "XLRefreshCollectionViewController.h"
#import "XLDeviceMacro.h"
#import "UIView+XLConstraints.h"

@interface XLRefreshCollectionViewController ()
@property (nonatomic, strong) UICollectionViewLayout *layout;
@end

@implementation XLRefreshCollectionViewController

/// 默认：
/// @param layout <#layout description#>
-(instancetype)initWithLayout:(nullable UICollectionViewLayout *)layout{
    if (self = [super init]) {
        _layout = layout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 初始化列表
 */
-(void)xlInitViewDisplay{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    _xlRefreshCollectionView = [[XLRefreshCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _xlRefreshCollectionView.backgroundColor = [UIColor whiteColor];
    [self.xlRefreshCollectionView configDelegate:self];
    [self.view addSubview:self.xlRefreshCollectionView];
    [self xlUserCustomizationView];
    [self xlMakeTableViewConstraints];
}

/**
 用户自定义View：取代基类的xlInitViewDisplay，子类继承后不要复写xlInitViewDisplay
 */
-(void)xlUserCustomizationView{
    // 子类继承
}

/// 子类实现后可设置TableView控件位置
-(void)xlMakeTableViewConstraints{
    [self.xlRefreshCollectionView makeConstraintsWithView:self.view];
}

// 下拉刷新
-(void)reloadTableViewForRefresh{
    [self.xlRefreshCollectionView reloadData];
    [self.xlRefreshCollectionView endRefreshing];
}

// 上拉刷新
-(void)reloadTableViewForLoadmore{
    [self.xlRefreshCollectionView reloadData];
    [self.xlRefreshCollectionView stopLoadingView];
}

#pragma mark - XLRefreshCollectionViewDelegate
// 下拉/上拉回调
-(void)refreshCollectionViewDidRefresh:(XLRefreshCollectionView *)refreshCollectionView{
    [self.xlRefreshCollectionView endRefreshing];
}
-(void)refreshCollectionViewDidLoadMore:(XLRefreshCollectionView *)refreshCollectionView{
    [self.xlRefreshCollectionView stopLoadingView];
}

// 设置是否需要下拉/上拉刷新
- (BOOL)isSetupCollectionViewRefreshModule:(XLRefreshCollectionView*)refreshCollectionView{
    return YES;
}
- (BOOL)isSetupCollectionViewLoadmoreModule:(XLRefreshCollectionView*)refreshCollectionView{
    return YES;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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
