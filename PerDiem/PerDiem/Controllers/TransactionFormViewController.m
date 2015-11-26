//
//  TransactionFormViewController.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionFormViewController.h"
#import "XLForm.h"
#import "User.h"
#import "Budget.h"
#import "Transaction.h"

NSString *const kSummary = @"summary";
NSString *const kAmount = @"amount";
NSString *const kDate = @"transactionDate";
NSString *const kDescription = @"description";
NSString *const kBudget = @"selectorPush";
NSString *const kFuture = @"future";


@interface TransactionFormViewController ()

@property(strong, nonatomic) Transaction *transaction;

@end

@implementation TransactionFormViewController

-(id)init
{
    return [self setup:[Transaction object]];
}

-(id) initWithTransaction: (Transaction*) transaction {

    return [self setup: transaction];
}

-(id) setup: (Transaction*) transaction {
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Transaction"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    formDescriptor.assignFirstResponderOnShow = YES;

    self.transaction = transaction;

    // Basic Information - Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Transaction"];
    [formDescriptor addFormSection:section];

    // Summary
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSummary rowType:XLFormRowDescriptorTypeText title:@"Summary"];
    row.required = YES;
    row.value = transaction.summary;
    [section addFormRow:row];

    // Number
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAmount rowType:XLFormRowDescriptorTypeDecimal title:@"Amount"];
    row.required = YES;
    row.value = transaction.amount;
    [section addFormRow:row];


    // Selector Push
    XLFormRowDescriptor *budgetRow = [XLFormRowDescriptor formRowDescriptorWithTag:kBudget rowType:XLFormRowDescriptorTypeSelectorPush title:@"Budget"];
    budgetRow.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:nil displayText:@"asdsada"]];
    [[User currentUser] budgets:^(NSArray *budgets, NSError *error) {
        NSMutableArray *options = [NSMutableArray array];
        for (Budget *budget in budgets) {
            [options addObject:[XLFormOptionsObject formOptionsObjectWithValue:budget displayText:budget.name ]];
        }

        if ( options.count > 1) {
            XLFormRowDescriptor * row = [self.form formRowWithTag:kBudget];
            row.selectorOptions = options;
        } else if (options.count == 1) {
            budgetRow.value = options[0];
            [budgetRow setDisabled:@(YES)];
        } else {
            // @todo - Transactions need to have a budget. We should throw an error here or create a default budget when signing up so it can never happen.
            [budgetRow setDisabled:@(YES)];
        }

        [self reloadFormRow:budgetRow];
    }];

    // TODO: Maybe we should put a default budget?
    if (transaction.budget) {
        row.value = [XLFormOptionsObject formOptionsObjectWithValue:transaction.budget displayText:transaction.budget.name];
    }
    [section addFormRow:budgetRow];

    // Date
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDate rowType:XLFormRowDescriptorTypeDateInline title:@"Date"];
    if ( transaction.transactionDate) {
        row.value = transaction.transactionDate;
    } else {
        row.value = [NSDate new];
    }

    [section addFormRow:row];

    // Future
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFuture rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Future Transaction"];
    row.required = NO;
    [section addFormRow: row];

    //Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kDescription rowType:XLFormRowDescriptorTypeTextView title:@"Description"];
    if (transaction.note) {
        row.value = transaction.note;
    }

    [section addFormRow:row];

    return [super initWithForm:formDescriptor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];

}
-(void)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];

    NSDictionary *values = [self formValues];
    User *user = [User currentUser];
    self.transaction.user = user;
    self.transaction.organization = user.organization;
    self.transaction.summary = values[kSummary];
    self.transaction.amount = values[kAmount];
    if (values[kBudget]) {
        self.transaction.budget = [values[kBudget] formValue];
    }
    self.transaction.note = values[kDescription];
    self.transaction.transactionDate = values[kDate];
    self.transaction.future = values[kFuture];
    [self.transaction saveInBackground];

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
