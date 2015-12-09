//
//  CalendarDayViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/1/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "CalendarDayViewController.h"
#import "AddButtonView.h"
#import "BudgetFormViewController.h"
#import "NavigationViewController.h"
#import "TransactionFormViewController.h"
#import "TransactionsViewController.h"
#import "UIColor+PerDiem.h"

@interface CalendarDayViewController () <AddButtonDelegate, TransactionFormActionDelegate>

@property (strong, nonatomic) TransactionsViewController *transactionsViewController;

@property (weak, nonatomic) IBOutlet AddButtonView *addButtonView;

@end

@implementation CalendarDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:self.perDiem.date];
    DTTimePeriod *timePeriod = [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay startingAt:startOfDay];
    [[timePeriod EndDate] dateBySubtractingSeconds:1];
    
    self.transactionsViewController = [[TransactionsViewController alloc] initWithTimePeriod:timePeriod];
    [self.transactionsView addSubview:self.transactionsViewController.view];
    self.perDiemView.perDiem = self.perDiem;
    [self.view sendSubviewToBack:self.transactionsView];
    self.view.backgroundColor = [UIColor clearColor];
    self.addButtonView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.alpha = 0;
}

- (IBAction)onPerDiemPanGesture:(UIPanGestureRecognizer *)sender {
    if (self.transitionHelper) {
        self.transitionHelper.isPresenting = NO;
        [self.transitionHelper onPanGesture:sender];
    }
}


#pragma mark - AddButtonDelegate

- (void)addButtonView:(UIView *)view presentAlertController:(UIAlertController *)alert {
    [self.navigationController presentViewController:alert
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewBudget:(UIAlertController *)alert {
    BudgetFormViewController *vc = [[BudgetFormViewController alloc] init];
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}

- (void)addButtonView:(UIView *)view alertControllerForNewTransaction:(UIAlertController *)alert {
    TransactionFormViewController *vc = [[TransactionFormViewController alloc] init];
    vc.delegate = self;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:nil];
}


#pragma mark - TransactionFormActionDelegate

- (void)transactionCreated:(Transaction *)transaction {
    [self.transactionsViewController.transactionList addTransaction:transaction];
    [self.transactionsViewController.tableView reloadData];
    self.perDiem.spent = [NSNumber numberWithFloat:([self.perDiem.spent floatValue] + [transaction.amount floatValue])];
    [self.perDiemView updateUI];
}

- (void)transactionUpdated:(Transaction *)transaction {
    [self.transactionsViewController.tableView reloadData];
}

@end
