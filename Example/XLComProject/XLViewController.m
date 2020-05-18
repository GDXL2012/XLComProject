//
//  XLViewController.m
//  XLComProject
//
//  Created by GDXL2012 on 01/14/2020.
//  Copyright (c) 2020 GDXL2012. All rights reserved.
//

#import "XLViewController.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIViewController+XLPreview.h"

@interface XLViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageView1;

@end

@implementation XLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(50.0f);
        make.top.mas_equalTo(self.view).offset(100.0f);
        make.size.mas_equalTo(CGSizeMake(175.0f, 108.5f));
    }];
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588509233124&di=4e7d2e93bfe60f9d09c4de45dff30ca5&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"];
    [_imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    
    _imageView1 = [[UIImageView alloc] init];
    _imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView1];
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(50.0f);
        make.top.mas_equalTo(self.view).offset(300.0f);
        make.size.mas_equalTo(CGSizeMake(200.0f, 78.0f));
    }];
    NSURL *url1 = [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2075387255,274293919&fm=26&gp=0.jpg"];
    [_imageView1 sd_setImageWithURL:url1 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture1)];
    [_imageView1 addGestureRecognizer:tap1];
    _imageView1.userInteractionEnabled = YES;
}

-(void)tapGesture{
    NSArray *array = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588578921699&di=766a725d4e2bc5aaa129b9217355fba6&imgtype=0&src=http%3A%2F%2Fqcloud.dpfile.com%2Fpc%2FUglJmFpQ4mufo3HUBQguN2aovEJf3KWLcT6tr5jAYnCfA-CHIjiwp8uGsS8A4LZUTK-l1dfmC-sNXFHV2eRvcw.jpg",
                       @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2075387255,274293919&fm=26&gp=0.jpg",
                       @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588509233124&di=4e7d2e93bfe60f9d09c4de45dff30ca5&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"];
//    [self previewImageArray:@[_imageView] atSelectIndex:0];
//    [self previewImageArray:@[_imageView] atSelectIndex:0];
    [self previewImageUrlArray:array atSelectIndex:1];
}

-(void)tapGesture1{
    [self previewImageViewArray:@[_imageView,_imageView1] atSelectIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
