//
//  NSNumber+CRDealDecimal.m
//  CoinRise
//
//  Created by wcb on 2019/9/21.
//  Copyright © 2019 leon. All rights reserved.
//

#import "NSNumber+CRDealDecimal.h"

@implementation NSNumber (CRDealDecimal)
- (NSNumber *)cr_keepFixeddecimal:(NSInteger)decimal
{
    if (decimal <= 0 || self == nil)
      return self;
    NSDecimalNumberHandler *round = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                           scale:decimal
                                                                                raiseOnExactness:NO
                                                                                 raiseOnOverflow:NO
                                                                                raiseOnUnderflow:NO
                                                                             raiseOnDivideByZero:YES];
    NSDecimalNumber *numDec = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@",self]];
    NSDecimalNumber *multiply = [NSDecimalNumber decimalNumberWithString:@"1"];
    return [numDec decimalNumberByMultiplyingBy:multiply withBehavior:round];
}
@end
