//
//  JMBasicAction.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessInfo)(NSDictionary *result);
typedef void (^SuccessAryInfo)(NSArray *result);
typedef void(^ErrorInfo)(NSError *error);


@interface JMBasicAction : NSObject

@property (nonatomic,strong) NSString *basicPath;
@property (nonatomic,strong) NSMutableDictionary *parameter;
@property (nonatomic,assign) NSInteger currentPage;

- (void)getRequestDictionaryResult:(SuccessInfo)info error:(ErrorInfo)errorInfo;
- (void)postRequestDictionaryResult:(SuccessInfo)info error:(ErrorInfo)errorInfo;
- (void)getRequestListResult:(SuccessAryInfo)info error:(ErrorInfo)errorInfo;

@end
