//
//  NSDictionary+AscendingKey.h
//  carbonDriver
//
//  Created by leon on 2019/1/17.
//  Copyright © 2019年 leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AscendingKey)

/**
 字典按照key值升序 并拼接参数 &
 
 @return 拼接完成的字符串
 */
- (NSString *)ascendingKey;



/**
 字典转json 再AES加密

 @return 加密之后字符串
 */
- (NSString *)switchJsonAndAESencry;


@end
