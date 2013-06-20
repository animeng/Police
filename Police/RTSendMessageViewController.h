//
//  BaseTextViewController.h
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@protocol RTSendMessageViewDelegate <NSObject>

@optional

- (void)sendReportMessage;

- (void)cancelReportMessage;

@end

@interface RTSendMessageViewController : UIViewController

@property (nonatomic,assign) id<RTSendMessageViewDelegate> delegate;

@property (strong, nonatomic) UIView *textViewContainerView;

@property (nonatomic, strong) HPGrowingTextView *textView;

@property (nonatomic,strong) UILabel * addressLabel;

@end
