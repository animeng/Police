//
//  RTAppDelegate.h
//  Police
//
//  Created by wang animeng on 13-5-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "RTFirstViewController.h"

@interface RTAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RTFirstViewController *viewController;

@property (strong,nonatomic) BMKMapManager* mapManager;

@property (nonatomic,strong) CLLocationManager * locationManager;

@end
