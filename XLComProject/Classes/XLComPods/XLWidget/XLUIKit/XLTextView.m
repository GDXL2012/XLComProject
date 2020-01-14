//
//  XLTextView.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "XLTextView.h"
#import "XLMacroFont.h"
#import "XLMacroColor.h"
#import "XLSystemMacro.h"
#import "Masonry.h"
#import "NSString+XLCategory.h"

@interface XLTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel   *placeHolderLabel;
@property (nonatomic, assign) CGFloat   textViewHeight;   // 缓存高度
@end

@implementation XLTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [super setDelegate:self];
        _textViewHeight = 0.0f;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [super setDelegate:self];
        _textViewHeight = 0.0f;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGPoint offset      = self.contentOffset;
    UIEdgeInsets inset1 = self.contentInset;
    UIEdgeInsets inset2 = self.textContainerInset;
    CGFloat linePadding = self.textContainer.lineFragmentPadding;
    
    CGFloat xOffset = offset.x + inset1.left + inset2.left + linePadding;
    CGFloat rOffset = inset1.left + inset2.left + linePadding;
    CGFloat yOffset = offset.y + inset1.top + inset2.top;
    [_placeHolderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(xOffset);
        make.right.mas_equalTo(self).offset(-rOffset);
        make.top.mas_equalTo(self).offset(yOffset);
    }];
}

-(void)setDelegate:(id<UITextViewDelegate>)delegate{
    [super setDelegate:self];
}

-(UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = XLHolderColor;
        _placeHolderLabel.font = XLGFont(17.0f);
        _placeHolderLabel.userInteractionEnabled = NO;
        [self addSubview:_placeHolderLabel];
        [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
    }
    return _placeHolderLabel;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

-(void)setPlaceHolderColor:(UIColor *)placeHolderColor{
    _placeHolderColor = placeHolderColor;
    self.placeHolderLabel.textColor = placeHolderColor;
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeHolderLabel.font = font;
}

-(void)setText:(NSString *)text{
    [super setText:text];
    if (text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
}

-(void)setTextContainerInset:(UIEdgeInsets)textContainerInset{
    [super setTextContainerInset:textContainerInset];
}

-(void)setContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
}

/**
 * 获取text能全部显示的最小高度
 * 注：该方法需在view显示后调用，否者可能不能返回正确的高度
 */
-(CGFloat)getMinHeightForView{
    NSString *inputString = self.text;
    if ([NSString isEmpty:inputString]) {
        return 0;
    } else {
        CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)];
        return size.height;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.xlDelegate textViewShouldBeginEditing:textView];
    } else {
       return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.xlDelegate textViewShouldEndEditing:textView];
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.xlDelegate textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.xlDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.xlDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.xlDelegate textViewDidChange:textView];
    }
    
    CGFloat datHeight = 0;
    CGFloat height = [self getMinHeightForView];
    if (self.textViewHeight > 0) {
        datHeight = height - self.textViewHeight;
    }
    self.textViewHeight = height;
    if (fabs(datHeight) > 0.01) {
        if(self.xlDelegate && [self.xlDelegate respondsToSelector:@selector(textView:heightChange:)]){
            [self.xlDelegate textView:self heightChange:self.frame.size.height + datHeight];
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.xlDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_ENUM_AVAILABLE_IOS(10_0){
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:interaction:)]) {
        return [self.xlDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange interaction:interaction];
    } else {
        return YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_ENUM_AVAILABLE_IOS(10_0){
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:interaction:)]) {
        return [self.xlDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange interaction:interaction];
    } else {
        return YES;
    }
}
#ifndef XLAvailableiOS10
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.xlDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    } else {
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.xlDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    } else {
        return YES;
    }
}
#else

#endif

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.xlDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2){
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.xlDelegate scrollViewDidZoom:scrollView];
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.xlDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.xlDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.xlDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.xlDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.xlDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.xlDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.xlDelegate viewForZoomingInScrollView:scrollView];
    } else {
        return nil;
    }
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.xlDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.xlDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.xlDelegate scrollViewShouldScrollToTop:scrollView];
    } else {
        return NO;
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.xlDelegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)){
    if (self.xlDelegate &&
        [self.xlDelegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
        [self.xlDelegate scrollViewDidChangeAdjustedContentInset:scrollView];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
