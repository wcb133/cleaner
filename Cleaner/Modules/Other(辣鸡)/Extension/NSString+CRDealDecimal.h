//
//  NSString+CRDealDecimal.h
//  CoinRise
//
//  Created by fst on 2019/7/17.
//  Copyright © 2019 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CRDealDecimal)

/**
 处理小数位数不足的情况

 @param decimalNum 指定的小数位数,多余指定小数位数的将会被舍弃，少于的将会补0
 @return 符合指定小数位数的字符串
 */
- (NSString *)cr_keepFixedDecimalNum:(NSInteger)decimalNum;


/**
 两数字字符串相加

 @param stringNumber 数字字符串
 @param decimal 保留小数位数
 @param isKeepFixedDecimal 小数位数不够时是否需要补0
 @return 相加结果字符串
 */
- (NSString *)cr_stringNumberByAdding:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal;

/**
 两数字字符串相减(结果)

 @param stringNumber 减数
 @param decimal 保留小数位数
 @param isKeepFixedDecimal 小数位数不够时是否需要补0
 @return 相减结果字符串
 */
- (NSString *)cr_stringNumberBySubtracting:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal;

/**
 两数字字符串相乘

 @param stringNumber 数字字符串
 @param decimal 保留小数位数
 @param isKeepFixedDecimal 小数位数不够时是否需要补0
 @return 相乘结果字符串
 */
- (NSString *)cr_stringNumberByMultiplyingBy:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal;

/**
 两数字字符串相除

 @param stringNumber 除数
 @param decimal 保留小数位数
 @param isKeepFixedDecimal 小数位数不够时是否需要补0
 @return 相除结果字符串
 */
- (NSString *)cr_stringNumberByDividingBy:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal;

/**
 数字保留小数位（传入小数位数）
 */
- (NSString *)stringWithDecimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal;


/**
 比较两数字字符串大小

 @param string 字符串数字
 @return NSOrderedSame相等，NSOrderedAscending小于string，NSOrderedDescending大于string
 */
- (NSComparisonResult)cr_compare:(NSString *)string;


/**
 两数字字符串相乘

 @param stringNumber 数字字符串
 @param decimal 保留小数位数
 @param isKeepFixedDecimal 小数位数不够时是否需要补0
 @param mode 运算结果进位方式
 @return 相乘结果字符串
 */
- (NSString *)cr_stringNumberByMultiplyingBy:(NSString *)stringNumber decimal:(NSInteger)decimal roundingMode:(NSRoundingMode)mode isKeepFixedDecimal:(BOOL)isKeepFixedDecimal;


@end

