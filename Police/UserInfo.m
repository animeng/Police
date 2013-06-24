//
//  UserInfo.m
//  youyou
//
//  Created by wang animeng on 12-10-21.
//  Copyright (c) 2012年 youyou. All rights reserved.
//

#import "UserInfo.h"

@interface UserInfo()

@property (nonatomic,strong) NSUserDefaults *userDefaults;

@end

@implementation UserInfo

@synthesize tid = _tid;

@synthesize status = _status;

@synthesize carLat = _carLat;

@synthesize carLng = _carLng;

@synthesize pushToken = _pushToken;

+ (UserInfo*)shareUserInfo
{
    static UserInfo *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UserInfo alloc] init];
        _sharedClient.userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return _sharedClient;
}

- (void)setTid:(NSString *)tid
{
    _tid = tid;
    if (tid) {
        [self.userDefaults setObject:tid forKey:@"tid"];
    }
    else{
        [self.userDefaults removeObjectForKey:@"tid"];
    }
    [self.userDefaults synchronize];
}

- (NSString*)tid
{
    if ([self.userDefaults objectForKey:@"tid"]) {
        return [self.userDefaults objectForKey:@"tid"];
    }
    return nil;
}

- (void)setPushToken:(NSString *)pushToken
{
    _pushToken = pushToken;
    if (pushToken) {
        [self.userDefaults setObject:pushToken forKey:@"pushToken"];
    }
    else{
        [self.userDefaults removeObjectForKey:@"pushToken"];
    }
    [self.userDefaults synchronize];
}

- (NSString*)pushToken
{
    if ([self.userDefaults objectForKey:@"pushToken"]) {
        return [self.userDefaults objectForKey:@"pushToken"];
    }
    return @"";
}

- (void)setCarLat:(NSNumber *)carLat
{
    _carLat = carLat;
    if (carLat) {
        [self.userDefaults setObject:carLat forKey:@"carLat"];
    }
    else{
        [self.userDefaults removeObjectForKey:@"carLat"];
    }
}

- (NSNumber*)carLat
{
    if (!_carLat) {
        _carLat = [self.userDefaults objectForKey:@"carLat"];
    }
    return _carLat;
}

- (void)setCarLng:(NSNumber *)carLng
{
    _carLng = carLng;
    if (carLng) {
        [self.userDefaults setObject:carLng forKey:@"carLng"];
    }
    else{
        [self.userDefaults removeObjectForKey:@"carLng"];
    }
}

- (NSNumber*)carLng
{
    if (!_carLng) {
        _carLng = [self.userDefaults objectForKey:@"carLng"];
    }
    return _carLng;
}


- (NSString*)type
{
    return @"iphone";
}

- (void)setStatus:(NSNumber *)status
{
    _status = status;
    if (status) {
        [self.userDefaults setObject:status forKey:@"status"];
    }
    [self.userDefaults synchronize];
}

- (NSNumber*)status
{
    if ([self.userDefaults objectForKey:@"status"]) {
        return [self.userDefaults objectForKey:@"status"];
    }
    return [NSNumber numberWithBool:FALSE];
}

- (NSString*)version
{
    NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return currentBundleVersion;
}


@end
