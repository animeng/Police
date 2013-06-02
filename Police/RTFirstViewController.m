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

@interface RTFirstViewController ()<BMKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,strong) CLLocationManager * locationManager;

@property (nonatomic,assign) CLLocationCoordinate2D myLocation;

@property (nonatomic,assign) BOOL hasPolicePosition;

@property (nonatomic,strong) BMKAnnotationView * carAnnotation;

@end

@implementation RTFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self locateCurPosition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UserInfo shareUserInfo].tid) {
        [NetAction logon:^(NSDictionary *result) {
            JMDINFO(@"logon successful");
        }];
    }
    else{
        [NetAction initPort:^(NSDictionary *result) {
            
            [NetAction logon:^(NSDictionary *result) {
                JMDINFO(@"logon successful");
            }];
            
        }];
    }
    
}

#pragma mark - map delegate

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *newLocation = userLocation.location;
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (locationAge > 5.0) return;
    if (newLocation.horizontalAccuracy < 0) return;
    
    if (userLocation != nil) {
		JMDINFO(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        if (!self.hasPolicePosition) {
            // 添加一个PointAnnotation
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = userLocation.location.coordinate;
            annotation.title = @"plice";
            annotation.subtitle = @"coming!";
            [self.mapView addAnnotation:annotation];
            self.hasPolicePosition = YES;
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
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = NO;
		newAnnotation.draggable = NO;
        newAnnotation.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = [UIImage imageNamed:@"first"].size;
        [btn setBackgroundImage:[UIImage imageNamed:@"first"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(modifyLocation:) forControlEvents:UIControlEventTouchUpInside];
        newAnnotation.leftCalloutAccessoryView = btn;
        
		self.carAnnotation = newAnnotation;
		return newAnnotation;
	}
	return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState
{
    if (newState == BMKAnnotationViewDragStateEnding) {
        JMDINFO(@"%f %f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([self.carAnnotation superview] == KeyWindow) {
        CLLocationCoordinate2D coord =[self.mapView convertPoint:CGPointMake(self.carAnnotation.centerX, self.carAnnotation.centerY + self.carAnnotation.height/2) toCoordinateFromView:KeyWindow];
        [self.carAnnotation removeFromSuperview];
        [self modifyLocationCompleted:coord];
    }
}

#pragma mark - location

- (void)locationCar
{
    if (!self.mapView) {
        self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        [self.mapView setShowsUserLocation:YES];
        self.mapView.delegate = self;
        [self.view addSubview:self.mapView];
    }
    [self.mapView setCenterCoordinate:self.myLocation animated:YES];
    BMKCoordinateRegion region;
    region.span.latitudeDelta = 0.0001*self.view.width;
    region.span.longitudeDelta = 0.0001*self.view.height;
    region.center = self.myLocation;
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];

}

- (void)locateCurPosition
{
    if(self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"地图开启" message:@"地图开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000;
        [self.locationManager startUpdatingLocation];
    }
}

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation
{
    
    if(nil==newLocation)
        return;
    if(newLocation.horizontalAccuracy>1400)
        return;
    CLLocationCoordinate2D coordinate=newLocation.coordinate;
    self.myLocation = coordinate;
    [self locationCar];
    [manager stopUpdatingLocation];
    
}

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error
{
    
    switch (error.code) {
        case kCLErrorDenied: {
            [manager stopUpdatingLocation];
        }   break;
        default: {
            [manager stopUpdatingLocation];
        }   break;
    }
}

#pragma mark - btn event

- (void)modifyLocation:(id)sender
{
    CGRect rectInWindow = [self.carAnnotation convertRect:self.carAnnotation.bounds toView:KeyWindow];
    [self.mapView removeAnnotation:self.carAnnotation.annotation];
    self.carAnnotation.frame = rectInWindow;
    [KeyWindow addSubview:self.carAnnotation];
    
    [NetAction changeStatus:^(NSDictionary *reuslt) {
        JMDINFO(@"change status successful");
    }];
    
    [NetAction getMessage:^(NSArray *reuslt) {
        JMDINFO(@"getMessage successful");
    }];
}

- (void)modifyLocationCompleted:(CLLocationCoordinate2D)coord
{
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coord;
    annotation.title = @"police";
    annotation.subtitle = @"coming!";
    [self.mapView addAnnotation:annotation];
    
    [NetAction sendMessage:^(NSDictionary *reuslt) {
        JMDINFO(@"sendMessage successful");
    }];
}

@end
