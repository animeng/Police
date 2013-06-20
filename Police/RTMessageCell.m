//
//  RTMessageCell.m
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTMessageCell.h"
#import "RTMessageAdapter.h"

#define WidthAddressText 210

#define WidthMessageText 210

#define WidthDistanceText 50

@interface RTMessageCell()

@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *messageLabel;

@property (nonatomic,strong) UILabel *distanceLabel;

@property (nonatomic,strong) UIImageView * textBackgroundView;

@end

@implementation RTMessageCell

+(CGFloat)heightOfCell:(RTMessageAdapter *)content
{
    CGFloat addressHeight = [content.addressText heightWithFont:[UIFont systemFontOfSize:16] withLineWidth:WidthAddressText];
    CGFloat messageHeight = [content.messageText heightWithFont:[UIFont systemFontOfSize:14] withLineWidth:WidthMessageText];
    return addressHeight + messageHeight + 20 + 30;
}

-(void)layoutCustomSubViews:(RTMessageAdapter*)content
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    CGFloat addressHeight = [content.addressText heightWithFont:[UIFont systemFontOfSize:16] withLineWidth:WidthAddressText];
    CGFloat messageHeight = [content.messageText heightWithFont:[UIFont systemFontOfSize:14] withLineWidth:WidthMessageText];
    
    if (!self.textBackgroundView) {
        self.textBackgroundView = [[UIImageView alloc] init];
    }
    self.textBackgroundView.image = [[UIImage imageNamed:@"notice_bubble"] stretchableImageWithLeftCapWidth:140 topCapHeight:35];
    self.textBackgroundView.frame = CGRectMake(10, 10, 286, addressHeight+messageHeight+20);
    
    if (!self.addressLabel) {
        self.addressLabel = [[UILabel alloc] init];
    }
    self.addressLabel.frame = CGRectMake(28, 20, WidthAddressText, addressHeight);
    self.addressLabel.backgroundColor = [UIColor clearColor];
    self.addressLabel.font = [UIFont systemFontOfSize:16 ];
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.text = content.addressText;
    
    if (!self.messageLabel) {
        self.messageLabel = [[UILabel alloc] init];
    }
    self.messageLabel.frame = CGRectMake(28, 20 + addressHeight + 5, WidthMessageText, messageHeight);
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.text = content.messageText;
    
    if (!self.distanceLabel) {
        self.distanceLabel = [[UILabel alloc] init];
    }
    self.distanceLabel.frame = CGRectMake(250, 20 + addressHeight + 5, WidthDistanceText, 20);
    self.distanceLabel.backgroundColor = [UIColor clearColor];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.textColor = [UIColor redColor];
    self.distanceLabel.numberOfLines = 0;
    self.distanceLabel.text = content.distanceText;
    
    if (![self.textBackgroundView superview]) {
        [self.contentView addSubview:self.textBackgroundView];
    }
    if (![self.messageLabel superview]) {
        [self.contentView addSubview:self.messageLabel];
    }
    if (![self.addressLabel superview]) {
        [self.contentView addSubview:self.addressLabel];
    }
    if (![self.distanceLabel superview]) {
        [self.contentView addSubview:self.distanceLabel];
    }
}

@end
