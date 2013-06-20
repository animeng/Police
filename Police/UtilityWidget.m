//
//  UtilityWidget.m
//  Yichu
//
//  Created by wang animeng on 12-9-7.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import "UtilityWidget.h"
#import "UIView+AnimationAddition.h"

@interface UtilityWidget()<UIAlertViewDelegate>

@end

@implementation UtilityWidget

+ (void)showNetLoadingStatusBar:(NSString*)title
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWindow = [ windows objectAtIndex:0];
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIView *view = [mainWindow viewWithTag:NetLoadingStatusBarTag];
    if (view) {
        return;
    }
    
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBar.backgroundColor = [UIColor blackColor];
    statusBar.opaque = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 290, 20)];
    label.backgroundColor = [UIColor blackColor];
    label.opaque = NO;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(28, 8, 4, 4)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicatorView startAnimating];
    
    [statusBar addSubview:indicatorView];
    [statusBar addSubview:label];
    statusBar.tag = NetLoadingStatusBarTag;
    
    [mainWindow addSubview:statusBar];
    
    JMDINFO(@"add %@",statusBar);
    [statusBar release];
    [label release];
    [indicatorView release];
    
}

+ (void)showNetLoadCompleteStatusBar:(NSString*)title
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWindow = [ windows objectAtIndex:0];
    UIView *view = [mainWindow viewWithTag:NetLoadingStatusBarTag];
    if (view) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        for (UIView *subView in [view subviews]) {
            if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
                UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView*)subView;
                [indicatorView stopAnimating];
            }
            else if([subView isKindOfClass:[UILabel class]]){
                UILabel *label = (UILabel*)subView;
                label.text = title;
            }
        }
    }
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UtilityWidget removeNetLoadingStatusBar];
    });
}

+(void)removeNetLoadingStatusBar
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWindow = [ windows objectAtIndex:0];
    UIView *view = [mainWindow viewWithTag:NetLoadingStatusBarTag];
    [view removeFromSuperview];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

+ (void)showPromptViewInBottom:(UIView*)subView delayRemove:(CGFloat)time complete:(void (^)(void))complete
{
    //UIAlart调用的时候，如果使用keywindow，keywindow会改变的。
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWindow = [ windows objectAtIndex:0];
    
    subView.bottom = mainWindow.bottom;
    [subView addAnimationFromPosition:CGPointMake(subView.centerX, subView.bottom+subView.height/2) toPoint:subView.center];
    [mainWindow addSubview:subView];
    int64_t delayInSeconds = time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.25 animations:^{
            subView.transform = CGAffineTransformMakeTranslation(0, subView.height);
        } completion:^(BOOL finished) {
            [subView removeFromSuperview];
            complete();
        }];
    });
}

+ (void)removePromptViewInBottom
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    UIWindow *mainWindow = [ windows objectAtIndex:0];
    UIView *promptView = [mainWindow viewWithTag:PromptViewTag];
    if (promptView) {
        [UIView animateWithDuration:0.25 animations:^{
            promptView.transform = CGAffineTransformMakeTranslation(0, promptView.height);
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }
}

#pragma mark - alertView

+(void)showAlertComplete:(CompletBlock)complete withTitle:(NSString*)title message:(NSString*)message buttonTiles:(NSString *)otherButtonTitles, ...
{
    UtilityWidget * widget = [[UtilityWidget alloc] init];
    widget.completeBlock = complete;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:widget
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:otherButtonTitles,nil];
    [alert show];
}

+(void)showAlertComplete:(CompletBlock)complete withTitle:(NSString*)title message:(NSString*)message
{
    UtilityWidget * widget = [[UtilityWidget alloc] init];
    widget.completeBlock = complete;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:widget
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completeBlock) {
        self.completeBlock(buttonIndex);
        [self release];
    }
}

@end
