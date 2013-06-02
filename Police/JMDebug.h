//
//  JMDebug.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-3.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#ifndef SaleHouse_JMDebug_h
#define SaleHouse_JMDebug_h


#define JMLOGLEVEL_INFO     10
#define JMLOGLEVEL_WARNING  3
#define JMLOGLEVEL_ERROR    1

#ifndef JMMAXLOGLEVEL

#ifdef DEBUG
//指定 JMMAXLOGLEVEL 用来设置debug的等级
//1 JMLOGLEVEL_INFO 是打印所有的信息
//2 JMLOGLEVEL_WARNING 只打印警告和错误的信息
//3 JMLOGLEVEL_ERROR 只打印错误的信息
//4 如果设置为0，只打印debug的信息
#define JMMAXLOGLEVEL JMLOGLEVEL_INFO
#define JMDEBUG
#else
#define JMMAXLOGLEVEL JMLOGLEVEL_ERROR
#endif

#endif

// 这个忽略调试的等级
#ifdef JMDEBUG
#define JMDEBUGPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define JMDEBUGPRINT(xx, ...)  ((void)0)
#endif

// 打印当前方法名
#define JMDPRINTMETHODNAME() JMDEBUGPRINT(@"%s", __PRETTY_FUNCTION__)

// 调试的等级
#if JMLOGLEVEL_ERROR <= JMMAXLOGLEVEL
#define JMDERROR(xx, ...)  JMDEBUGPRINT(xx, ##__VA_ARGS__)
#else
#define JMDERROR(xx, ...)  ((void)0)
#endif

#if JMLOGLEVEL_WARNING <= JMMAXLOGLEVEL
#define JMDWARNING(xx, ...)  JMDEBUGPRINT(xx, ##__VA_ARGS__)
#else
#define JMDWARNING(xx, ...)  ((void)0)
#endif

#if JMLOGLEVEL_INFO <= JMMAXLOGLEVEL
#define JMDINFO(xx, ...)  JMDEBUGPRINT(xx, ##__VA_ARGS__)
#else
#define JMDINFO(xx, ...)  ((void)0)
#endif

#ifdef JMDEBUG
#define JMDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
JMDEBUGPRINT(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define JMDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif


#endif
