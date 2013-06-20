//
//  BaseCell.h
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAdapterContent.h"

@interface BaseCell : UITableViewCell

+(CGFloat)heightOfCell;

+(CGFloat)heightOfCell:(BaseAdapterContent*)content;

- (void)layoutCustomSubViews;

- (void)layoutCustomSubViews:(BaseAdapterContent*)content;

- (void)setContent:(BaseAdapterContent*)content;

@end
