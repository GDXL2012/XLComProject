//
//  XLCollectionView.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLCollectionView : UICollectionView

/**
 配置代理
 
 @param delegate delegate
 */
-(void)configDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)delegate;

/**
 注册Cell
 
 @param name NIB name
 @param identifier identifier
 */
-(void)registerNibName:(NSString *)name forCellReuseIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
