//
//  urlDefine.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#ifndef SaleHouse_URLDefine_h
#define SaleHouse_URLDefine_h

#define APIBaseURLString @"http://tiaozilaile.com:80"

typedef enum REQUEST_ERRO
{
    ErrorParseJson,
    AllErrorType,
}RequestError;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

static NSString * errorDescription[AllErrorType]={
    @"解析json错误"
};

#pragma clang diagnostic pop

#endif
