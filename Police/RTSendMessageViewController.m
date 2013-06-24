//
//  BaseTextViewController.m
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTSendMessageViewController.h"
#import "UserInfo.h"
#import "NetAction.h"
#import "MBProgressHUD.h"

@interface RTSendMessageViewController ()<HPGrowingTextViewDelegate>

@end

@implementation RTSendMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registorNotification];
        [self setupTextView];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self unRegistorNotification];
}

#pragma mark - notification

- (void)registorNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unRegistorNotification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification *)note{
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	CGRect containerFrame = self.textViewContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	self.textViewContainerView.frame = containerFrame;
    
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	CGRect containerFrame = self.textViewContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	self.textViewContainerView.frame = containerFrame;
	
	[UIView commitAnimations];
}

#pragma mark - setup view

- (void)setupTextView
{
    self.textViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 40)];
    
    UIImage * addressIcon = [UIImage imageNamed:@"address_location_icon"];
    UIImageView *addressImageView = [[UIImageView alloc] initWithImage:addressIcon];
    addressImageView.size = addressIcon.size;
    addressImageView.left = 10;
    addressImageView.top = 5;
    
    UIImage * addressBg = [UIImage imageNamed:@"address_bg"];
    UIImageView * addressBgView = [[UIImageView alloc] initWithImage:addressBg];
    addressBgView.size = addressBg.size;
    addressBgView.bottom = 0;
    
    self.addressLabel = [[UILabel alloc] initWithFrame:addressBgView.bounds];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    self.addressLabel.left = 30;
    self.addressLabel.textColor = [UIColor whiteColor];
    self.addressLabel.font = [UIFont systemFontOfSize:13];
    [addressBgView addSubview:self.addressLabel];
    [addressBgView addSubview:addressImageView];
    [self.textViewContainerView addSubview:addressBgView];
    
	self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 238, 40)];
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.backgroundColor = [UIColor clearColor];
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 3;
	self.textView.returnKeyType = UIReturnKeySend;
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"textbox_bg"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(4, 0, 244, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"toolbar_bg"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, self.textViewContainerView.frame.size.width, self.textViewContainerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.textViewContainerView addSubview:imageView];
    [self.textViewContainerView addSubview:entryImageView];
    [self.textViewContainerView addSubview:self.textView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"cancel_button"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"cancel_button_pressed"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(self.textViewContainerView.frame.size.width - 54, 2, 50, 36);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(cancelSendText) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[self.textViewContainerView addSubview:doneBtn];
//    self.textViewContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

#pragma mark - growView delegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.textViewContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.textViewContainerView.frame = r;
}

//- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
//{
//    JMDINFO(@"%f,%f",growingTextView.internalTextView.contentOffset.x,growingTextView.internalTextView.contentOffset.y);
//    [growingTextView.internalTextView setContentOffset:CGPointMake(0, 0)];
//}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if ([growingTextView.text length] > 50) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"你输入的文字不能超过50个！";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        [self cancelSendText];
    }
    else{
        [self sendText];
    }
    return YES;
}

- (void)cancelSendText
{
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.textViewContainerView.top = APPDelegate.viewController.view.height;
    }];
    if ([self.delegate respondsToSelector:@selector(cancelReportMessage)]) {
        [self.delegate cancelReportMessage];
    }
}

-(void)sendText
{
	[self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.textViewContainerView.top = APPDelegate.viewController.view.height;
    }];
    if ([self.delegate respondsToSelector:@selector(sendReportMessage)]) {
        [self.delegate sendReportMessage];
    }
}

@end
