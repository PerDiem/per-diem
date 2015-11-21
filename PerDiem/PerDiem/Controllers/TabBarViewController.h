//
//  TabBarViewController.h
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UIViewController

- (void)setupUI;
- (void)setupBarItemWithTitle:(NSString *)title imageNamed:(NSString *)imageName;

@end
