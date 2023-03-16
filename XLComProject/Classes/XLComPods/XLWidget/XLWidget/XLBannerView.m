////
////  XLBannerView.m
////  CHNMed
////
////  Created by GDXL2012 on 2023/2/7.
////  Copyright © 2023 GDXL2012. All rights reserved.
////
//
//#import "XLBannerView.h"
//#import "XLWeakTimer.h"
//#import "XLCollectionView.h"
//
//@interface XLBannerView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
//// 是否首次设置内容偏移：首次需要定位到中间位置
//@property (nonatomic, assign) BOOL firstSetContentOffset;
//// 是否切页：用于切页后忽略差值异常的项，避免快速滑动过程中偏移量值异常错误
//@property (nonatomic, assign) BOOL hasSwithPage;
//
//@property (nonatomic, copy) NSArray *confBannerDatas;
//
//@property (nonatomic, strong) XLCollectionView *xlCollectionView;
//@property (nonatomic, strong) UIPageControl *pageControl;
//
//@property (nonatomic, strong) XLWeakTimer *bannerTimer;
//@property (nonatomic, assign) NSInteger dataCount;
//@property (nonatomic, strong) NSIndexPath *willDisplayIndexPath;
//@property (nonatomic, strong) NSIndexPath *currentIndexPath;
//
////@property (nonatomic, assign) BOOL needFixForDragging; // 拖动修正：连续快速拖动
//@end
//
//@implementation XLBannerView
//
///**
// 初始化
// @param rect 宽度：用于Item计算
// @param layout layout
// @return 实例对象
// */
//-(instancetype)initWithFrame:(CGRect)rect collectionViewLayout:(UICollectionViewLayout *)layout{
//    self = [super initWithFrame:rect];
//    if (self) {
//        _firstSetContentOffset = YES;
//        _dataCount = 0;
//        _willDisplayIndexPath = nil;
//        _currentIndexPath = nil;
////        _needFixForDragging = NO;
//        [self intiViewDisplay:rect collectionViewLayout:layout];
//        [self initPageControl];
//    }
//    return self;
//}
//
//#pragma mark - BannerTimer 定时器
//-(void)startBannerTimer{
//    if (!_bannerTimer) {
//        _bannerTimer = [XLWeakTimer weakTimerWithTimeInterval:2.5f target:self selector:@selector(bannerTimerLoop) userInfo:@"" repeats:YES];
//        [XLWeakTimer addWeakTimer:_bannerTimer forMode:NSDefaultRunLoopMode];
//    }
//    [_bannerTimer fire];
//}
//
//-(void)reStartBannerTimer{
//    if (!_bannerTimer) {
//        _bannerTimer = [XLWeakTimer weakTimerWithTimeInterval:2.5f target:self selector:@selector(bannerTimerLoop) userInfo:@"" repeats:YES];
//        [XLWeakTimer addWeakTimer:_bannerTimer forMode:NSDefaultRunLoopMode];
//    }
//    [_bannerTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
//}
//
//-(void)stopBannerTimer{
//    if (_bannerTimer) {
//        [self.bannerTimer setFireDate:[NSDate distantFuture]];
//    }
//}
//
//-(void)bannerTimerLoop{
//    // TODO: 循环
//    [self nextAdBanner];
//}
//
///**
// 下个广告
// */
//-(void)nextAdBanner{
//    NSInteger page = self.pageControl.currentPage;
//    [self.xlCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//}
//
//#pragma mark - C
//
//-(void)initPageControl{
//    _pageControl = [[UIPageControl alloc] init];
//    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    _pageControl.userInteractionEnabled = NO;
//    _pageControl.numberOfPages = 0;
//    [self addSubview:_pageControl];
////    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.mas_equalTo(self);
////        make.bottom.mas_equalTo(self).offset(-15.0f);
////        make.width.mas_equalTo(200);
////        make.height.mas_equalTo(30.0f);
////    }];
//}
//
//#pragma mark - InitView
//-(void)intiViewDisplay:(CGRect)rect collectionViewLayout:(UICollectionViewLayout *)layout{
//    _xlCollectionView = [[XLCollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
//    [self addSubview:_xlCollectionView];
//    
//    UIView *sepView = [[UIView alloc] init];
//    sepView.backgroundColor = XLComSepColor;
//    [self addSubview:sepView];
//    [sepView makeConstraintsWithViewBottom:self height:15.0f];
//    [_xlCollectionView makeConstraintsWithView:self header:nil bottom:sepView];
//    
//    self.xlCollectionView.showsHorizontalScrollIndicator = NO;
//    self.xlCollectionView.showsVerticalScrollIndicator = NO;
//    self.xlCollectionView.bounces = YES;
//    self.xlCollectionView.pagingEnabled = YES;
//    self.xlCollectionView.dataSource = self;
//    self.xlCollectionView.delegate = self;
//    [self.xlCollectionView registerNibName:@"XLTreatmentRoomInviteCollectionCell" forCellReuseIdentifier:@"XLTreatmentRoomInviteCollectionCellID"];
//}
//
///**
// 设置数据
// @param bannerDatas <#bannerDatas description#>
// */
//- (void)setConfBannerDatas:(NSArray *)bannerDatas{
//    _confBannerDatas = bannerDatas;
//    _dataCount = bannerDatas.count;
//    _pageControl.numberOfPages = self.dataCount;
//    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    _pageControl.currentPageIndicatorTintColor = CMThemeBtnColor;
//    CGSize pointSize = [_pageControl sizeForNumberOfPages:bannerDatas.count];
////    CGFloat datBottom = (pointSize.height - 30.0f) / 2 -15.0f;
//    [_pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self);
//        make.bottom.mas_equalTo(self).offset(-15.0f);
//        make.width.mas_equalTo(pointSize.width);
//        make.height.mas_equalTo(pointSize.height);
//    }];
//    
//    [self.xlCollectionView reloadData];
//    if(self.dataCount > 1){
//        [self startBannerTimer];
//        _pageControl.hidden = NO;
//    } else {
//        _pageControl.hidden = YES;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.dataCount > 1 &&
//            self.xlCollectionView.contentOffset.x <= 0 &&
//            self.firstSetContentOffset) {
//            self.firstSetContentOffset = NO;
//            [self fixBannerViewPositionForEnd];
//        }
//    });
//}
//
//// 滑动到最开始位置后修正定位
//-(void)fixBannerViewPositionForBegain{
//    if(self.dataCount > 1){
//        NSInteger targetIndex = self.dataCount;
//        self.firstSetContentOffset = NO;
//        [self.xlCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    }
//}
//
//-(void)fixBannerViewPositionForEnd{
//    if(self.dataCount > 1){
//        NSInteger targetIndex = 1;
//        self.firstSetContentOffset = NO;
//        [self.xlCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//    }
//}
//
//// 滚动后更新广告图位置
//-(void)updateBannerPositionOfterScroll{
//    if(self.dataCount > 1){
//        CGFloat offsetX = self.xlCollectionView.contentOffset.x;
//        if (offsetX <= 20.0f) { // 此处使用20像素：如果是0，依然会出现卡顿
//            [self fixBannerViewPositionForBegain];
//        } else if (offsetX >= self.frame.size.width * (self.dataCount + 1) - 20.0f){
//            [self fixBannerViewPositionForEnd];
//        } else {
//            // 其他时候忽略滚动
//        }
//    }
//}
//
//// 在开始拖动前修正位置，避免连续快速滑动，导致修正位置操作么有执行
//-(void)fixBannerPositionBeforeScroll{
//    if(self.dataCount > 1){
//        CGFloat offsetX = self.xlCollectionView.contentOffset.x;
//        if (offsetX <= 20.0f) { // 此处使用20像素：如果是0，依然会出现卡顿
//            [self fixBannerViewPositionForBegain];
//        } else if (offsetX >= self.frame.size.width * (self.dataCount + 1) - 20.0f){
//            [self fixBannerViewPositionForEnd];
//        } else {
//            // 其他时候忽略滚动
//        }
//    }
//}
//
//#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    // 不能放在此处，更新太慢，连续快速拖动边界处会出现不能继续拖动的问题
//    [self stopBannerTimer];
////    if(self.needFixForDragging){
////        self.needFixForDragging = NO;
////        [self fixBannerPositionBeforeScroll];
////    }
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    // 不能放在此处，更新太慢，连续快速拖动边界处会出现不能继续拖动的问题
////    if(self.needFixForDragging){
////        self.needFixForDragging = NO;
//        [self fixBannerPositionBeforeScroll];
////    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if(!decelerate){
//        [self reStartBannerTimer];
//        // 不能放在此处，更新太慢，连续快速拖动边界处会出现不能继续拖动的问题
////        [self updateBannerPositionOfterScroll];
//    }
//}
//
////停止滚动
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self reStartBannerTimer];
//    // 不能放在此处，更新太慢，连续快速拖动边界处会出现不能继续拖动的问题
////    self.needFixForDragging = NO;
////    [self updateBannerPositionOfterScroll];
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    // 不能放在此处，更新太慢，连续快速拖动边界处会出现不能继续拖动的问题
//    [self updateBannerPositionOfterScroll];
//}
//
//// 三页轮询
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSInteger count = self.confBannerDatas.count;
//    if(count == 1){
//        return 1;
//    } else if (count == 0){
//        return 0;
//    } else {
//        return count + 2; // 前后各冗余一个节点
//    }
//}
//
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 0.0f;
//}
//
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0.0f;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.dataCount > 1){
//        return CGSizeMake(XLScreenWidth()(), CMConfMultiBannerHeight - 15.0f);
//    }
//    return CGSizeMake(XLScreenWidth()(), CMConfBannerHeight - 15.0f);
//}
//
//-(NSInteger)fixIndexAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.dataCount > 1){
//        if(indexPath.row == 0){
//            return self.dataCount - 1;
//        } else if(indexPath.row == self.dataCount + 1){
//            return 0;
//        } else {
//            return indexPath.row - 1;
//        }
//    } else {
//        return indexPath.row;
//    }
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger indexRow = [self fixIndexAtIndexPath:indexPath];
//    
//    CMTreatmentRoomInviteModel *model = self.confBannerDatas[indexRow];
//    XLTreatmentRoomInviteCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLTreatmentRoomInviteCollectionCellID" forIndexPath:indexPath];
//    [cell bindingTreatmentInviteInfo:model];
//    NSString *name = cell.cmNameLabel.text;
//    cell.cmNameLabel.text = [NSString stringWithFormat:@"%@%ld", name, indexRow];
//    return cell;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.xlDelegate &&
//       [self.xlDelegate respondsToSelector:@selector(bannerView:clickAtIndex:)]){
//        NSInteger indexRow = [self fixIndexAtIndexPath:indexPath];
//        [self.xlDelegate bannerView:self clickAtIndex:indexRow];
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    _willDisplayIndexPath = indexPath;
//    
//    NSInteger indexRow = [self fixIndexAtIndexPath:indexPath];
//    _pageControl.currentPage = indexRow;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == self.willDisplayIndexPath.row) {
//        // 与将要显示的是同一个:说明又划回去，恢复状态
//        NSInteger indexRow = [self fixIndexAtIndexPath:self.currentIndexPath];
//        _pageControl.currentPage = indexRow;
//    } else {
//        self.currentIndexPath = self.willDisplayIndexPath;
//    }
//}
//
//@end
