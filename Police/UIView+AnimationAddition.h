//
//  UIView+AnimationAddition.h
//  Yichu
//
//  Created by wang animeng on 12-9-11.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (AnimationAddition)

//给视图的加入动画层。
- (void)addTransitionAnimationWithType:(NSString *)type
                               subtype:(NSString *)subtype
                              delegate:(id)delegate;

- (void)addAnimationFromPosition:(CGPoint)startP toPoint:(CGPoint)endP;
- (void)addAnimationFromScale:(CGFloat)startScale toScale:(CGFloat)endScale;
- (void)addAnimationRotationAngle:(CGFloat)angle;
- (void)addAnimationFadeFromValue:(CGFloat)start toValue:(CGFloat)end;

+ (CAAnimation*)animationRotationAngle:(CGFloat)angle;
+ (CAAnimation *)animationFromPosition:(CGPoint)startP toPoint:(CGPoint)endP;
+ (CAAnimation*)animationFromScale:(CGFloat)startScale toScale:(CGFloat)endScale;
+ (CAAnimation *)animationFadeFromValue:(CGFloat)start toValue:(CGFloat)end;

@end
