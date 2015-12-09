//
//  TabBarController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TabBarController.h"
#import "UIColor+PerDiem.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;

    CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v setBackgroundColor:[UIColor blackColor]];
    [[self tabBar] addSubview:v];
}

@end
