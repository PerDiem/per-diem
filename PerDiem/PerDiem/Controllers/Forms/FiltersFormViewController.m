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
            row = [XLFormRowDescriptor formRowDescriptorWithTag:budget.name rowType:XLFormRowDescriptorTypeBooleanCheck title:budget.name];
            // change to use nsuser defaults?
            // row.value = self.defaults[kBudgets][budget.name];
            row.value = @YES;
            [self.budgetsSection addFormRow:row];
        }
    }
}

- (void)addPaymentTypesToForm:(NSArray *) paymentTypes {
    XLFormRowDescriptor * row;

    if (paymentTypes.count > 0) {
        NSMutableArray *selectorOptions = [@[] mutableCopy];

        for (PaymentType *paymentType in paymentTypes) {
            [selectorOptions addObject:[XLFormOptionsObject formOptionsObjectWithValue:paymentType.objectId displayText:paymentType.name]];
        }

        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"paymentType" rowType:XLFormRowDescriptorTypeMultipleSelector title:@"Payment Type"];

        row.selectorOptions = selectorOptions;
        [self.paymentTypeSection addFormRow:row];
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


@end
