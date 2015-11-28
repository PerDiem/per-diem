//
//  SnapReceiptViewController.m
//  PerDiem
//
//  Created by Florent Bonomo on 11/27/15.
//  Copyright © 2015 PerDiem. All rights reserved.
//

#import "SnapReceiptViewController.h"
#import <IRLDocumentScanner/IRLScannerViewController.h>
#import <TesseractOCR/TesseractOCR.h>

@interface SnapReceiptViewController () <IRLScannerViewControllerDelegate, G8TesseractDelegate>

@end

@implementation SnapReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IRLScannerViewController *scanner = [IRLScannerViewController standardCameraViewWithDelegate:self];
    scanner.showControls = YES;
    scanner.showAutoFocusWhiteRectangle = YES;
    [self presentViewController:scanner animated:YES completion:nil];
}


#pragma mark - IRLScannerViewControllerDelegate

- (void)pageSnapped:(UIImage *)page_image from:(UIViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        tesseract.delegate = self;
//        tesseract.charWhitelist = @"0123456789";
        tesseract.image = [page_image g8_blackAndWhite];
        tesseract.maximumRecognitionTime = 10.0;
        
        // Start the recognition
        [tesseract recognize];
        
        // Retrieve the recognized text
        NSLog(@"%@", [tesseract recognizedText]);
        
        // You could retrieve more information about recognized text with that methods:
        NSArray *characterBoxes = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];
        NSArray *paragraphs = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelParagraph];
        NSArray *characterChoices = tesseract.characterChoices;
        UIImage *imageWithBlocks = [tesseract imageWithBlocks:characterBoxes drawText:YES thresholded:NO];
    }];
}

- (NSString*)cameraViewWillUpdateTitleLabel:(IRLScannerViewController*)cameraView {
    return @"Scan your receipt";
}

- (void)cameraViewCancelRequested:(IRLScannerViewController *)cameraView {
    [cameraView dismissViewControllerAnimated:YES completion:nil];
}

@end
