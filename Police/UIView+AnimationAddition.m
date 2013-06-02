//
//  UIView+AnimationAddition.m
//  Yichu
//
//  Created by wang animeng on 12-9-11.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import "UIView+AnimationAddition.h"

@implementation UIView (AnimationAddition)

//给视图的加入动画层。
- (void)addTransitionAnimationWithType:(NSString *)type
                               subtype:(NSString *)subtype
                              delegate:(id)delegate
{
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.duration = 0.25;
    transition.type = type;
    transition.subtype = subtype;
    transition.delegate = delegate;
    [self.layer addAnimation:transition forKey:nil];
}

-(void)addAnimationFromPosition:(CGPoint)startP toPoint:(CGPoint)endP
{
    CAAnimation *ani = [UIView animationFromPosition:startP toPoint:endP];
    [self.layer addAnimation:ani forKey:@"myPostion"];
}

-(void)addAnimationFromScale:(CGFloat)startScale toScale:(CGFloat)endScale
{
    CAAnimation *ani = [UIView animationFromScale:startScale toScale:endScale];
    [self.layer addAnimation:ani forKey:@"myScale"];
}

- (void)addAnimationFadeFromValue:(CGFloat)start toValue:(CGFloat)end
{
    CAAnimation *ani = [UIView animationFadeFromValue:start toValue:end];
    [self.layer addAnimation:ani forKey:@"myFade"];
}

- (void)addAnimationRotationAngle:(CGFloat)angle
{
    CAAnimation *ani = [UIView animationRotationAngle:angle];
    [self.layer addAnimation:ani forKey:@"myAngle"];
}

#pragma mark - animation

+ (CAAnimation*)animationRotationAngle:(CGFloat)angle
{
    CABasicAnimation *animationRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animationRotation setFromValue:[NSNumber numberWithFloat:0]];
    [animationRotation setToValue:[NSNumber numberWithFloat:angle]];
    [animationRotation setDuration:0.25];
    [animationRotation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animationRotation;
}

+ (CAAnimation *)animationFadeFromValue:(CGFloat)start toValue:(CGFloat)end
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:start]];
    animation.toValue = [NSNumber numberWithFloat:end];
    
    [animation setDuration:0.25];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}

+ (CAAnimation*)animationFromScale:(CGFloat)startScale toScale:(CGFloat)endScale
{
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animationScale setFromValue:[NSNumber numberWithFloat:startScale]];
    [animationScale setToValue:[NSNumber numberWithFloat:endScale]];
    [animationScale setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animationScale;
}

+ (CAAnimation *)animationFromPosition:(CGPoint)startP toPoint:(CGPoint)endP
{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, startP.x, startP.y);
    CGPathAddLineToPoint(path, NULL, endP.x, endP.y);
    
    [animation setPath:path];
    [animation setDuration:0.25];
    CFRelease(path);
    
    [animation setCalculationMode:kCAAnimationLinear];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}

@end
