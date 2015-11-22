//
//  TabBarViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    // NOOP
}

- (void)setupBarItemWithImageNamed:(NSString *)imageName {
    UIImage *tabImage = [UIImage imageNamed:imageName];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                    image:tabImage
                                            selectedImage:tabImage];
}

@end
