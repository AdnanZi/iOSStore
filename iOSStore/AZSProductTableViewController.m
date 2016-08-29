//
//  ProductTableViewController.m
//  iOSStore
//
//  Created by Adnan Zildzic on 3/16/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSProductTableViewController.h"
#import "AZSProductTableViewCell.h"
#import "AZSProduct.h"
#import "AZSCart.h"
#import "AZSiOSStoreApi.h"
#import "AZSDetailsViewController.h"
#import "AZSControllerHelper.h"
#import "AZSGeneralHelper.h"

@interface AZSProductTableViewController ()

@end

@implementation AZSProductTableViewController {
    NSString *_category;
    AZSiOSStoreApi *_productApi;
    NSArray<AZSProduct *> *_dataSource;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _category = @"All";
    _productApi = [[AZSiOSStoreApi alloc]init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getProductsWithCategory: _category];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCategory:(NSString *)category {
    _category = category;
}

- (void)getProductsWithCategory:(NSString *)category {
    UIActivityIndicatorView *indicator = [AZSControllerHelper getProgressIndicator:self];
    
    void(^getProductsCompletionHandler)(NSArray<AZSProduct *> *data) = ^(NSArray<AZSProduct *> *data) {
        if (data == nil) {
            [indicator stopAnimating];
            
            [AZSControllerHelper showAlertMessage:@"Something went wrong. Please enable network connection or try again later." Duration:10 Controller:self];
            return;
        }
        
        _dataSource = data;
        
        [self.tableView reloadData];
        [indicator stopAnimating];
    };
    
    [indicator startAnimating];
    
    if ([_category  isEqual: @"All"]) {
        [_productApi getProducts:getProductsCompletionHandler];
    }
    
    [_productApi getProductsWithCategory:category CompletionHandler:getProductsCompletionHandler];
}

- (IBAction)addClicked:(id)sender {
    [AZSControllerHelper addButtonClicked:sender Controller:self StoreApi:_productApi];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AZSProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier1" forIndexPath:indexPath];
    
    AZSProduct *currentProduct = [_dataSource objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.productName.text = currentProduct.productName;
    cell.productPrice.text = [AZSGeneralHelper priceWithCurrency:currentProduct.price.stringValue];
    cell.productImage.image = [UIImage imageWithData:currentProduct.image];
    cell.detailsButton.tag = cell.addButton.tag = currentProduct.ID;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"productDetails"]) {
        NSInteger productId = ((UIView *)sender).tag;
        
        AZSDetailsViewController *destinationController = [segue destinationViewController];
        
        [destinationController setProductId:productId];
        
    } else if ([segue.identifier isEqualToString:@"productsCheckout"] && [[[AZSCart instance] getCart] count] == 0) {
        
        [AZSControllerHelper showAlertMessage:@"Cart is empty. Please add some items prior to Checkout." Duration:3 Controller:self];
        
        return;
    }
}

@end
