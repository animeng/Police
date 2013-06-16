//
//  BaseTextViewController.h
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface BaseTextViewController : UIViewController

@property (strong, nonatomic) UIView *textViewContainerView;

@property (nonatomic, strong) HPGrowingTextView *textView;

@end
