//
//  JMBasicAction.m
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMBasicAction.h"
#import "JMClient.h"
#import "URLDefine.h"
#import "MBProgressHUD.h"
#import "UtilityWidget.h"

extern NSArray * AFQueryStringPairsFromDictionary(NSDictionary *dictionary);
@class AFQueryStringPair;

@interface JMBasicAction()

@property (nonatomic,retain) JMClient *client;

@end

@implementation JMBasicAction

- (id)init
{
    self = [super init];
    if (self) {
        self.client = [JMClient shareClient];
        [self.client SetAcceptJsonDictionary];
        self.parameter = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)checkNetStatus
{
    if (self.client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (KeyWindow) {
            [UtilityWidget showNetLoadCompleteStatusBar:@"亲！你网络有问题"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - http action

- (void)getRequestDictionaryResult:(SuccessInfo)info error:(ErrorInfo)errorInfo
{
    if (![self checkNetStatus]) {
        return;
    }
    JMDINFO(@"get request:%@/%@ para:%@",self.client.baseURL,self.basicPath,self.parameter);
    [self.client getPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            info((NSDictionary*)responseObject);
            JMDINFO(@"%@",responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
            JMDINFO(@"%@",error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorInfo(error);
        JMDINFO(@"%@",error);
    }];
}

- (void)postRequestDictionaryResult:(SuccessInfo)info error:(ErrorInfo)errorInfo
{
    if (![self checkNetStatus]) {
        return;
    }
    JMDINFO(@"post request:%@/%@ para:%@",self.client.baseURL,self.basicPath,self.parameter);
    
    [self.client postPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            info((NSDictionary*)responseObject);
            JMDINFO(@"%@",responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
            JMDINFO(@"%@",error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorInfo(error);
        JMDINFO(@"%@",error);
    }];
}

#pragma mark - subclass implementation 

- (void)getRequestListResult:(SuccessAryInfo)info error:(ErrorInfo)errorInfo
{
    if (![self checkNetStatus]) {
        return;
    }
    JMDINFO(@"get request:%@/%@ para:%@",self.client.baseURL,self.basicPath,self.parameter);
    [self.client getPath:self.basicPath parameters:self.parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            info((NSArray*)responseObject);
            JMDINFO(@"%@",responseObject);
        }
        else{
            NSError *error = [NSError errorWithDomain:errorDescription[ErrorParseJson]
                                                 code:ErrorParseJson userInfo:nil];
            errorInfo(error);
            JMDINFO(@"%@",error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorInfo(error);
        JMDINFO(@"%@",error);
    }];
}

- (void)dealloc
{
    JMDINFO(@"release%@",self);
}

@end
