//
//  UtilityWidget.h
//  Yichu
//
//  Created by wang animeng on 12-9-7.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletBlock)(NSInteger buttonIndex);

@interface UtilityWidget : NSObject

@property (nonatomic,copy) CompletBlock completeBlock;

+ (void)showNetLoadingStatusBar:(NSString*)title;
+ (void)showNetLoadCompleteStatusBar:(NSString*)title;
+(void)removeNetLoadingStatusBar;

+(void)showAlertComplete:(CompletBlock)complete withTitle:(NSString*)title message:(NSString*)message buttonTiles:(NSString *)otherButtonTitles, ...;

+ (void)showPromptViewInBottom:(UIView*)subView delayRemove:(CGFloat)time complete:(void (^)(void))complete;
+ (void)removePromptViewInBottom;

@end
