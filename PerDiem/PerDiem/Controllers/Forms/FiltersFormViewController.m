//
//  FiltersFormViewController.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "FiltersFormViewController.h"
#import "XLForm.h"
#import "Budget.h"
#import "PaymentType.h"
#import "UIColor+PerDiem.h"

NSString *const kFutures = @"futures";
NSString *const kBudgets = @"budgets";

@interface FiltersFormViewController ()

@property (strong, nonatomic) NSDictionary *defaults;
@property (strong, nonatomic) NSArray *budgets;
@property (strong, nonatomic) XLFormSectionDescriptor *budgetsSection;
@property (strong, nonatomic) XLFormSectionDescriptor *paymentTypeSection;

@end

@implementation FiltersFormViewController

- (id)init {
    self = [super init];
    [self setupDefaults];
    if (self) {
        [self initializeForm];
        [self fetchBudgets];
        [self fetchPaymentTypes];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self customizeAppearance];
}


#pragma mark - Setup

- (void)setupNavigationBar {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancel;

    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    self.navigationItem.rightBarButtonItem = filter;
}

#pragma mark - Navigation Actions

- (void)onFilter {
    [self.delegate filtersFormViewController:self didChangeFilters:self.formValues];
    NSLog(@"Filters: %@", self.formValues);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Form Setup Methods

- (void)initializeForm {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Filters"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    formDescriptor.assignFirstResponderOnShow = YES;

    // ---- Transaction Types ---- //
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Transaction Type"];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFutures rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Show Future Transactions"];
    [row.cellConfigAtConfigure setObject:[UIColor inputColor] forKey:@"backgroundColor"];
    [row.cellConfigAtConfigure setObject:[UIColor whiteColor] forKey:@"tintColor"];
    [row.cellConfig setObject:[UIColor whiteColor] forKey:@"textLabel.textColor"];

    row.value = self.defaults[kFutures];
    [section addFormRow:row];
    [formDescriptor addFormSection:section];

    // ---- Payment Type Section Holder ---- //
    self.paymentTypeSection = [XLFormSectionDescriptor formSectionWithTitle:@"Payment Type"];
    [formDescriptor addFormSection:self.paymentTypeSection];

    // ---- Budgets Section Holder ---- //
    self.budgetsSection = [XLFormSectionDescriptor formSectionWithTitle:@"Budgets"];
    [formDescriptor addFormSection:self.budgetsSection];

    self.form = formDescriptor;
}

- (void)addBudgetsToForm:(NSArray *) budgets {
    XLFormRowDescriptor * row;

    if (budgets.count > 0) {
        for (Budget *budget in budgets) {
            NSString *tag = [NSString stringWithFormat:@"budget_%@", budget.objectId];
            row = [XLFormRowDescriptor formRowDescriptorWithTag:tag rowType:XLFormRowDescriptorTypeBooleanCheck title:budget.name];
            row.value = @YES;
            [row.cellConfigAtConfigure setObject:[UIColor inputColor] forKey:@"backgroundColor"];
            [row.cellConfigAtConfigure setObject:[UIColor whiteColor] forKey:@"tintColor"];
            [row.cellConfig setObject:[UIColor whiteColor] forKey:@"textLabel.textColor"];

            [self.budgetsSection addFormRow:row];
        }
    }
}

- (void)addPaymentTypesToForm:(NSArray *) paymentTypes {
    XLFormRowDescriptor * row;

    if (paymentTypes.count > 0) {
        for (PaymentType *paymentType in paymentTypes) {
            NSString *tag = [NSString stringWithFormat:@"paymentType_%@", paymentType.objectId];
            row = [XLFormRowDescriptor formRowDescriptorWithTag:tag rowType:XLFormRowDescriptorTypeBooleanCheck title:paymentType.name];
            row.value = @YES;
            [row.cellConfigAtConfigure setObject:[UIColor inputColor] forKey:@"backgroundColor"];
            [row.cellConfigAtConfigure setObject:[UIColor whiteColor] forKey:@"tintColor"];
            [row.cellConfig setObject:[UIColor whiteColor] forKey:@"textLabel.textColor"];

            [self.paymentTypeSection addFormRow:row];
        }
    }
}

#pragma mark - Model Methods

- (void)fetchBudgets {
    [Budget budgets:^(NSArray *budgets, NSError *error) {
        if (budgets) {
            [self addBudgetsToForm:budgets];
        } else if (error) {
            NSLog(@"Error fetching budgets");
        }
    }];
}

- (void)fetchPaymentTypes {
    [PaymentType paymentTypes:^(NSArray *paymentTypes, NSError *error) {
        if (paymentTypes) {
            [self addPaymentTypesToForm:paymentTypes];
            NSLog(@"%@", paymentTypes);
        }
    }];
}

- (void)setupDefaults {
    self.defaults = @{kFutures:@YES};
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

-(void)customizeAppearance
{
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
}



@end
