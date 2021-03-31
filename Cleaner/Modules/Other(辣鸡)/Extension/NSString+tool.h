//
//  NSString+tool.h
//  Helloworld2
//
//  Created by hyf on 16/7/3.
//  Copyright © 2016年 lgg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (tool)
+ (NSString *)securityString:(NSInteger)n;
+ (NSString *)charArrayToString:(char[])charArray length:(int)length;
+ (NSString *)getCurrentDeviceName;
+ (NSString *)getPrice:(double)price withDecimal:(NSInteger)decemal;
+ (NSString *)GB2312CharToUTF8:(char *)ss;
+ (NSString *)reverStringAndchangeToBase64:(NSString *)oldString;
+ (NSString *)recoverToOriginalString:(NSString *)base64String;
- (NSString *)removeBlankString;
//- (CGSize)sizeWithMaxW:(CGFloat)maxW maxH:(CGFloat)maxH font:(UIFont *)font;
- (NSString *)getSHA1;
//hash256
+ (NSString *)shaKeyHmac:(NSString *)plaintext;
- (NSString *)getMD5String;
//+(NSMutableAttributedString *)setSubstrColor:(UIColor *)color and:(NSString *)originalStr and:(NSRange)range;
//- (CGFloat)getStrHeightWith:(NSString *)string textWidth:(CGFloat)width andFont:(CGFloat)fontSize;
+(NSString *)removeLastOneChar:(NSString*)origin;

/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;

/**
 实名有效性
 */
- (BOOL)isValidRealName;
/**
 银行卡有效性
 */
- (BOOL)wl_bankCardluhmCheck;
/**
身份证有效性
 */
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

//因为各个运营商开头号码不同，这里只匹配11位是比较好的方法
- (BOOL)isValidPhoneNumber;
//根据运营商进行号码判断
- (BOOL)isValidPhoneNumber2;
- (BOOL)isEmailAddress;

//判断是否有空格
-(BOOL)isHaveEmptyString;

/**
 昵称判断
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithChEngMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth;

- (BOOL)isHongKongID;
- (BOOL)isMacaoID;

/*
 判断中英混合字符串的长度
 **/
- (BOOL)isValidLengthWithCNandEN:(NSString *)str;

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;

//修改行间距
+ (NSMutableAttributedString *)setlineGapWith:(NSString *)str;

//设置文字左右对齐
+ (NSMutableAttributedString *)settextAlimentRightAndLeft:(NSString *)str;


+(BOOL)isValidIDCard2WIth:(NSString *)userID;

//Unix时间戳转时间
+(NSDate *)timeConvert:(NSString *)dataString;

//Unix时间戳转时间 精确到毫秒
+ (NSDate *)getDateTimeFromMilliSeconds:(long long)miliSeconds;

//将NSDate类型的时间转换为时间戳,从1970/1/1开始
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

/**
 *  返回16位大小写字母和数字
 *
 *  @return 字符串
 */
- (NSString *)return16LetterAndNumber;


@end
