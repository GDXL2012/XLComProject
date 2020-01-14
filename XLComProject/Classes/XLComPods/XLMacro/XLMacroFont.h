//
//  XLMacroFont.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#ifndef XLMacroFont_h
#define XLMacroFont_h
#import "UIFont+XLCategory.h"

// 字体方法: 非可变字体
#define XLFont(font)            [UIFont systemFontOfSize:font]
#define XLBFont(font)           [UIFont boldSystemFontOfSize:font]
#define XLFontName(font, name)  [UIFont fontWithName:name size:font]
/// 字体方法：可变字体
#define XLGFont(font)            [UIFont gradeSystemFontOfSize:font]
#define XLBGFont(font)           [UIFont gradeBoldSystemFontOfSize:font]
#define XLGFontName(font, name)  [UIFont gradeFontWithName:name size:font]

// 导航栏标题字号
#define XLBarTitleFont    XLBFont(18.0f)
#define XLBarItemFont     XLBFont(16.0f)

// 三级标题字体
#define XLTitle1Font     XLGFont(20.0f)
#define XLTitle2Font     XLGFont(18.0f)
#define XLTitle3Font     XLGFont(17.0f)

// 三级详情字体
#define XLDetail1Font     XLGFont(15.0f)
#define XLDetail2Font     XLGFont(14.0f)
#define XLDetail3Font     XLGFont(13.0f)

// cell 字体定义
#define XLCellT0Font    XLGFont(17.0f)
#define XLCellT1Font    XLGFont(15.0f)
#define XLCellD0Font    XLGFont(14.0f)
#define XLCellD1Font    XLGFont(13.0f)

#endif /* XLMacroFont_h */
