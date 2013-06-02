//
//  RTAppDelegate.m
//  Police
//
//  Created by wang animeng on 13-5-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTAppDelegate.h"

#import "RTFirstViewController.h"

#import "RTSecondViewController.h"

#import "NetAction.h"

#import "UserInfo.h"

@implementation RTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
	self.mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [self.mapManager start:baiduMapKey generalDelegate:nil];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *viewController1 = [[RTFirstViewController alloc] initWithNibName:@"RTFirstViewController" bundle:nil];
    UIViewController *viewController2 = [[RTSecondViewController alloc] initWithNibName:@"RTSecondViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

#pragma mark - romate notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	JMDINFO(@"My token is: %@", deviceToken);
    NSString *token =   [[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                         stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *myToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (myToken) {
        [UserInfo shareUserInfo].pushToken = myToken;
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	JMDINFO(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    JMDINFO(@"didReceiveRemoteNotification");
    application.applicationIconBadgeNumber = 0;
    NSDictionary * remoteNotification = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    if ([remoteNotification objectForKey:@"ticketId"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜你"
                                                        message:@"你有新的奖券"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"查看",nil];
        [alert show];
    }
}

@end
