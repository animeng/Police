//
//  AdapterListContent.m
//  Police
//
//  Created by wang animeng on 13-6-16.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "BaseAdapterContent.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation BaseAdapterContent

//+ (BOOL) object : (id) object
//	hasProperty : (NSString *) propertyName
//{
//	BOOL foundProperty = NO;
//	if (object != nil) {
//		foundProperty = class_getProperty([object class], [propertyName UTF8String]) != NULL;
//	}
//	return foundProperty;
//}
//
//+ (id)createAdapterWithInfo:(NSDictionary*)info
//{
//    Class objectClass = [self class];
//    id objectInstance = [[objectClass alloc] init];
//    NSArray *keys = [info allKeys];
//    id key;
//    id value;
//    int i;
//    for (i = 0; i < [keys count]; i++)
//    {
//        key = [keys objectAtIndex: i];
//        value = [info objectForKey: key];
//        if ([BaseAdapterContent object:objectInstance hasProperty:key] && ![value isKindOfClass:[NSNull class]]) {
//            [objectInstance setValue: value
//                              forKey: key];
//        }
//    }
//    return objectInstance;
//}
//
- (NSString*)description
{
    unsigned int outCount, i;
    NSString * allPropertyValue = [NSString stringWithFormat:@"%@:",NSStringFromClass([self class])];
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            allPropertyValue = [NSString stringWithFormat:@"%@\n%s:%@",allPropertyValue,propName,[self valueForKey:[NSString stringWithFormat:@"%s",propName]]];
        }
    }
    return allPropertyValue;
}

@end
