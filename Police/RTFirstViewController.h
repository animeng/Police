//
//  RTFirstViewController.h
//  Police
//
//  Created by wang animeng on 13-5-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTFirstViewController : UIViewController

- (void)locationCurrent;

- (void)locationCoordinate2D:(CLLocationCoordinate2D)coord;

- (void)checkLadarStatus;

@end
