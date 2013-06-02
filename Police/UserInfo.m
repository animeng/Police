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


- (NSString*)type
{
    return @"iphone";
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    if (status) {
        [self.userDefaults setObject:status forKey:@"status"];
    }
    [self.userDefaults synchronize];
}

- (NSString*)status
{
    if ([self.userDefaults objectForKey:@"status"]) {
        return [self.userDefaults objectForKey:@"status"];
    }
    return @"false";
}

- (NSString*)version
{
    NSString *currentBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return currentBundleVersion;
}


@end
