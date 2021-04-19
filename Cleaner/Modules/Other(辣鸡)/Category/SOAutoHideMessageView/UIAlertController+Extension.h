//
//  UIAlertController+Extension.h
//  MyShoppingApp
//
//  Created by ibokan on 16/1/11.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

/**
 *  提示框,两个按钮
 *
 *  @param title          标题
 *  @param message        内容
 *  @param checkBlock     确定的回调
 */
+(void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message checkBlock:(void (^)())checkBlock;

//只有确定按钮
+(void )UpdateAlertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString*)sureBtnTitle checkBlock:(void (^)())checkBlock;


/**
 *  底部弹出提示框,三按钮
 *
 *  @param title          标题
 *  @param message        内容
 *  @param firstTitle       第一个按钮标题
 *  @param firstBlock       第一个按钮回调
 *  @param secondTitle      第二个按钮标题
 *  @param secondBlock      第二个按钮回调
 *
 */
+ (void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message firstTitle:(NSString *)firstTitle andHander:(void (^)())firstBlock secondTitle:(NSString *)secondTitle andHander:(void (^)())secondBlock;

/**
 *  创建一个警告的提示框，不自动消失，点确定后消失
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *
 */
+(void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message;

/**
 *  提示框一段时间后自动消失
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *  @param timeInterval   何时消失
 *
 */
+(void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message dimissAfter:(NSTimeInterval)timeInterval;

/**
 *  弹出输入框
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *  @param placeholder    输入框提示语
 *  @param cancelBlock    取消按钮回调block
 *  @param checkBlock     确认按钮回调block
 *
 */
+ (void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder contentText:(NSString *)contentText cancelBlock:(void (^)())cancelBlock checkBlock:(void (^)(NSString * inputText))checkBlock;
@end
