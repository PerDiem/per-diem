//
//  FormOptionsViewController.m
//  PerDiem
//
//  Created by Francisco Rojas Gallegos on 12/7/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "FormOptionsViewController.h"
#import "UIColor+PerDiem.h"

@interface FormOptionsViewController ()

@end

@implementation FormOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)customizeAppearance
{
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView: tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor inputColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}
@end

