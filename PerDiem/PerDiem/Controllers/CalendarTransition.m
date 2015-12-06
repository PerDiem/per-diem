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
    
    if (!self.isPresenting) {    // Transition from Day to Month
        CalendarDayViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CalendarViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        // Add target view to hierarchy
        [[transitionContext containerView] addSubview:to.view];
        [[transitionContext containerView] bringSubviewToFront:from.view];
        from.view.backgroundColor = [UIColor clearColor];
    
        // Get position of Per Diem view in month tableview, relative to screen
        UIView *targetView = [to.selectedController viewForPerDiem:from.perDiemView.perDiem];
        CGPoint targetViewInScreen = [targetView.superview convertPoint:targetView.frame.origin toView:nil];
        CGRect perDiemViewFrame = CGRectMake(targetViewInScreen.x, targetViewInScreen.y - 20, targetView.frame.size.width, targetView.frame.size.height);
        
        // Animate!
        to.view.alpha = 0.0;
        targetView.alpha = 0;
        from.transactionsView.alpha = 1;
        
        [UIView animateWithDuration:1 animations:^{
            from.transactionsView.alpha = 0;
            to.navigationController.navigationBar.alpha = 1;
            [from.perDiemView.view setFrame:perDiemViewFrame];
            [from.view layoutIfNeeded];
            to.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            targetView.alpha = 1.0;
            BOOL wasCompleted = ![transitionContext transitionWasCancelled];
            [transitionContext completeTransition:wasCompleted];
            if (!wasCompleted) {
                [from viewWillAppear:NO];
            }
        }];

    } else {    // Transition from Month to Day

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
                BOOL wasCompleted = ![transitionContext transitionWasCancelled];
                [transitionContext completeTransition:wasCompleted];
                self.isPresenting = !wasCompleted;
            }];
        }];
    }

}

- (void)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.transitioningController.view];
    CGFloat percent = fmaxf(fminf(point.y / 300.0, 0.99), 0.0); //point.y * 100 / 150;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
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
            
        default:
            break;
    }
}

@end
