//
//  RTMessageListViewController.h
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "JMBaseListViewController.h"

@protocol RTMessageListViewControllerDelegate <NSObject>

- (void)selectMessageList:(NSInteger)index;

@end

@interface RTMessageListViewController : JMBaseListViewController

@property (nonatomic,assign) id<RTMessageListViewControllerDelegate> messageDelegate;

@end
