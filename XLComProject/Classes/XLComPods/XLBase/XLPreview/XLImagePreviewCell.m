//
//  XLImagePreviewCell.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/12/1.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLImagePreviewCell.h"
#import "XLPreviewItemInfo.h"
#import "Masonry.h"

@interface XLImagePreviewCell ()
@property (nonatomic, strong) XLImagePreviewView *previewView;
@end

@implementation XLImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.previewView = [[XLImagePreviewView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.previewView];
        [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

/// 清理背景
- (void)clearBackgroundColor{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self.previewView clearBackgroundColor];
}

-(void)setItemInfo:(XLPreviewItemInfo *)itemInfo{
    [self.previewView setItemInfo:itemInfo];
}

- (void)recoverPreviewView{
    [self.previewView recoverPreviewView];
}
@end
