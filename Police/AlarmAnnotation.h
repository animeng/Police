//
//  AlarmAnnotation.h
//  Police
//
//  Created by wang animeng on 13-6-5.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKShape.h"

@interface AlarmAnnotation : BMKShape{
    CLLocationCoordinate2D _coordinate;
}
///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
