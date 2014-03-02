//
//  SwipeDown.xm
//  SwipeDown
//
//  Created by Sirifl0w on 16.01.2014.
//  Copyright (c) 2014 Sirifl0w. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <substrate.h>

@interface SBAppSliderController : UIViewController 
- (void)_quitAppAtIndex:(unsigned int)arg1;
@end

@interface SBAppSliderScrollView : UIScrollView
@end

@interface SBAppSliderScrollingViewController : UIViewController 
{
    SBAppSliderScrollView *_scrollView;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(struct CGPoint)arg2 targetContentOffset:(CGPoint)arg3;
@end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (id)_appSliderController;
@end

%hook SBAppSliderScrollingViewController

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(struct CGPoint)arg2 targetContentOffset:(CGPoint)arg3 {

	SBUIController *sharedUI = [%c(SBUIController) sharedInstance];
	SBAppSliderController *appSliderCont = [sharedUI _appSliderController];

        // arbitrary offset, try to match that of the swipe up gesture. Alter for sensitivity change.
        
        if (scrollView.contentOffset.y < -40) {

            UIScrollView *sliderScroller = MSHookIvar<UIScrollView *>(self, "_scrollView");
			
            // Determine the location of the gesture.
            CGPoint swipeLocation = [sliderScroller.panGestureRecognizer locationInView:sliderScroller];
            NSUInteger index = [[self valueForKey:@"_items"] indexOfObject:scrollView];

        if (index != 0) {
            for (UIView *pageView in sliderScroller.subviews) {
                if (CGRectContainsPoint(pageView.frame, swipeLocation)) {
                        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                            pageView.frame = CGRectMake(pageView.frame.origin.x, 1024.0f, pageView.frame.size.width, pageView.frame.size.height);
                        } completion:^(BOOL finished){
                            [appSliderCont _quitAppAtIndex:index];
                        }];
                }
            }
        }
    }
    %orig;
}

%end
