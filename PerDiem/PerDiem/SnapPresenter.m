//
//  SnapPresenter.m
//  PerDiem
//
//  Created by Florent Bonomo on 12/8/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "SnapPresenter.h"
#import <IRLDocumentScanner/IRLScannerViewController.h>
#import <TesseractOCR/TesseractOCR.h>
#import "NSString+Regexer.h"
#import "TransactionFormViewController.h"
#import "Transaction.h"
#import "NavigationViewController.h"

@interface SnapPresenter () <IRLScannerViewControllerDelegate, G8TesseractDelegate>

@property (nonatomic, strong) UIViewController *controller;

@end

@implementation SnapPresenter

- (id)initWithViewController:(UIViewController *)controller {
    if (self = [super init]) {
        self.controller = controller;
    }
    return self;
}

- (void)present {
    IRLScannerViewController *scanner = [IRLScannerViewController standardCameraViewWithDelegate:self];
    scanner.showControls = YES;
    scanner.showAutoFocusWhiteRectangle = YES;
    [self.controller presentViewController:scanner animated:YES completion:nil];
}


#pragma mark - IRLScannerViewControllerDelegate
    
- (void)pageSnapped:(UIImage *)pageImage from:(UIViewController *)controller {
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.delegate = self;
    tesseract.image = [pageImage g8_grayScale];
    tesseract.maximumRecognitionTime = 10.0;
    
    // Start the recognition
    [tesseract recognize];
    NSString *recognizedText = [tesseract recognizedText];
    
    NSArray *lines = [recognizedText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    lines = [lines filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    for (NSString *line in lines) {
        NSArray *patterns = @[
                              @"^(T(O|D|0)T(A|4)(L|1))(.*)$",
                              @"^(MASTERCARD|VISA)$",
                              @"^(WALGREENS|SAFEWAY)$"
                              ];
        for (NSString *pattern in patterns) {
            NSArray *matches = [line rx_matchesWithPattern:pattern];
            RXMatch *match = [matches firstObject];
            RXCapture *capture = [[match captures] objectAtIndex:0]; // Or: match[0]
            NSString *text = [capture text];
            NSRange range = [capture range];
            
            if (text != nil) {
                NSLog(@"%@", text);
                NSLog(@"--------------");
            }
        }
    }
    
    // Hardcoded for now!
    NSNumber *amount = @(14.13);
    NSString *storeString = @"WALGREENS";;
    
    Transaction *transaction = [[Transaction alloc] init];
    transaction.amount = amount;
    transaction.summary = storeString;
    transaction.transactionDate = [NSDate dateWithYear:2015 month:11 day:27];
    TransactionFormViewController *transactionFormController = [[TransactionFormViewController alloc] initWithTransaction:transaction];
    transactionFormController.delegate = self.controller;
    NavigationViewController *nvc = [[NavigationViewController alloc] initWithRootViewController:transactionFormController];
    [self.controller dismissViewControllerAnimated:NO completion:nil];
    [self.controller presentViewController:nvc animated:NO completion:nil];
}

- (NSString*)cameraViewWillUpdateTitleLabel:(IRLScannerViewController*)cameraView {
    return @"Scan your receipt";
}

- (void)cameraViewCancelRequested:(IRLScannerViewController *)cameraView {
    [cameraView dismissViewControllerAnimated:YES completion:nil];
}


@end
