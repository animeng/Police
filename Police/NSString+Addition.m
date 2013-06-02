//
//  NSString+Addition.m
//  SaleHouse
//
//  Created by wang animeng on 13-4-8.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth{
    
    CGFloat fontHeight = font.ascender - font.descender + 1;
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:UILineBreakModeTailTruncation];
	NSInteger lines = size.height / fontHeight;
	return lines;
}
- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:UILineBreakModeTailTruncation];
	return size.height;
	
}

- (CGFloat)widthWithFont:(UIFont*)font{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                       lineBreakMode:UILineBreakModeTailTruncation];
	return size.width;
	
}

@end
