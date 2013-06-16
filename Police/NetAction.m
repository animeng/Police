//
//  NetAction.m
//  Police
//
//  Created by wang animeng on 13-5-22.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "NetAction.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"
#import "UtilityWidget.h"

@implementation NetAction

+ (void) initPort:(void (^)(NSDictionary *result))info
{
    JMBasicAction *action = [[JMBasicAction alloc] init];
    action.basicPath = @"init";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"" forKey:@"tid"];
    if ([UserInfo shareUserInfo].pushToken) {
        [para setObject:[UserInfo shareUserInfo].pushToken forKey:@"pushToken"];
    }
    if ([UserInfo shareUserInfo].version) {
        [para setObject:[UserInfo shareUserInfo].version forKey:@"version"];
    }
    if ([UserInfo shareUserInfo].type) {
        [para setObject:[UserInfo shareUserInfo].type forKey:@"type"];
    }
    action.parameter = para;
    [action getRequestDictionaryResult:^(NSDictionary *result) {
        NSString *tid = [result objectForKey:@"tid"];
        [UserInfo shareUserInfo].tid = tid;
        info(result);
        
    } error:^(NSError *error) {
        
    }];
}

+ (void) logon:(void (^)(NSDictionary *result))info
{
    JMBasicAction *action = [[JMBasicAction alloc] init];
    action.basicPath = @"logon";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    NSDictionary *para = @{@"tid": [UserInfo shareUserInfo].tid,@"pushToken":@"afdfdfd",@"version":@"1.0"};
    if ([UserInfo shareUserInfo].tid) {
        [para setObject:[UserInfo shareUserInfo].tid forKey:@"tid"];
    }
    if ([UserInfo shareUserInfo].version) {
        [para setObject:[UserInfo shareUserInfo].version forKey:@"version"];
    }
    if ([UserInfo shareUserInfo].pushToken) {
        [para setObject:[UserInfo shareUserInfo].pushToken forKey:@"pushToken"];
    }
    action.parameter = para;
    [action getRequestDictionaryResult:^(NSDictionary *result) {
        info(result);
        
    } error:^(NSError *error) {
        
    }];
}

+ (void)sendMessage:(void (^)(NSDictionary *reuslt))info
{
    JMBasicAction *action = [[JMBasicAction alloc] init];
    action.basicPath = @"sendMessage";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    NSDictionary *para = @{@"tid": [UserInfo shareUserInfo].tid,@"message":@"afdfdfd",@"lat":@"30.0",@"lng":@"120.0"};
    if ([UserInfo shareUserInfo].tid) {
        [para setObject:[UserInfo shareUserInfo].tid forKey:@"tid"];
    }
    if ([UserInfo shareUserInfo].message) {
        [para setObject:[UserInfo shareUserInfo].message forKey:@"message"];
    }
    if ([UserInfo shareUserInfo].carLat) {
        [para setObject:[NSNumber numberWithDouble:[UserInfo shareUserInfo].policeCoordinate2D.latitude] forKey:@"lat"];
    }
    if ([UserInfo shareUserInfo].carLng) {
        [para setObject:[NSNumber numberWithDouble:[UserInfo shareUserInfo].policeCoordinate2D.longitude] forKey:@"lng"];
    }
    action.parameter = para;
    [action getRequestDictionaryResult:^(NSDictionary *result) {
        info(result);
        
    } error:^(NSError *error) {
        
    }];
}

+ (void)getMessage:(void (^)(NSArray *reuslt))info
{
    JMBasicAction *action = [[JMBasicAction alloc] init];
    action.basicPath = @"getMessage";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    NSDictionary *para = @{@"tid": [UserInfo shareUserInfo].tid,@"message":@"afdfdfd",@"lat1":@"30.0",@"lng1":@"120.0",@"lat2":@"29.0",@"lng2":@"121.0"};
    if ([UserInfo shareUserInfo].tid) {
        [para setObject:[UserInfo shareUserInfo].tid forKey:@"tid"];
    }
    if ([UserInfo shareUserInfo].mapTopLeftLat) {
        [para setObject:[UserInfo shareUserInfo].mapTopLeftLat forKey:@"lat1"];
    }
    if ([UserInfo shareUserInfo].mapTopLeftLng) {
        [para setObject:[UserInfo shareUserInfo].mapTopLeftLng forKey:@"lng1"];
    }
    if ([UserInfo shareUserInfo].mapBottomRightLat) {
        [para setObject:[UserInfo shareUserInfo].mapBottomRightLat forKey:@"lat2"];
    }
    if ([UserInfo shareUserInfo].mapBottomRightLng) {
        [para setObject:[UserInfo shareUserInfo].mapBottomRightLng forKey:@"lng2"];
    }
    action.parameter = para;
    [action getRequestDictionaryResult:^(NSDictionary *result) {
        if ([result objectForKey:@"messages"]) {
            info([result objectForKey:@"messages"]);
        }
        
    } error:^(NSError *error) {
        
    }];
}

+ (void)changeStatus:(void (^)(NSDictionary *reuslt))info status:(NSString*)status
{
    JMBasicAction *action = [[JMBasicAction alloc] init];
    action.basicPath = @"changeStatus";
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if ([UserInfo shareUserInfo].tid) {
        [para setObject:[UserInfo shareUserInfo].tid forKey:@"tid"];
    }
    if (status) {
        [para setObject:status forKey:@"status"];
    }
    if ([UserInfo shareUserInfo].carLat) {
        [para setObject:[UserInfo shareUserInfo].carLat forKey:@"lat"];
    }
    if ([UserInfo shareUserInfo].carLng) {
        [para setObject:[UserInfo shareUserInfo].carLng forKey:@"lng"];
    }
    action.parameter = para;
    [action getRequestDictionaryResult:^(NSDictionary *result) {
        [UserInfo shareUserInfo].status = [result objectForKey:@"status"];
        info(result);
        
    } error:^(NSError *error) {
        if (!hasOpenLadar) {
            [UtilityWidget showNetLoadCompleteStatusBar:@"开启雷达失败"];
        }
        else{
            [UtilityWidget showNetLoadCompleteStatusBar:@"关闭雷达失败"];

        }
    }];
}

@end
