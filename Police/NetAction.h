//
//  NetAction.h
//  Police
//
//  Created by wang animeng on 13-5-22.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "JMBasicAction.h"

@interface NetAction : NSObject

+ (void) initPort:(void (^)(NSDictionary *result))info;

+ (void) logon:(void (^)(NSDictionary *result))info;

+ (void)sendMessage:(void (^)(NSDictionary *reuslt))info;

+ (void)getMessage:(void (^)(NSArray *reuslt))info;

+ (void)changeStatus:(void (^)(NSDictionary *reuslt))info;

@end
