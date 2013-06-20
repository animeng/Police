//
//  BaseCell.m
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell()

@property (nonatomic,strong) BaseAdapterContent *adapterContent;

@end

@implementation BaseCell

+(CGFloat)heightOfCell
{
    return 200;
}

+(CGFloat)heightOfCell:(BaseAdapterContent*)content
{
    return 200;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setContent:(BaseAdapterContent*)content
{
    self.adapterContent = content;
    if (self.adapterContent) {
        [self layoutCustomSubViews:self.adapterContent];
    }
    else{
        [self layoutCustomSubViews];
    }
}

- (void)layoutCustomSubViews
{
    
}

- (void)layoutCustomSubViews:(BaseAdapterContent*)content
{
    
}

@end
