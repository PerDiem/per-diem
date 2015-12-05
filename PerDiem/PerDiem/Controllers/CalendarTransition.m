//
//  CalendarTransition.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/3/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarTransition.h"
#import "CalendarViewController.h"
#import "CalendarDayViewController.h"

@interface CalendarTransition ()

@property (nonatomic, assign) CGPoint viewOriginalCenter;
@property (nonatomic, strong) UIViewController *transitioningController;

@end

@implementation CalendarTransition

- (instancetype)initWithTransitioningController:(UIViewController *)transitioningController {
    if ([super init]) {
        _transitioningController = transitioningController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.usingGesture) {    // Transition from Day to Month
        CalendarDayViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CalendarViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        // Add target view to hierarchy
        [[transitionContext containerView] addSubview:to.view];
    
        // Get position of Per Diem view in month tableview, relative to screen
        UIView *targetView = [to.selectedController viewForPerDiem:from.perDiemView.perDiem];
        CGPoint targetViewInScreen = [targetView.superview convertPoint:targetView.frame.origin toView:nil];
        CGRect perDiemViewFrame = CGRectMake(targetViewInScreen.x, targetViewInScreen.y, targetView.frame.size.width, targetView.frame.size.height);
        
        // Animate!
        to.view.alpha = 0.0;
        from.transactionsView.alpha = 1;
        [UIView animateWithDuration:1 animations:^{
            from.transactionsView.alpha = 0;
            [from.perDiemView.view setFrame:perDiemViewFrame];
            [from.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [UIView animateWithDuration:.6 animations:^{
                    to.view.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [transitionContext completeTransition:YES];
                }];
            }
        }];

    } else {                    // Transition from Month to Day

        CalendarViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CalendarDayViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // Some bug apparently mess up the frame after the transition
        // This prevents it
        [to.view setFrame:[[UIScreen mainScreen] bounds]];


        // Add target view to hierarchy
        [[transitionContext containerView] addSubview:to.view];
        
        // Get position of Per Diem view in day tableview, relative to screen
        CGRect originalFrame = to.perDiemView.frame;
        UIView *targetView = [from.selectedController viewForPerDiem:to.perDiemView.perDiem];
        CGPoint targetViewInScreen = [targetView.superview convertPoint:targetView.frame.origin toView:nil];
        CGRect perDiemViewFrame = CGRectMake(targetViewInScreen.x, targetViewInScreen.y, targetView.frame.size.width, targetView.frame.size.height);
        
        // Position it over its matching cell in month view
        [to.perDiemView setFrame:perDiemViewFrame];
        
        to.transactionsView.alpha = 0;
        to.view.alpha = 1.0;
        [UIView animateWithDuration:.3 animations:^{
            to.view.alpha = 1.0;
            [to.perDiemView setFrame:originalFrame];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 animations:^{
                to.transactionsView.alpha = 1;
            } completion:^(BOOL finished) {
               [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }];
    }

}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
//    NSLog(@"%f", percentComplete);
    [super updateInteractiveTransition:percentComplete];
}
    //    CGPoint translation = [sender translationInView:self.view];
//    self.view.center = CGPointMake(self.viewOriginalCenter.x,
//                                   self.viewOriginalCenter.y + 300 * percentComplete);
//
    
    //    } else if (sender.state == UIGestureRecognizerStateEnded) {
    //        if ([sender velocityInView:self.view].y > 0) {
    //            NSLog(@"FOO");
    //            //            //hide
    //            //            CGPoint center = self.trayView.center;
    //            //            center.y = [self lowerLimit] + self.trayView.frame.size.height/2;
    //            //            self.trayView.center = center;
    //        } else {
    //            NSLog(@"BAR");
    //            //            CGPoint center = self.trayView.center;
    //            //            center.y = [self upperLimit] + self.trayView.frame.size.height/2;
    //            //            self.trayView.center = center;
    //            //            //show
    //        }
    //    }

//}

//- (void)finishInteractiveTransition {
//    
//}

- (void)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.transitioningController.view];
    CGFloat percent = fmaxf(fminf(point.y / 300.0, 0.99), 0.0); //point.y * 100 / 150;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.usingGesture = YES;
            [self.transitioningController.navigationController popViewControllerAnimated:YES];
            
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            self.usingGesture = NO;
            
        default:
            break;
    }
}

@end
