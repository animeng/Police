//
//  NSString+Addition.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-8.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth;

- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth;

@end
