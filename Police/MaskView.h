//
//  MaskView.h
//  Yichu
//
//  Created by wang animeng on 12-9-25.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RemoveBlock)(void);
@interface MaskView : UIView

+(void)showMaskInView:(UIView*)view backgroundColor:(UIColor*)color removeMask:(RemoveBlock)block;

+(void)showMaskInView:(UIView*)view backgroundColor:(UIColor*)color iKnowBtn:(UIButton*)btn removeMask:(RemoveBlock)block;

+(void)showMaskInView:(UIView*)view backgroundColor:(UIColor*)color size:(CGSize)size removeMask:(RemoveBlock)block;

+ (void)removeMaskInView:(UIView*)view;

@property (nonatomic,copy) RemoveBlock removeMaskBlock;

@end
