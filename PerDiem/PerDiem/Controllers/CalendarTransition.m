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
#import "DayViewTableViewCell.h"
#import "TransactionFormViewController.h"

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

    CalendarDayViewController *dayVc;
    CalendarViewController *monthVc;

    // This doesn't too nice, and also the transition I made is not consistent with the rest of the system.
    if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[TransactionFormViewController class]] ||
        [[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[TransactionFormViewController class]]) {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        [[transitionContext containerView] addSubview:toViewController.view];

        toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];

        [UIView animateWithDuration:0. animations:^{
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        return;
    }

    if (!self.isPresenting) {
        dayVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        monthVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        [monthVc.selectedController.tableView reloadData];
    } else {
        dayVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        monthVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }

    UIView *monthView = monthVc.view;
    DayViewTableViewCell *dayView = [monthVc.selectedController viewForPerDiem:dayVc.perDiemView.perDiem];
    UIView *detailedDayView = dayVc.view;
    UIView *transactionsView = dayVc.transactionsView;
    UIView *perDiemView = dayVc.perDiemView.view;

    typedef void (^PrepareAnimation)();
    typedef void (^Animation)();
    typedef void (^CompleteAnimation)(BOOL);

    PrepareAnimation preparation;
    Animation animations;
    CompleteAnimation completion;

    if (!self.isPresenting) {

        // Add target view to hierarchy
        [[transitionContext containerView] addSubview:monthView];
        [[transitionContext containerView] bringSubviewToFront:detailedDayView];

        // Get position of Per Diem view in month tableview, relative to screen
        CGPoint position = [dayView.superview convertPoint:dayView.frame.origin toView:nil];
        CGRect dayViewFrame = CGRectMake(position.x, position.y - 20, dayView.frame.size.width, dayView.frame.size.height);
        
        // Animate!
        preparation = ^void() {
            dayView.alpha = 0;
            monthView.alpha = 0;
            transactionsView.alpha = 1;
        };
        
        animations = ^void() {
            monthVc.navigationController.navigationBar.alpha = 1;
            monthView.alpha = 1;
            transactionsView.alpha = 0;
            [perDiemView setFrame:dayViewFrame];
            [detailedDayView layoutIfNeeded];
        };
        
        completion = ^void(BOOL finished) {
            [dayView layoutSubviews];
            dayView.alpha = 1;
            
            BOOL wasCompleted = ![transitionContext transitionWasCancelled];
            [transitionContext completeTransition:wasCompleted];
            if (!wasCompleted) {
                [dayVc viewWillAppear:NO];
            }
        };
        
    } else {
        // Add target view to hierarchy
        [[transitionContext containerView] addSubview:detailedDayView];
        
        // Get position of Per Diem view in month tableview, relative to screen
        CGPoint position = [dayView.superview convertPoint:dayView.frame.origin toView:nil];
        CGRect dayViewFrame = CGRectMake(position.x, position.y - 20, dayView.frame.size.width, dayView.frame.size.height);

        // Without these three lines, the frame is 320 width no matter the screen size
        // https://forums.developer.apple.com/thread/13221
        dayVc.view.frame = [transitionContext finalFrameForViewController:dayVc];
        [dayVc.view layoutSubviews];
        [dayVc.perDiemView updateUI];
        
        CGRect perDiemOriginalFrame = perDiemView.frame;
        
        // Animate!
        preparation = ^void() {
            detailedDayView.alpha = 1;
            transactionsView.alpha = 0;
            [perDiemView setFrame:dayViewFrame];
            [detailedDayView layoutIfNeeded];
        };
        
        animations = ^void() {
            monthView.alpha = 0;
            detailedDayView.alpha = 1;
            transactionsView.alpha = 1;
            [perDiemView setFrame:perDiemOriginalFrame];
            [detailedDayView layoutIfNeeded];
        };
        
        completion = ^void(BOOL finished) {
            dayView.alpha = 1;
            
            BOOL wasCompleted = ![transitionContext transitionWasCancelled];
            [transitionContext completeTransition:wasCompleted];
            if (!wasCompleted) {
                [monthVc viewWillAppear:NO];
            }
        };
    }
    
    preparation();
    [UIView animateWithDuration:.8
                     animations:animations
                     completion:completion];
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
