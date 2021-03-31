//
//  NSNumber+CRDealDecimal.h
//  CoinRise
//
//  Created by wcb on 2019/9/21.
//  Copyright © 2019 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSNumber (CRDealDecimal)
/**
 四舍五入
 
 @param decimal 小数位数
 @return 四舍五入后的数字
 */
- (NSNumber *)cr_keepFixeddecimal:(NSInteger)decimal;
@end

NS_ASSUME_NONNULL_END
