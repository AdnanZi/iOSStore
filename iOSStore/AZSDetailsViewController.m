//
//  DetailsViewController.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/7/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSDetailsViewController.h"
#import "AZSiOSStoreApi.h"
#import "AZSCart.h"
#import "AZSControllerHelper.h"
#import "AZSGeneralHelper.h"

@interface AZSDetailsViewController ()

@end

@implementation AZSDetailsViewController {
    NSInteger _productId;
    AZSiOSStoreApi *_productApi;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _productApi = [[AZSiOSStoreApi alloc]init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIActivityIndicatorView *indicator = [AZSControllerHelper getProgressIndicator:self];
    [indicator startAnimating];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [_productApi getProductWithId:_productId CompletionHandler:^(AZSProduct *product) {
        
        
        if (product == nil) {
            [indicator stopAnimating];
            
            [AZSControllerHelper showAlertMessage:@"Something went wrong. Please enable network connection or try again later." Duration:10 Controller:self];
            return;
        }
        
        self.productName.text = product.productName;
        self.productDescription.text = product.productDescription;
        self.productPrice.text = [AZSGeneralHelper priceWithCurrency:product.price.stringValue];
        self.productImage.image = [UIImage imageWithData:product.image];
        self.addButton.tag = product.ID;
        
        [indicator stopAnimating];
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)viewWillAppear:(BOOL)animated {
    animated = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProductId:(NSInteger)productId {
    _productId = productId;
}

- (IBAction)addClicked:(id)sender {
    [AZSControllerHelper addButtonClicked:sender Controller:self StoreApi:_productApi];
}

@end
