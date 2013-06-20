//
//  RTAppDelegate.m
//  Police
//
//  Created by wang animeng on 13-5-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTAppDelegate.h"

#import "RTFirstViewController.h"

#import "NetAction.h"
#import "UtilityWidget.h"
#import "UserInfo.h"


@implementation RTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
	self.mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [self.mapManager start:baiduMapKey generalDelegate:nil];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RTFirstViewController *viewController1 = [[RTFirstViewController alloc] initWithNibName:@"RTFirstViewController" bundle:nil];
    self.viewController = viewController1;
    
    if (![UserInfo shareUserInfo].tid) {
        self.viewController.hasGuidView = YES;
    }
    else{
        [self.viewController setHasGuidView:YES];
    }
    
    self.window.rootViewController = viewController1;
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
    if ([UserInfo shareUserInfo].tid) {
        [NetAction logon:^(NSDictionary *result) {
            NSString *updateKey = [result objectForKey:@"update"];
            if (![updateKey isEqualToString:@"NONE"]) {
                if ([updateKey isEqualToString:@"OPTIONAL"]) {
                    [UtilityWidget showAlertComplete:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result objectForKey:@"updateUrl"]]];
                        }
                    } withTitle:@"温馨提示" message:@"你有新版本更新！" buttonTiles:@"确定"];
                }
                else if([updateKey isEqualToString:@"REQUIRED"]){
                    [UtilityWidget showAlertComplete:^(NSInteger buttonIndex) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result objectForKey:@"updateUrl"]]];
                    } withTitle:@"确定" message:@"你有新版本更新！"];
                }
            }
        }];
    }
    [self.viewController locationCurrent];
    [self.viewController checkLadarStatus];
    [self.viewController checkMessageList];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

}


- (void)dealloc {
    [self.mapManager stop];
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
    if (![UserInfo shareUserInfo].tid) {
        [NetAction initPort:^(NSDictionary *result) {

        }];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	JMDINFO(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    JMDINFO(@"didReceiveRemoteNotification:%@",userInfo);
    if (KeyWindow) {
        [UtilityWidget showAlertComplete:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                CLLocationCoordinate2D coord;
                coord.latitude = [[userInfo objectForKey:@"lat"] doubleValue];
                coord.longitude = [[userInfo objectForKey:@"lng"] doubleValue];
                application.applicationIconBadgeNumber = -1;
                [self.viewController locationCoordinate2D:coord];
            }
            else{
                [self.viewController checkMessageList];
            }
        } withTitle:@"警告" message:@"条子来了！！！" buttonTiles:@"确定"];
    }
}

#pragma mark - location

- (void)locateCurPosition
{
    if(self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"地图开启" message:@"地图开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000;
        [self.locationManager startUpdatingLocation];
    }
}

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation
{
    
    if(nil==newLocation)
        return;
    if(newLocation.horizontalAccuracy>1400)
        return;
    CLLocationCoordinate2D coordinate=newLocation.coordinate;
    [manager stopUpdatingLocation];
    [UserInfo shareUserInfo].myCoordinate2D = coordinate;
}

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error
{
    
    switch (error.code) {
        case kCLErrorDenied: {
            [manager stopUpdatingLocation];
        }   break;
        default: {
            [manager stopUpdatingLocation];
        }   break;
    }
}

@end
