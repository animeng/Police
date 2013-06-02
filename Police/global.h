//
//  global.h
//  Police
//
//  Created by wang animeng on 13-5-22.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#ifndef Police_global_h
#define Police_global_h

#import "UIView+GeometryAddition.h"
#import "UIView+AnimationAddition.h"
#import "NSString+Addition.h"
#import "JMDebug.h"
#import "RTAppDelegate.h"
#import "URLDefine.h"
#import "BMapKit.h"

#define baiduMapKey @"35CE9CDF800CDF58D017F3D53EEA460A2358FE5C"

//method macro
#define APPDelegate [(RTAppDelegate *)[UIApplication sharedApplication].delegate

#define KeyWindow [UIApplication sharedApplication].keyWindow

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define COLORALPHA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]

#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#endif
