//
//  XLBaseCollectionViewController.m
//  AFNetworking
//
//  Created by GDXL2012 on 2020/9/7.
//

#import "XLBaseCollectionViewController.h"
#import "XLDeviceMacro.h"
#import "UIView+XLConstraints.h"

@interface XLBaseCollectionViewController ()

@end

@implementation XLBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)xlInitViewDisplay{
    UICollectionViewFlowLayout *layout = [self flowLayout];
    self.xlCollectionView = [[XLCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.xlCollectionView];
    self.xlCollectionView.backgroundColor = [UIColor whiteColor];
    [self.xlCollectionView configDelegate:self];
    
    [self xlUserCustomizationView];
    [self xlMakeCollectionViewConstraints];
}

-(UICollectionViewFlowLayout *)flowLayout{
    return [[UICollectionViewFlowLayout alloc] init];
}

/**
 用户自定义View：取代基类的xlInitViewDisplay，子类继承后不要复写xlInitViewDisplay
 */
-(void)xlUserCustomizationView{
    // 子类继承
}

/// 子类实现后可设置CollectionView控件位置
-(void)xlMakeCollectionViewConstraints{
    [self.xlCollectionView makeConstraintsWithView:self.view];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// iPad 旋转监听：子类可以复写，处理回调
-(void)xlIpadDidChangeStatusBarNotification:(NSNotification *)notification{
    [self.xlCollectionView reloadData];
}
@end
