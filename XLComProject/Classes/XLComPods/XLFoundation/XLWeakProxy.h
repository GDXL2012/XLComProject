//
//  XLWeakProxy.h
//  XLComProject
//
//  Created by GDXL2012 on 2019/11/24.
//  Copyright © 2019 GDXL2012. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWeakProxy : NSObject

+(instancetype)proxyWithTarget:(id)target;
-(instancetype)initWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
