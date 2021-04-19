//
//  UIAlertController+Extension.m
//  MyShoppingApp
//
//  Created by ibokan on 16/1/11.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)
//两个按钮,可以继续加
+(void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message checkBlock:(void (^)())checkBlock
{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //取消
    UIAlertAction *cancleBtn=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //确定
    UIAlertAction *checkBtn=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (checkBlock) {
            checkBlock();
        }
    }];
    
    [alertC addAction:cancleBtn];
    [alertC addAction:checkBtn];
    [controller presentViewController:alertC animated:YES completion:nil];
}


//只有确定按钮
+(void )UpdateAlertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message sureBtnTitle:(NSString*)sureBtnTitle checkBlock:(void (^)())checkBlock
{
    UIAlertController *alertC=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //确定
    UIAlertAction *checkBtn=[UIAlertAction actionWithTitle:sureBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (checkBlock) {
            checkBlock();
        }
    }];
    
    [alertC addAction:checkBtn];
    [controller presentViewController:alertC animated:YES completion:nil];
}


//三个按钮，弹出框
+ (void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message firstTitle:(NSString *)firstTitle andHander:(void (^)())firstBlock secondTitle:(NSString *)secondTitle andHander:(void (^)())secondBlock
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    //默认带有取消按钮
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //第一个按钮
    UIAlertAction *tow = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (firstBlock)
             firstBlock();
            }];
    //第二个按钮
    UIAlertAction *three = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondBlock)
                secondBlock();
        }];
    
    [alertC addAction:cancel];
    [alertC addAction:tow];
    [alertC addAction:three];
    [controller presentViewController:alertC animated:YES completion:nil];
}

/** 创建一个警告的提示框 */
+(void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message
{
    
    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancle = [UIAlertAction  actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
    [alertC  addAction:actionCancle];
    [controller presentViewController:alertC animated:YES completion:nil];
}

/** 提示框一段时间后消失 */
+(void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message dimissAfter:(NSTimeInterval)timeInterval
{
    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertC dismissViewControllerAnimated:YES completion:nil];
    });;
    
    [controller presentViewController:alertC animated:YES completion:nil];
}

+ (void)alertControllerShowInController:(UIViewController *)controller Title:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder contentText:(NSString *)contentText cancelBlock:(void (^)())cancelBlock checkBlock:(void (^)(NSString * inputText))checkBlock
{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
        [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = placeholder;
            textField.text = contentText;
            textField.secureTextEntry = YES;
 
        }];
    //取消
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (cancelBlock)
            cancelBlock();
    }];
    
    //确认
        UIAlertAction *check = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action ){
            UITextField *textField = alertC.textFields.firstObject;
            checkBlock(textField.text);
        }];
    
        [alertC addAction:check];
        [alertC addAction:cancel];
    [controller presentViewController:alertC animated:YES completion:nil];
}

@end
