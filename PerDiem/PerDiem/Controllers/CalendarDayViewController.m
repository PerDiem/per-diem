//
//  CalendarDayViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/1/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarDayViewController.h"
#import "PerDiemView.h"
#import "TransactionsViewController.h"

@interface CalendarDayViewController ()

@property (weak, nonatomic) IBOutlet PerDiemView *perDiemView;
@property (weak, nonatomic) IBOutlet UIView *transactionsView;
@property (strong, nonatomic) TransactionsViewController *transactionsViewController;

@end

@implementation CalendarDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transactionsViewController = [[TransactionsViewController alloc] initWithTimePeriod:self.timePeriod];
    [self.transactionsView addSubview:self.transactionsViewController.view];
    
    [PerDiem perDiemsForDate:[self.timePeriod StartDate]
                  completion:^(PerDiem *perDiem, NSError *error) {
                      if (!error) {
                          self.perDiemView.perDiem = perDiem;
                      }
                  }];
}

@end
