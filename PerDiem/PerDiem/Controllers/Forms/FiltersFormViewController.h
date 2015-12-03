//
//  FiltersFormViewController.h
//  PerDiem
//
//  Created by Chad Jewsbury on 11/24/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "XLFormViewController.h"

@class FiltersFormViewController;

@protocol FiltersFormViewControllerDelegate <NSObject>

- (void)filtersFormViewController:(FiltersFormViewController *)filtersFormViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FiltersFormViewController : XLFormViewController

@property (nonatomic, weak) id<FiltersFormViewControllerDelegate> delegate;

@end
