//
//  NSString+CRDealDecimal.m
//  CoinRise
//
//  Created by fst on 2019/7/17.
//  Copyright © 2019 leon. All rights reserved.
//

#import "NSString+CRDealDecimal.h"

@implementation NSString (CRDealDecimal)
- (NSString *)cr_keepFixedDecimalNum:(NSInteger)decimalNum
{
    if (decimalNum < 1) decimalNum = 1;
    NSString *limitZeroString = @"0000000000";//十个
    
    NSString *fixedDecimalNumString = @"";
    if ([self rangeOfString:@"."].location == NSNotFound)//整数
    {
        NSString *needAddDecimalString = [limitZeroString substringToIndex:decimalNum];
        fixedDecimalNumString =  [self stringByAppendingString:[NSString stringWithFormat:@".%@",needAddDecimalString]];
    }else{ //非整数
        NSRange range = [self rangeOfString:@"."];
        //当前字符串小数位数
        NSInteger currentDecimalNum = self.length - (range.location + 1);
        if (currentDecimalNum == decimalNum ) {
            return self;
        }else if(currentDecimalNum < decimalNum){//小数位数不够
            NSInteger needAddDecimalNum = decimalNum - currentDecimalNum;
            NSString *needAddDecimalString = [limitZeroString substringToIndex:needAddDecimalNum];
            fixedDecimalNumString = [self stringByAppendingString:needAddDecimalString];
        }else if(currentDecimalNum > decimalNum){//小数位数过多
            NSInteger needDecreaseDecimalNum = currentDecimalNum - decimalNum;
            fixedDecimalNumString = [self substringToIndex:self.length - needDecreaseDecimalNum];
        }
    }
    return fixedDecimalNumString;
}


- (NSString *)cr_stringNumberByAdding:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal
{
    return [self calculateStringNumber:stringNumber decimal:decimal roundingMode:NSRoundDown tag:0 isKeepFixedDecimal:isKeepFixedDecimal];
}

- (NSString *)cr_stringNumberBySubtracting:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal
{
    return [self calculateStringNumber:stringNumber decimal:decimal roundingMode:NSRoundDown tag:1 isKeepFixedDecimal:isKeepFixedDecimal];
}

- (NSString *)cr_stringNumberByMultiplyingBy:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal
{
    return [self calculateStringNumber:stringNumber decimal:decimal roundingMode:NSRoundDown tag:2 isKeepFixedDecimal:isKeepFixedDecimal];
}

- (NSString *)cr_stringNumberByDividingBy:(NSString *)stringNumber decimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal
{
    return [self calculateStringNumber:stringNumber decimal:decimal roundingMode:NSRoundDown tag:3 isKeepFixedDecimal:isKeepFixedDecimal];
}

- (NSString *)cr_stringNumberByMultiplyingBy:(NSString *)stringNumber decimal:(NSInteger)decimal roundingMode:(NSRoundingMode)mode isKeepFixedDecimal:(BOOL)isKeepFixedDecimal {
    return [self calculateStringNumber:stringNumber decimal:decimal roundingMode:mode tag:2 isKeepFixedDecimal:isKeepFixedDecimal];
}

- (NSString *)calculateStringNumber:(NSString *)stringNumber decimal:(NSInteger)decimal roundingMode:(NSRoundingMode)mode tag:(NSInteger)tag isKeepFixedDecimal:(BOOL)isKeepFixedDecimal
{

    if (!stringNumber) stringNumber = @"0";
    NSDecimalNumber *numLeft = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *numRight = [NSDecimalNumber decimalNumberWithString:stringNumber];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode
                                                                                             scale:decimal
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];

    NSDecimalNumber *resultDec = nil;
    switch (tag) {
        case 0:
            resultDec = [numLeft decimalNumberByAdding:numRight withBehavior:roundUp];
            break;
        case 1:
            resultDec = [numLeft decimalNumberBySubtracting:numRight withBehavior:roundUp];
            break;
        case 2:
            resultDec = [numLeft decimalNumberByMultiplyingBy:numRight withBehavior:roundUp];
            break;
        case 3:
            resultDec = [numLeft decimalNumberByDividingBy:numRight withBehavior:roundUp];
            break;
    }
    if (isKeepFixedDecimal)
        return [[NSString stringWithFormat:@"%@",resultDec] cr_keepFixedDecimalNum:decimal];
    return [NSString stringWithFormat:@"%@",resultDec];
}


- (NSString *)stringWithDecimal:(NSInteger)decimal isKeepFixedDecimal:(BOOL)isKeepFixedDecimal{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *WithdrawFees = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *divisor = [[NSDecimalNumber alloc] initWithDouble:pow(10, decimal)];
    NSString *pT = [NSString stringWithFormat:@"%@",[WithdrawFees decimalNumberByDividingBy:divisor withBehavior:roundingBehavior]];
    if (isKeepFixedDecimal)
        return [[NSString stringWithFormat:@"%@",pT] cr_keepFixedDecimalNum:decimal];
    return pT;
}

- (NSComparisonResult)cr_compare:(NSString *)string
{
    NSDecimalNumber *selfString = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *stringDec = [NSDecimalNumber decimalNumberWithString:string];
    return [selfString compare:stringDec];
}

@end
