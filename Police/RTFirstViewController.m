//
//  RTFirstViewController.m
//  Police
//
//  Created by wang animeng on 13-5-20.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTFirstViewController.h"
#import "NetAction.h"
#import "UserInfo.h"
#import "UtilityWidget.h"
#import "RTMessageListViewController.h"
#import "RTSendMessageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AlarmAnnotation.h"
#import "MyLocationAnnotation.h"
#import "RTMessageAdapter.h"
#import "MaskView.h"
#import "RTGuidViewController.h"

extern Class ActionPaopaoView;

@interface RTFirstViewController ()<BMKMapViewDelegate,BMKSearchDelegate,RTMessageListViewControllerDelegate,RTSendMessageViewDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,strong) BMKAnnotationView * carAnnotation;

@property (nonatomic,strong) UIImageView *policePoint;

@property (nonatomic,strong) NSArray *alarmAnnotations;

@property (nonatomic,strong) UIView *purpleView;

@property (nonatomic,strong) UIButton *modifyBtn;

@property (nonatomic,strong) RTMessageListViewController *messageListViewController;

@property (nonatomic,strong) RTSendMessageViewController *sendMessageListViewController;

@property (nonatomic,strong) RTGuidViewController *guidViewController;

@property (strong, nonatomic) IBOutlet UIImageView *ladarIndicator;

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIButton *ladarBtn;

@property (nonatomic,strong) BMKSearch * mapSearch;

@property (strong, nonatomic) IBOutlet UIButton *messageBtn;
@end

@implementation RTFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        [self synChangeKey];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isIphone5) {
        self.view.height = 548;
    }
    self.mapSearch = [[BMKSearch alloc] init];
    self.mapSearch.delegate = self;
    [self setupMapView];
    [self setupReturnBtn];
    [self setupModifyCarBtn];
    [self setupTextView];
    [self seupMessageList];
    self.bottomView.bottom = self.view.height;
    [self.view addSubview:self.bottomView];
    if (self.hasGuidView) {
        [self setupGuidView];
    }
//    [self checkLadarStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setLadarIndicator:nil];
    [self setBottomView:nil];
    [self setLadarBtn:nil];
    [self setMessageBtn:nil];
    self.mapView = nil;
    self.carAnnotation = nil;
    self.policePoint = nil;
    self.purpleView = nil;
    self.modifyBtn = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [self removeSynChangeKey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

#pragma mark - private method

- (UIView*)findPaopaoView
{
    for (UIView *subView in [self.mapView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *scrollSubView in subView.subviews) {
                NSString *className = NSStringFromClass([scrollSubView class]);
                if ([className isEqualToString:@"ActionPaopaoView"]) {
                    return scrollSubView;
                }
            }
        }
    }
    return nil;
}

- (UILabel*)findPaopaoTitleTextView
{
    for (UIView *subView in [self.purpleView subviews]) {
        NSString *className = NSStringFromClass([subView class]);
        if ([className isEqualToString:@"PaopaoButton"]) {
            for (UIView *subPaopao in subView.subviews) {
                if ([subPaopao isKindOfClass:[UILabel class]]) {
                    return (UILabel *)subPaopao;
                }
            }
        }
    }
    return nil;
}

- (UILabel*)findPaopaoSubTitleTextView
{
    for (UIView *subView in [self.purpleView subviews]) {
        NSString *className = NSStringFromClass([subView class]);
        if ([className isEqualToString:@"PaopaoButton"]) {
            BOOL isTitle = TRUE;
            for (UIView *subPaopao in subView.subviews) {
                if ([subPaopao isKindOfClass:[UILabel class]]) {
                    if (isTitle) {
                        isTitle = FALSE;
                    }
                    else{
                        return (UILabel *)subPaopao;
                    }
                }
            }
        }
    }
    return nil;
}

- (UIButton*)findPaopaoButtonView
{
    for (UIView *subView in [self.purpleView subviews]) {
        NSString *className = NSStringFromClass([subView class]);
        if ([className isEqualToString:@"PaopaoButton"]) {
            return (UIButton*)subView;
        }
    }
    return nil;
}

- (UIView*)findCurentView
{
    for (UIView *subView in [self.mapView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView *scrollSubView in subView.subviews) {
                NSString *className = NSStringFromClass([scrollSubView class]);
                if ([className isEqualToString:@"LocationView"]) {
                    return scrollSubView;
                }
            }
        }
    }
    return nil;
}


- (void)ladarScanAnimation
{
    self.ladarIndicator.hidden = NO;
    CAAnimation *annimation = [UIView animationRotationAngle:2*M_PI];
    annimation.repeatCount = HUGE_VALF;
    [annimation setDuration:4.0];
    [self.ladarIndicator.layer addAnimation:annimation forKey:@"ladarScan"];
}

- (void)stopLadarAnimation
{
    self.ladarIndicator.hidden = YES;
}

- (void)addPolicePoint
{
    if (!self.policePoint) {
        UIImage *policeImage = [UIImage imageNamed:@"police_avatar"];
        self.policePoint = [[UIImageView alloc] initWithImage:policeImage];
        self.policePoint.size = policeImage.size;
        self.policePoint.center = CGPointMake(KeyWindow.width/2, KeyWindow.height/2-130);
    }
    if (![self.policePoint superview]) {
        [KeyWindow addSubview:self.policePoint];
    }
    [self findPolicePosition];
}

- (void)findPolicePosition
{
    CLLocationCoordinate2D coord =[self.mapView convertPoint:CGPointMake(self.policePoint.centerX, self.policePoint.centerY + self.policePoint.height/2) toCoordinateFromView:KeyWindow];
    [UserInfo shareUserInfo].policeCoordinate2D = coord;
    [self searchAddressWithCoordinate2D:coord];
}

- (void)findCarPosition
{
    CLLocationCoordinate2D coord =[self.mapView convertPoint:CGPointMake(self.carAnnotation.centerX, self.carAnnotation.centerY + self.policePoint.height/2) toCoordinateFromView:KeyWindow];
    [UserInfo shareUserInfo].carLat = [NSNumber numberWithDouble:coord.latitude];
    [UserInfo shareUserInfo].carLng = [NSNumber numberWithDouble:coord.longitude];
    [self searchAddressWithCoordinate2D:coord];
}

- (BOOL)searchAddressWithCoordinate2D:(CLLocationCoordinate2D)coord
{
    BOOL success = [self.mapSearch reverseGeocode:coord];
    return success;
}

- (void)addCarPoint:(CLLocationCoordinate2D)currentCoordinate2D
{
    [UserInfo shareUserInfo].carLat = [NSNumber numberWithDouble:currentCoordinate2D.latitude];
    [UserInfo shareUserInfo].carLng = [NSNumber numberWithDouble:currentCoordinate2D.longitude];
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = currentCoordinate2D;
    annotation.title = @"温馨提示";
    annotation.subtitle = @"点击右边按钮移动汽车位置！";
    if (self.carAnnotation) {
        [self.mapView removeAnnotation:self.carAnnotation.annotation];
    }
    [self.mapView addAnnotation:annotation];
}

- (void)addModifyStatusPoint
{
    self.purpleView = [self findPaopaoView];
    [self findPaopaoButtonView].enabled = NO;
    CGRect carAnnotationRectInWindow = [self.carAnnotation convertRect:self.carAnnotation.bounds toView:KeyWindow];
    CGRect purpleViewRectInWindow = [self.purpleView convertRect:self.purpleView.bounds toView:KeyWindow];
    self.purpleView.frame = purpleViewRectInWindow;
    self.carAnnotation.frame = carAnnotationRectInWindow;
    [self.mapView removeAnnotation:self.carAnnotation.annotation];
    if (self.carAnnotation) {
        [KeyWindow addSubview:self.carAnnotation];
    }
    if (self.purpleView) {
        [KeyWindow addSubview:self.purpleView];
    }
    [self findCarPosition];
}

- (void)removeModifyStatusPoint
{
    CLLocationCoordinate2D coord =[self.mapView convertPoint:CGPointMake(self.carAnnotation.centerX, self.carAnnotation.centerY + self.carAnnotation.height/2) toCoordinateFromView:KeyWindow];
    [self.carAnnotation removeFromSuperview];
    [self.purpleView removeFromSuperview];
    self.purpleView = nil;
    self.carAnnotation = nil;
    [self modifyLocationCompleted:coord];
}

- (void)modifyLocationCompleted:(CLLocationCoordinate2D)coord
{
    // 添加一个PointAnnotation
    [self addCarPoint:coord];
    NSString *status;
    if (hasOpenLadar) {
        status = @"true";
    }
    else{
        status = @"false";
    }
    [NetAction changeStatus:^(NSDictionary *reuslt) {
        JMDINFO(@"change status successful");

    } status:status];
}

- (void)checkLadarStatus
{
    if (!hasOpenLadar) {
        self.ladarIndicator.hidden = YES;
        [self.ladarBtn setBackgroundImage:[UIImage imageNamed:@"middle_button_off"] forState:UIControlStateNormal];
        CGRect carAnnotationRectInWindow = [self.carAnnotation convertRect:self.carAnnotation.bounds toView:KeyWindow];
        [UIView animateWithDuration:1.0 animations:^{
            self.carAnnotation.transform = CGAffineTransformMakeTranslation(-carAnnotationRectInWindow.origin.x - carAnnotationRectInWindow.size.width, 0);
        } completion:^(BOOL finished) {
            [self.mapView removeAnnotation:self.carAnnotation.annotation];
        }];
    }
    else{
        [self.ladarBtn setBackgroundImage:[UIImage imageNamed:@"middle_button_on"] forState:UIControlStateNormal];
        if (![self.carAnnotation superview]) {
            CLLocationCoordinate2D coordinate2d;
            if ([UserInfo shareUserInfo].carLat) {
                coordinate2d.latitude = [[UserInfo shareUserInfo].carLat doubleValue];
                coordinate2d.longitude = [[UserInfo shareUserInfo].carLng doubleValue];
                [self addCarPoint:coordinate2d];
            }
        }
        [self ladarScanAnimation];
    }
}

- (void)checkMessageList
{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber ) {
        [self.messageBtn setImage:[UIImage imageNamed:@"alarm_new_button"] forState:UIControlStateNormal];
    }
    else{
        [self.messageBtn setImage:[UIImage imageNamed:@"alarm_button"] forState:UIControlStateNormal];
    }
}

- (void)getAlarmMessageList
{
    [NetAction getMessage:^(NSArray *result) {
        NSMutableArray *annotations = [NSMutableArray array];
        NSMutableArray *messageLists = [NSMutableArray array];
        AlarmAnnotation *mySendAnnotation;
        for (NSDictionary *subDic in result) {
            AlarmAnnotation *annotation = [[AlarmAnnotation alloc] init];
            CLLocationCoordinate2D coordinate2D;
            coordinate2D.latitude = [[subDic objectForKey:@"lat"] doubleValue];
            coordinate2D.longitude = [[subDic objectForKey:@"lng"] doubleValue];
            annotation.coordinate = coordinate2D;
            annotation.title = [subDic objectForKey:@"location"];
            annotation.subtitle = [subDic objectForKey:@"content"];
            [annotations addObject:annotation];
            
            RTMessageAdapter *adapter = [[RTMessageAdapter alloc] init];
            adapter.addressText = [subDic objectForKey:@"location"];
            adapter.messageText = [subDic objectForKey:@"content"];
            adapter.distanceText = [subDic objectForKey:@"distanceStr"];
            if (coordinate2D.latitude == self.needShowCoordinate2D.latitude && coordinate2D.longitude == self.needShowCoordinate2D.longitude) {
                mySendAnnotation = annotation;
                CLLocationCoordinate2D coordinate2D;
                coordinate2D.latitude = -1000;
                self.needShowCoordinate2D = coordinate2D;
            }
            [messageLists addObject:adapter];
        }
        if (self.alarmAnnotations) {
            [self.mapView removeAnnotations:self.alarmAnnotations];
        }
        [self.mapView addAnnotations:annotations];
        if (mySendAnnotation) {
            [self.mapView selectAnnotation:mySendAnnotation animated:NO];
        }
        self.alarmAnnotations = annotations;
        
        self.messageListViewController.listDatas = messageLists;
        [self.messageListViewController reloadTableView];
    }];
}

#pragma mark - setup View

- (void)setupGuidView
{
    self.guidViewController = [[RTGuidViewController alloc] initWithNibName:@"RTGuidViewController" bundle:nil];
    self.guidViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.guidViewController.view];
    self.hasGuidView = NO;
}

- (void)seupMessageList
{
    self.messageListViewController = [[RTMessageListViewController alloc] initWithNibName:@"RTMessageListViewController" bundle:nil];
    self.messageListViewController.view.top = self.view.height;
    self.messageListViewController.messageDelegate = self;
    [self.view addSubview:self.messageListViewController.view];
}

- (void)setupTextView
{
    self.sendMessageListViewController = [[RTSendMessageViewController alloc] init];
    self.sendMessageListViewController.delegate = self;
    self.sendMessageListViewController.textViewContainerView.top = self.view.height;
    [self.view addSubview:self.sendMessageListViewController.textViewContainerView];
}

- (void)setupMapView
{
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)setupReturnBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(46, 46);
    btn.bottom = self.view.height - self.bottomView.height - 2;
    btn.left = 2;
    [btn addTarget:self action:@selector(returHome:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"location_nav"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)setupModifyCarBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(47, 47);
    btn.bottom = self.view.height - self.bottomView.height - 8;
    btn.right = self.view.width - 8;
    [btn addTarget:self action:@selector(clickModifyCar:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 0, 0)];
    [btn setImage:[UIImage imageNamed:@"P_button"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"P_button_pressed"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
}

#pragma mark - messagelist delegate

- (void)cancelReportMessage
{
    [self.policePoint removeFromSuperview];
    [self.mapView addAnnotations:self.alarmAnnotations];
}

- (void)sendReportMessage
{
    [self.policePoint removeFromSuperview];
    if (![self.sendMessageListViewController.textView hasText]) {
        self.sendMessageListViewController.textView.text = @"条子来了，注意！";
    }
    [UserInfo shareUserInfo].message = self.sendMessageListViewController.textView.text;
    [UserInfo shareUserInfo].policeCoordinate2D = [UserInfo shareUserInfo].policeCoordinate2D;
    [NetAction sendMessage:^(NSDictionary *result) {
        JMDINFO(@"sendMessage successful");
        self.sendMessageListViewController.textView.text = @"";
        [APPDelegate.viewController locationCoordinate2D:[UserInfo shareUserInfo].policeCoordinate2D];
    }];
}

- (void)selectMessageList:(NSInteger)index
{
    AlarmAnnotation *annotation = [self.alarmAnnotations objectAtIndex:index];
    CGPoint point =[self.mapView convertCoordinate:annotation.coordinate toPointToView:KeyWindow];
    CGPoint messagePoint = CGPointMake(point.x, point.y + 40);
    CLLocationCoordinate2D coord = [self.mapView convertPoint:messagePoint toCoordinateFromView:KeyWindow];
    [self.mapView setCenterCoordinate:coord];
    [self.mapView selectAnnotation:annotation animated:NO];
}

#pragma mark - map delegate

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        if ([self.policePoint superview]) {
            self.sendMessageListViewController.addressLabel.text = [NSString stringWithFormat:@"%@",result.strAddr];
            [UserInfo shareUserInfo].policeLocationName = [NSString stringWithFormat:@"%@",result.strAddr];
            if (![self.sendMessageListViewController.textView hasText]) {
                self.sendMessageListViewController.textView.text = @"#条子来了#";
            }
        }
        else if([self.carAnnotation superview] == KeyWindow){
            UILabel *titleLabel = [self findPaopaoTitleTextView];
            UILabel *subTitleLabel = [self findPaopaoSubTitleTextView];
            titleLabel.text = @"汽车的位置";
            NSString *address;
            if (result.addressComponent.streetNumber) {
                address = [NSString stringWithFormat:@"%@%@%@",result.addressComponent.district,result.addressComponent.streetName,result.addressComponent.streetNumber];
            }
            else{
                address = [NSString stringWithFormat:@"%@%@",result.addressComponent.district,result.addressComponent.streetName];
            }
            subTitleLabel.text = address;
        }
	}
    else{
        JMDINFO(@"search address error:%d",error);
    }
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *newLocation = userLocation.location;
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 100) return;
    if (userLocation != nil) {
        CLLocationCoordinate2D oldCoordinate2D = [UserInfo shareUserInfo].myCoordinate2D;
        CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:oldCoordinate2D.latitude longitude:oldCoordinate2D.longitude];
        if ([oldLocation distanceFromLocation:newLocation] > 100) {
            JMDINFO(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            [UserInfo shareUserInfo].myCoordinate2D = userLocation.location.coordinate;
        }
        if (![UserInfo shareUserInfo].carLat && hasOpenLadar) {
            // 添加一个PointAnnotation
            [self addCarPoint:userLocation.location.coordinate];
        }
	}
	
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKAnnotationView *newAnnotation = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        UIImage *carImage = [UIImage imageNamed:@"map_car_icon"];
        newAnnotation.size = carImage.size;
        newAnnotation.image = carImage;
		newAnnotation.draggable = NO;
        newAnnotation.canShowCallout = YES;
        newAnnotation.centerOffset = CGPointMake(0, -carImage.size.height/2);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake([UIImage imageNamed:@"map_move"].size.width*2, [UIImage imageNamed:@"map_move"].size.height*2);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(btn.height/4, btn.width/4, btn.height/4, btn.height/4)];
        [btn setImage:[UIImage imageNamed:@"map_move"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(modifyLocation:) forControlEvents:UIControlEventTouchUpInside];
        newAnnotation.rightCalloutAccessoryView = btn;
		self.carAnnotation = newAnnotation;
        self.modifyBtn = btn;
        
		return newAnnotation;
	}
    else if([annotation isKindOfClass:[AlarmAnnotation class]]){
        BMKAnnotationView *alarmAnnotation = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"alarmAnnotation"];
        UIImage *carImage = [UIImage imageNamed:@"light_icon"];
        alarmAnnotation.size = carImage.size;
        alarmAnnotation.image = carImage;
		alarmAnnotation.draggable = NO;
        alarmAnnotation.canShowCallout = YES;
        
		return alarmAnnotation;
    }
	return nil;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (![UserInfo shareUserInfo].tid) {
        return;
    }
    if ([self.sendMessageListViewController.textView isFirstResponder]) {
        [self.mapView removeAnnotations:self.alarmAnnotations];
        if ([self.policePoint superview]) {
            [self findPolicePosition];
        }
        return;
    }
    if (self.messageListViewController.view.top != self.view.height) {
        return;
    }
    CLLocationCoordinate2D topLeft = [self.mapView convertPoint:CGPointZero toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D bottomRight = [self.mapView convertPoint:CGPointMake(self.mapView.width, self.mapView.height-self.bottomView.height) toCoordinateFromView:self.mapView];

    [UserInfo shareUserInfo].mapTopLeftLat = [NSNumber numberWithDouble:topLeft.latitude];
    [UserInfo shareUserInfo].mapTopLeftLng = [NSNumber numberWithDouble:topLeft.longitude];
    [UserInfo shareUserInfo].mapBottomRightLat = [NSNumber numberWithDouble:bottomRight.latitude];
    [UserInfo shareUserInfo].mapBottomRightLng = [NSNumber numberWithDouble:bottomRight.longitude];
    [self getAlarmMessageList];
    if ([self.carAnnotation superview] == KeyWindow) {
        [self findCarPosition];
    }
}

#pragma mark - location car

- (void)locationCurrent
{
    [self locationCoordinate2D:[UserInfo shareUserInfo].myCoordinate2D];
}

- (void)locationCoordinate2D:(CLLocationCoordinate2D)coord
{
    BMKCoordinateRegion region;
    region.span.latitudeDelta = 0.00001*self.view.width;
    region.span.longitudeDelta = 0.00001*self.view.height;
    region.center = coord;
    [self.mapView setRegion:region animated:NO];
    [self.mapView regionThatFits:region];
}

#pragma mark - btn event

- (IBAction)showMessageList:(id)sender
{
    if (self.messageListViewController.view.top == self.view.height) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.messageListViewController.view.bottom = self.view.height - 50;
        } completion:^(BOOL finished) {
            [MaskView showMaskInView:self.mapView backgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3] size:CGSizeMake(self.mapView.width,self.messageListViewController.view.top) removeMask:^{
                [self showMessageList:nil];
            }];
        }];

        [self checkMessageList];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            self.messageListViewController.view.top = self.view.height;
        }];
        [MaskView removeMaskInView:self.mapView];
        [self mapView:self.mapView regionDidChangeAnimated:NO];
    }
}

- (void)clickModifyCar:(id)sender
{
    if (!hasOpenLadar) {
        [UtilityWidget showAlertComplete:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self toggleLadar:nil];
            }
        } withTitle:@"温馨提示" message:@"请先开启雷达，再进行停车" buttonTiles:@"立即开启雷达"];
        return;
    }
    if ([self.carAnnotation superview] != KeyWindow) {
        [self.mapView setCenterCoordinate:self.carAnnotation.annotation.coordinate];
        [self.mapView selectAnnotation:self.carAnnotation.annotation animated:NO];
        if (![self.carAnnotation superview]) {
            [self.mapView setCenterCoordinate:[UserInfo shareUserInfo].myCoordinate2D];
            [self addCarPoint:[UserInfo shareUserInfo].myCoordinate2D];
        }
    }
    else{
        [self removeModifyStatusPoint];
    }
}

- (void)modifyLocation:(id)sender
{
    if ([self.carAnnotation superview] == KeyWindow) {
        [self removeModifyStatusPoint];
    }
    else{
        [self addModifyStatusPoint];
        [self.modifyBtn setImage:[UIImage imageNamed:@"map_stop"] forState:UIControlStateNormal];
    }
}

- (void)returHome:(id)sender
{
    [self locationCurrent];
}

- (IBAction)toggleLadar:(id)sender
{
    NSString *status;
    if (!hasOpenLadar) {
        [UtilityWidget showNetLoadingStatusBar:@"正在开启雷达"];
        status = @"true";
    }
    else{
        [UtilityWidget showNetLoadingStatusBar:@"正在关闭雷达"];
        status = @"false";
    }
    if (![UserInfo shareUserInfo].carLat && [UserInfo shareUserInfo].myCoordinate2D.latitude!=0 && [UserInfo shareUserInfo].myCoordinate2D.longitude != 0) {
        [UserInfo shareUserInfo].carLat = [NSNumber numberWithDouble:[UserInfo shareUserInfo].myCoordinate2D.latitude];
        [UserInfo shareUserInfo].carLng = [NSNumber numberWithDouble:[UserInfo shareUserInfo].myCoordinate2D.longitude];
    }
    [NetAction changeStatus:^(NSDictionary *reuslt){
        JMDINFO(@"change status successful");
        if (!hasOpenLadar) {
            [UtilityWidget showNetLoadCompleteStatusBar:@"开启雷达成功"];
            openLocalLadar();
        }
        else{
            [UtilityWidget showNetLoadCompleteStatusBar:@"关闭雷达成功"];
            closeLocalLadar();
        }
        if ([self.carAnnotation superview] == KeyWindow) {
            if (!hasOpenLadar) {
                [self removeModifyStatusPoint];
            }
            else{
                return;
            }
        }
        [UserInfo shareUserInfo].carLat = [NSNumber numberWithDouble:[UserInfo shareUserInfo].myCoordinate2D.latitude];
        [UserInfo shareUserInfo].carLng = [NSNumber numberWithDouble:[UserInfo shareUserInfo].myCoordinate2D.longitude];
        [self checkLadarStatus];
    } status:status];
}
- (IBAction)sendMessage:(id)sender
{

    if (self.messageListViewController.view.top != self.view.height) {
        [self showMessageList:nil];
        return;
    }
    if (self.sendMessageListViewController.textViewContainerView.top < (self.view.height+self.sendMessageListViewController.textViewContainerView.height)) {
        [self.sendMessageListViewController.textView becomeFirstResponder];
        [self.mapView removeAnnotations:self.alarmAnnotations];
        BMKCoordinateRegion region;
        region.span.latitudeDelta = 0.00001*self.view.width;
        region.span.longitudeDelta = 0.00001*self.view.height;
        CLLocationCoordinate2D location = [UserInfo shareUserInfo].myCoordinate2D;
        location.latitude = location.latitude - 0.002;
        region.center = location;
        [self.mapView setRegion:region animated:NO];
        [self.mapView regionThatFits:region];
        [self.mapView setCenterCoordinate:location animated:NO];
        [self addPolicePoint];
    }
}
#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[UserInfo class]]) {
        if ([keyPath isEqualToString:@"myCoordinate2D"]) {
            [self locationCurrent];
        }
    }
}

#pragma mark - Add Observer

- (void)synChangeKey
{
    [[UserInfo shareUserInfo] addObserver:self forKeyPath:@"myCoordinate2D" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeSynChangeKey
{
    [[UserInfo shareUserInfo] removeObserver:self forKeyPath:@"myCoordinate2D"];
}

@end
