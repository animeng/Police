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

extern Class ActionPaopaoView;

@interface RTFirstViewController ()<BMKMapViewDelegate,BMKSearchDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,assign) BOOL hasCarPosition;

@property (nonatomic,strong) BMKAnnotationView * carAnnotation;

@property (nonatomic,strong) UIImageView *policePoint;

@property (nonatomic,strong) NSArray *alarmAnnotations;

@property (nonatomic,strong) UIView *purpleView;

@property (nonatomic,strong) UIButton *modifyBtn;

@property (nonatomic,strong) RTMessageListViewController *messageListViewController;

@property (nonatomic,strong) RTSendMessageViewController *sendMessageListViewController;

@property (strong, nonatomic) IBOutlet UIImageView *ladarIndicator;

@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIButton *ladarBtn;

@property (nonatomic,strong) BMKSearch * mapSearch;

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
    [self setupTextView];
    self.bottomView.bottom = self.view.height;
    [self.view addSubview:self.bottomView];
    [self checkLadarStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self removeSynChangeKey];
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
    [annimation setDuration:1];
    [self.ladarIndicator.layer addAnimation:annimation forKey:@"ladarScan"];
}

- (void)stopLadarAnimation
{
    self.ladarIndicator.hidden = YES;
}

- (void)addPolicePoint
{
    if (!self.policePoint) {
        UIImage *policeImage = [UIImage imageNamed:@"self_icon"];
        self.policePoint = [[UIImageView alloc] initWithImage:policeImage];
        self.policePoint.size = policeImage.size;
        self.policePoint.center = CGPointMake(KeyWindow.width/2, KeyWindow.height/2-80);
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
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = currentCoordinate2D;
    annotation.title = @"温馨提示";
    annotation.subtitle = @"点击右边按钮移动汽车位置！";
    [self.mapView addAnnotation:annotation];
}

- (void)addModifyStatusPoint
{
    self.purpleView = [self findPaopaoView];
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
    [UserInfo shareUserInfo].carLat = [NSNumber numberWithDouble:coord.latitude];
    [UserInfo shareUserInfo].carLng = [NSNumber numberWithDouble:coord.longitude];
    [NetAction changeStatus:^(NSDictionary *reuslt) {
        JMDINFO(@"change status successful");

    } status:[UserInfo shareUserInfo].status];
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
            [self addCarPoint:[UserInfo shareUserInfo].myCoordinate2D];
        }
        [self ladarScanAnimation];
    }
}

#pragma mark - setup View

- (void)setupTextView
{
    self.sendMessageListViewController = [[RTSendMessageViewController alloc] init];
    self.sendMessageListViewController.textViewContainerView.top = self.view.height -40;
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.size = CGSizeMake(30, 30);
    btn.bottom = 50;
    [btn addTarget:self action:@selector(returHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn];
}

#pragma mark - map delegate

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        if ([self.policePoint superview]) {
            self.sendMessageListViewController.textView.text = [NSString stringWithFormat:@"条子在%@",result.strAddr];
        }
        else if([self.carAnnotation superview] == KeyWindow){
            UILabel *titleLabel = [self findPaopaoTitleTextView];
            UILabel *subTitleLabel = [self findPaopaoSubTitleTextView];
            titleLabel.text = @"汽车的位置";
            NSString *address = [NSString stringWithFormat:@"%@%@%@",result.addressComponent.district,result.addressComponent.streetName,result.addressComponent.streetNumber];
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
    if (newLocation.horizontalAccuracy < 0) return;
    if (userLocation != nil) {
        CLLocationCoordinate2D oldCoordinate2D = [UserInfo shareUserInfo].myCoordinate2D;
        CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:oldCoordinate2D.latitude longitude:oldCoordinate2D.longitude];
        if ([oldLocation distanceFromLocation:newLocation] > 500) {
            JMDINFO(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            [UserInfo shareUserInfo].myCoordinate2D = userLocation.location.coordinate;
        }
        if (!self.hasCarPosition && hasOpenLadar) {
            // 添加一个PointAnnotation
            [self modifyLocationCompleted:userLocation.location.coordinate];
            self.hasCarPosition = YES;
        }
	}
	
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil)
		JMDINFO(@"locate failed: %@", [error localizedDescription]);
	else {
		JMDINFO(@"locate failed");
	}
	
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	JMDINFO(@"start locate");
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
        btn.size = [UIImage imageNamed:@"map_move"].size;
        [btn setBackgroundImage:[UIImage imageNamed:@"map_move"] forState:UIControlStateNormal];
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
    CLLocationCoordinate2D topLeft = [self.mapView convertPoint:CGPointZero toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D bottomRight = [self.mapView convertPoint:CGPointMake(self.mapView.width, self.mapView.height-self.bottomView.height) toCoordinateFromView:self.mapView];
    [UserInfo shareUserInfo].mapTopLeftLat = [NSNumber numberWithDouble:topLeft.latitude];
    [UserInfo shareUserInfo].mapTopLeftLng = [NSNumber numberWithDouble:topLeft.longitude];
    [UserInfo shareUserInfo].mapBottomRightLat = [NSNumber numberWithDouble:bottomRight.latitude];
    [UserInfo shareUserInfo].mapBottomRightLng = [NSNumber numberWithDouble:bottomRight.longitude];
    [NetAction getMessage:^(NSArray *result) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSDictionary *subDic in result) {
            AlarmAnnotation *annotation = [[AlarmAnnotation alloc] init];
            CLLocationCoordinate2D coordinate2D;
            coordinate2D.latitude = [[subDic objectForKey:@"lat"] doubleValue];
            coordinate2D.longitude = [[subDic objectForKey:@"lng"] doubleValue];
            annotation.coordinate = coordinate2D;
            annotation.title = @"Alarm";
            annotation.subtitle = [subDic objectForKey:@"content"];
            [annotations addObject:annotation];
        }
        if (self.alarmAnnotations) {
            [self.mapView removeAnnotations:self.alarmAnnotations];
        }
        [self.mapView addAnnotations:annotations];
        self.alarmAnnotations = annotations;
    }];
    if ([self.policePoint superview]) {
        [self findPolicePosition];
    }
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
    [self.mapView setCenterCoordinate:coord animated:NO];
    
}

#pragma mark - btn event

- (void)modifyLocation:(id)sender
{
    if ([self.carAnnotation superview] == KeyWindow) {
        [self removeModifyStatusPoint];
    }
    else{
        [self addModifyStatusPoint];
        [self.modifyBtn setBackgroundImage:[UIImage imageNamed:@"map_stop"] forState:UIControlStateNormal];
    }
}

- (void)returHome:(id)sender
{
    if (hasOpenLadar &&[self.carAnnotation superview] != KeyWindow) {
        [UtilityWidget showAlertComplete:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.mapView removeAnnotation:self.carAnnotation.annotation];
                [self modifyLocationCompleted:[UserInfo shareUserInfo].myCoordinate2D];


            }
        }
                               withTitle:@"温馨提示"
                                 message:@"你的汽车是否回到当前的位置？"
                             buttonTiles:@"确定",nil];
    }

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
        [self checkLadarStatus];
    } status:status];
}
- (IBAction)sendMessage:(id)sender
{

    if (self.sendMessageListViewController.textViewContainerView.bottom == self.view.height) {
        [self.sendMessageListViewController.textView becomeFirstResponder];
        BMKCoordinateRegion region;
        region.span.latitudeDelta = 0.00001*self.view.width;
        region.span.longitudeDelta = 0.00001*self.view.height;
        CLLocationCoordinate2D location = [UserInfo shareUserInfo].myCoordinate2D;
        location.latitude = location.latitude - 0.001;
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

-(void) keyboardWillHide:(NSNotification *)note
{
    [self.policePoint removeFromSuperview];
}

- (void)synChangeKey
{
    [[UserInfo shareUserInfo] addObserver:self forKeyPath:@"myCoordinate2D" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeSynChangeKey
{
    [[UserInfo shareUserInfo] removeObserver:self forKeyPath:@"myCoordinate2D"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidUnload {
    [self setLadarIndicator:nil];
    [self setBottomView:nil];
    [self setLadarBtn:nil];
    [super viewDidUnload];
}
@end
