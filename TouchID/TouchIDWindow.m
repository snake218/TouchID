//
//  TouchIDWindow.m
//  TouchID
//
//  Created by 小二 on 16/7/20.
//  Copyright © 2016年 小二. All rights reserved.
//

#import "TouchIDWindow.h"
#import <LocalAuthentication/LAContext.h>
#import "ViewController.h"
@interface TouchIDWindow ()

@property (nonatomic, strong) UIAlertAction *confirmAction;
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) LAContext *context;

@end
@implementation TouchIDWindow
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [ViewController new];
    }
    
    return self;
}

- (void)show
{
    [self makeKeyAndVisible];
    self.hidden = NO;
    [self alertEvaluatePolicyWithTouchID];
}

- (void)dismiss
{
    [self resignKeyWindow];
    self.hidden = YES;
}
//successed,show animation
- (void)imageViewShowAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rootViewController.view.alpha = 0;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:^(BOOL finished) {
            [self.rootViewController.view removeFromSuperview];
            [self dismiss];
        }];
    });
}

- (void)alertEvaluatePolicyWithTouchID
{
    self.rootViewController = [ViewController new];
    _context = [LAContext new];
    _context.localizedFallbackTitle = @"使用手势解锁";
    NSError *error;
    if([_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        
        NSLog(@"Yeah,Support touch ID");
        
        //if return yes,whether your fingerprint correct.
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                [self imageViewShowAnimation];
            }
            else
            {
                NSLog(@"切换手势解锁");

            }
        }];
    }
    else
    {
        //        不支持指纹
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        
        NSLog(@"Sorry,The device doesn't support touch ID");
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
