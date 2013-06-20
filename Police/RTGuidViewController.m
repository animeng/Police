//
//  RTGuidViewController.m
//  Police
//
//  Created by wang animeng on 13-6-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTGuidViewController.h"

@interface RTGuidViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *upImageView;

@property (strong, nonatomic) IBOutlet UIImageView *downImageView;
@end

@implementation RTGuidViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setUpImageView:nil];
    [self setDownImageView:nil];
    [super viewDidUnload];
}

- (IBAction)openLadar:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.upImageView.bottom = 0;
        self.downImageView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
@end
