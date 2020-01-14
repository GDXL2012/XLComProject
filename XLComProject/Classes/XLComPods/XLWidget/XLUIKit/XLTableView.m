//
//  XLTableView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/26.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLTableView.h"
#import "XLSystemMacro.h"

@interface XLTableView ()
@property (nonatomic, assign) BOOL estimatedEnable; /// 预估高度
@end

@implementation XLTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

/// 是否使用预估高度
/// @param enable <#enable description#>
-(void)setEstimatedEnable:(BOOL)enable{
    _estimatedEnable = enable;
    if (!enable) {
        if(XLAvailableiOS11) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
