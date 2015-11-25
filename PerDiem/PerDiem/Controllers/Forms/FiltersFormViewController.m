//
//  FiltersFormViewController.m
//  PerDiem
//
//  Created by Chad Jewsbury on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "FiltersFormViewController.h"
#import "XLForm.h"

NSString *const kFutures = @"futures";

@interface FiltersFormViewController ()

@property (strong, nonatomic) NSDictionary *defaults;

@end

@implementation FiltersFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)init {
    [self setupDefaults];

    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Budget"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    formDescriptor.assignFirstResponderOnShow = YES;

    section = [XLFormSectionDescriptor formSectionWithTitle:@"Futures"];
    [formDescriptor addFormSection:section];

    // Summary
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kFutures rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Include Futures"];
    row.value = self.defaults[kFutures];
    [section addFormRow:row];

    return [super initWithForm:formDescriptor];
}

- (void)setupDefaults {
    self.defaults = @{kFutures:@YES};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
