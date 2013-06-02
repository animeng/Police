//
//  JMClient.m
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMClient.h"
#import "AFJSONRequestOperation.h"
#import "URLDefine.h"

@implementation JMClient

+ (JMClient *)shareClient
{
    static JMClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JMClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
    });
    return _sharedClient;
}

#pragma mark - request accept type

- (void)setAcceptTextContent
{
    [self unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/text"];
}

- (void)SetAcceptJsonDictionary
{
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
}

- (void)setAcceptDataFile
{
    [self unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"*/*"];
}

@end
