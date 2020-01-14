//
//  XLCollectionView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLCollectionView.h"
#import "XLSystemMacro.h"

@implementation XLCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        if(XLAvailableiOS11) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

/**
 配置代理
 
 @param delegate delegate
 */
-(void)configDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)delegate{
    self.delegate = delegate;
    self.dataSource = delegate;
}

/**
 注册Cell
 
 @param name NIB name
 @param identifier identifier
 */
-(void)registerNibName:(NSString *)name forCellReuseIdentifier:(NSString *)identifier{
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:identifier];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
