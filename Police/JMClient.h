//
//  JMClient.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "AFHTTPClient.h"

@interface JMClient : AFHTTPClient

+ (JMClient *)shareClient;

- (void)setAcceptTextContent;
- (void)SetAcceptJsonDictionary;
- (void)setAcceptDataFile;

@end
