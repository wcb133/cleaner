//
//  NSDictionary+AscendingKey.m
//  carbonDriver
//
//  Created by leon on 2019/1/17.
//  Copyright © 2019年 leon. All rights reserved.
//

#import "NSDictionary+AscendingKey.h"
#import "NSString+tool.h"

@implementation NSDictionary (AscendingKey)

- (NSString *)ascendingKey {
    NSArray *keyArray = [self allKeys];
    
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[self objectForKey:sortString]];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    
    NSString *signString = [NSString shaKeyHmac:sign];//签名
    
    
    return signString;
}

- (NSString *)switchJsonAndAESencry {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *secretStr = [jsonStr aci_encryptWithAES];
    
    
    return secretStr;
}

@end
