//
//  RTAppDelegate.h
//  Police
//
//  Created by wang animeng on 13-5-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface RTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong,nonatomic) BMKMapManager* mapManager;

@end
