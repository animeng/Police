//
//  EGORefreshTableFootView.h


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling1 = 0,
	EGOOPullRefreshNormal1,
	EGOOPullRefreshLoading1,	
} EGOPullRefreshState1;

@protocol EGORefreshTableFootDelegate;
@interface EGORefreshTableFootView : UIView {
	
	__unsafe_unretained id _delegate;
	EGOPullRefreshState1 _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,unsafe_unretained) id <EGORefreshTableFootDelegate> delegate;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void) setLoadingCenter;
- (void) hideLabels;
- (void) setArrowImage:(UIImage*) arrow;

@end
@protocol EGORefreshTableFootDelegate
- (void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableFootView*)view;
- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGORefreshTableFootView*)view;
@optional
- (NSDate*)egoRefreshTableFootDataSourceLastUpdated:(EGORefreshTableFootView*)view;
@end
