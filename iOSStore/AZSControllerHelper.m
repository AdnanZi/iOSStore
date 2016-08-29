//
//  ControllerHelper.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/11/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSControllerHelper.h"
#import "AZSProductTableViewCell.h"
#import "AZSiOSStoreApi.h"
#import "AZSCart.h"
#import <UIKit/UIKit.h>

@implementation AZSControllerHelper

+ (void)showAlertMessage:(NSString *)message Duration:(NSInteger)duration Controller:(UIViewController *)controller {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [controller presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

+ (UIActivityIndicatorView *)getProgressIndicator:(UIViewController *)controller {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.color = [UIColor blueColor];
    indicator.center = controller.view.center;
    [controller.view addSubview:indicator];
    
    return indicator;
}

+ (void)addButtonClicked:(id)sender Controller:(UIViewController *)controller StoreApi:(AZSiOSStoreApi *)productApi {
    AZSProductTableViewCell *cell = (AZSProductTableViewCell *)sender;
    
    UIActivityIndicatorView *indicator = [self getProgressIndicator:controller];
    [indicator startAnimating];
    
    [productApi getProductWithId:[cell tag] CompletionHandler:^(AZSProduct *product) {
        if (product == nil) {
            [indicator stopAnimating];
            
            [self showAlertMessage:@"Something went wrong. Please enable network connection or try again later." Duration:10 Controller:controller];
            return;
        }
        
        [[AZSCart instance] addToCart:product];
        
        [indicator stopAnimating];
    }];
}

@end
