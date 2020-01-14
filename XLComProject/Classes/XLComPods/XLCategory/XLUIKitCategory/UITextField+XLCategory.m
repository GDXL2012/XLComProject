//
//  UITextField+XLCategory.m
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/25.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import "UITextField+XLCategory.h"
#import "NSObject+XLCategory.h"
#import "NSString+XLCategory.h"

@implementation UITextField (XLCategory)

+(void)load{
    Class label = [UILabel class];
    SEL originalSel = NSSelectorFromString(@"setText:");
    SEL newSel      = NSSelectorFromString(@"setXLText:");
    [NSObject exchangeClassImplementations:label originalSel:originalSel newSel:newSel forClassMethod:NO];
}

-(void)setXLText:(NSString *)text{
    if ([NSString isNilString:text]) {
        [self setXLText:@""];
    } else {
        [self setXLText:text];
    }
}

/**
 设置占位文字颜色

 @param placeholder 占位文字
 @param color 颜色
 */
-(void)setPlaceholder:(NSString *)placeholder color:(UIColor *)color{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:color,
                                        NSFontAttributeName:self.font}];
    self.attributedPlaceholder = attrString;
}

//- (CGRect)leftViewRectForBounds:(CGRect)bounds {
//    CGRect leftRect = [super leftViewRectForBounds:bounds];
//    leftRect.origin.x += 8; //右边偏8
//    return leftRect;
//}
//
////UITextField 文字与输入框的距离
//- (CGRect)textRectForBounds:(CGRect)bounds{
//    if (!self.leftView && !self.rightView) {
//        return [super editingRectForBounds:bounds];
//    } else {
//        CGFloat leftDat = 10;
//        CGFloat rightDat = 10;
//        if (self.leftView) {
//            leftDat = 20 + 8 * 2;
//        }
//        if (self.clearButtonMode == UITextFieldViewModeWhileEditing) {
//            rightDat = 20 + 8 * 2;
//        }
//        return CGRectMake(leftDat, 0, bounds.size.width - leftDat - rightDat, bounds.size.height);
//    }
//}
//
////控制编辑文本的位置
//- (CGRect)editingRectForBounds:(CGRect)bounds{
//    if (!self.leftView && !self.rightView) {
//        return [super editingRectForBounds:bounds];
//    } else {
//        CGFloat leftDat = 10;
//        CGFloat rightDat = 10;
//        if (self.leftView) {
//            leftDat = 20 + 8 * 2;
//        }
//        if (self.clearButtonMode == UITextFieldViewModeWhileEditing) {
//            rightDat = 20;
//        }
//        return CGRectMake(leftDat, 0, bounds.size.width - leftDat - rightDat, bounds.size.height);
//    }
//}
@end
