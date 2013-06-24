//
//  UserInfo.h
//  youyou
//
//  Created by wang animeng on 12-10-21.
//  Copyright (c) 2012年 youyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,strong) NSString *tid;

@property (nonatomic,strong) NSString *pushToken;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSString *message;

@property (nonatomic,strong) NSString *policeLocationName;

@property (nonatomic,assign) CLLocationCoordinate2D myCoordinate2D;

@property (nonatomic,assign) CLLocationCoordinate2D policeCoordinate2D;

@property (nonatomic,strong) NSNumber *carLat;

@property (nonatomic,strong) NSNumber *carLng;

@property (nonatomic,strong) NSNumber *mapTopLeftLat;

@property (nonatomic,strong) NSNumber *mapTopLeftLng;

@property (nonatomic,strong) NSNumber *mapBottomRightLat;

@property (nonatomic,strong) NSNumber *mapBottomRightLng;

- (NSString*)version;

+ (UserInfo*)shareUserInfo;

@end
