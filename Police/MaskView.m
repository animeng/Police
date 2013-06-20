//
//  MaskView.m
//  Yichu
//
//  Created by wang animeng on 12-9-25.
//  Copyright (c) 2012年 iphonele. All rights reserved.
//

#import "MaskView.h"

@interface MaskView()
@property (nonatomic,strong) UIButton * iKnowBtn;
@end

@implementation MaskView

+(void)showMaskInView:(UIView*)view backgroundColor:(UIColor*)color removeMask:(RemoveBlock)block
{
    if ([view viewWithTag:GuidViewTag]) {
        return;
    }
    MaskView *mask = [[MaskView alloc] initWithFrame:view.bounds];
    mask.backgroundColor = color;
    mask.removeMaskBlock = block;
    mask.tag = GuidViewTag;
    [view addSubview:mask];
}

+(void)showMaskInView:(UIView*)view backgroundColor:(UIColor*)color iKnowBtn:(UIButton*)btn removeMask:(RemoveBlock)block
{
    if ([view viewWithTag:GuidViewTag]) {
        return;
    }
    MaskView *mask = [[MaskView alloc] initWithFrame:view.bounds];
    mask.backgroundColor = color;
    mask.removeMaskBlock = block;
    mask.iKnowBtn = btn;
    mask.tag = GuidViewTag;
    [view addSubview:mask];
    [mask addSubview:btn];
}

+(void)showMaskInView:(UIView*)view backgroundColor:(UIColor*)color size:(CGSize)size removeMask:(RemoveBlock)block
{
    if ([view viewWithTag:GuidViewTag]) {
        return;
    }
    MaskView *mask = [[MaskView alloc] initWithFrame:view.bounds];
    mask.size = size;
    mask.backgroundColor = color;
    mask.removeMaskBlock = block;
    mask.tag = GuidViewTag;
    [view addSubview:mask];
}

+ (void)removeMaskInView:(UIView*)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[MaskView class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.iKnowBtn) {
        return;
    }
    if (self.removeMaskBlock) {
        self.removeMaskBlock();
    }
    [self removeFromSuperview];
}
@end
