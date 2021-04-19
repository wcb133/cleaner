
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat const SOAutoHideMessageDefaultHideDelay;

@interface SOAutoHideMessageView : NSObject

+ (void)showMessage:(NSString *)msg inView:(UIView *)view;
+ (void)showMessage:(NSString *)msg inView:(UIView *)view positionOffset:(CGPoint)offset;
+ (void)showMessage:(NSString *)msg inView:(UIView *)view hideDelay:(NSTimeInterval)delay;
+ (void)showMessage:(NSString *)msg inView:(UIView *)view positionOffset:(CGPoint)offset hideDelay:(NSTimeInterval)delay;

@end
