//
//  TransactionFormViewController.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 11/21/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "TransactionFormViewController.h"
#import "XLForm.h"

NSString *const kSummary = @"summary";
NSString *const kAmount = @"amount";
//NSString *const kDate = @"transactionDate";


@interface TransactionFormViewController ()

@end

@implementation TransactionFormViewController


-(id)init
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    formDescriptor.assignFirstResponderOnShow = YES;

    // Summary
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kSummary rowType:XLFormRowDescriptorTypeText title:@"Summary"];
    row.required = YES;
    [section addFormRow:row];

    // Number
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAmount rowType:XLFormRowDescriptorTypeNumber title:@"Amount"];
    [section addFormRow:row];

    return [super initWithForm:formDescriptor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
