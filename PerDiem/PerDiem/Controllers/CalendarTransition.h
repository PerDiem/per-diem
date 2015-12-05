//
//  CalendarTransition.h
//  PerDiem
//
//  Created by Florent Bonomo on 12/3/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CalendarTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL usingGesture;

- (instancetype)initWithTransitioningController:(UIViewController *)transitioningController;
- (void)onPanGesture:(UIPanGestureRecognizer *)sender;

@end
