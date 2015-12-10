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

- (void)setupBarItemWithImageNamed:(NSString *)imageName selectedImageName: (NSString*) selectedImageName title:(NSString *)tabTitle {
    UIImage *tabImage = [UIImage imageNamed:imageName];
    UIImage *tabImageSelected = [UIImage imageNamed:selectedImageName];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabTitle
                                                    image:tabImage
                                            selectedImage:tabImageSelected];
}

@end
