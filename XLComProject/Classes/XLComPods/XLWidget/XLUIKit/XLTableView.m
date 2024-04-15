//
//  XLTableView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLTableView.h"
#import "XLSystemMacro.h"
#import "XLDeviceMacro.h"

@interface XLTableView ()
@property (nonatomic, assign) BOOL estimatedEnable; /// 预估高度
@end

@implementation XLTableView

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            /// 间隔过大问题修改
            if(self.style == UITableViewStyleGrouped){
                // group类型时不能设置为0，否者会失效
                self.sectionHeaderTopPadding = CGFLOAT_MIN;
            } else {
                self.sectionHeaderTopPadding = 0.0f;
            }
        }
        if(XLAvailableiOS11) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if(self.style == UITableViewStyleGrouped){
            // group类型时不能设置为0，否者会失效
            self.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        } else {
            self.estimatedSectionHeaderHeight = 0.0f;
        }
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            /// 间隔过大问题修改
            if(self.style == UITableViewStyleGrouped){
                // group类型时不能设置为0，否者会失效
                self.sectionHeaderTopPadding = CGFLOAT_MIN;
            } else {
                self.sectionHeaderTopPadding = 0.0f;
            }
        }
        if(XLAvailableiOS11) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if(self.style == UITableViewStyleGrouped){
            // group类型时不能设置为0，否者会失效
            self.estimatedSectionHeaderHeight = CGFLOAT_MIN;
        } else {
            self.estimatedSectionHeaderHeight = 0.0f;
        }
    }
    return self;
}

/// 是否使用预估高度
/// @param enable <#enable description#>
-(void)setEstimatedEnable:(BOOL)enable{
    _estimatedEnable = enable;
    if (!enable) {
        if(XLAvailableiOS11) {
            if(self.style == UITableViewStyleGrouped){
                // group类型时不能设置为0，否者会失效
                self.estimatedRowHeight = CGFLOAT_MIN;
                self.estimatedSectionFooterHeight = CGFLOAT_MIN;
                self.estimatedSectionHeaderHeight = CGFLOAT_MIN;
            } else {
                self.estimatedRowHeight = 0;
                self.estimatedSectionFooterHeight = 0;
                self.estimatedSectionHeaderHeight = 0;
            }
        }
    }
}

/**
 配置代理
 
 @param delegate delegate
 */
-(void)configDelegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate{
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
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

-(void)xlAddMinRectFooterAndHeadView{
    CGRect minRect = CGRectMake(0, 0, XLScreenWidth(), CGFLOAT_MIN);
    self.tableHeaderView = [[UIView alloc] initWithFrame:minRect];
    self.tableFooterView = [[UIView alloc] initWithFrame:minRect];
}

// 底部添加footerview适配安全区域,解决顶部留白太宽问题
-(void)xlAdaptationSafeAreaAndTopSpaceArea{
    CGRect minRect = CGRectMake(0, 0, XLScreenWidth(), CGFLOAT_MIN);
    self.tableHeaderView = [[UIView alloc] initWithFrame:minRect];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, XLScreenWidth(), XLNavBottomHeight());
    self.tableFooterView = [[UIView alloc] initWithFrame:rect];
    self.tableFooterView.backgroundColor = self.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    if(self.tableFooterView){
        self.tableFooterView.backgroundColor = backgroundColor;
    }
}

@end
