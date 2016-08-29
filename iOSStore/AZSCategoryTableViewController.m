//
//  CategoryTableViewController.m
//  iOSStore
//
//  Created by Adnan Zildzic on 3/16/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSCategoryTableViewController.h"
#import "AZSProductTableViewController.h"
#import "AZSiOSStoreApi.h"
#import "AZSCart.h"
#import "AZSControllerHelper.h"

@interface AZSCategoryTableViewController ()

@end

@implementation AZSCategoryTableViewController {
    AZSiOSStoreApi *_productApi;
    NSMutableArray *_dataSource;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _productApi = [[AZSiOSStoreApi alloc]init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc]init];
    
    [self getCategories];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCategories {
    UIActivityIndicatorView *indicator = [AZSControllerHelper getProgressIndicator:self];
    [indicator startAnimating];
    
    [_productApi getCategories:^(NSArray<NSString *> *data) {
        
        if (data == nil) {
            [indicator stopAnimating];
            
            [AZSControllerHelper showAlertMessage:@"Something went wrong. Please enable network connection or try again later." Duration:10 Controller:self];
            return;
        }
        
        [_dataSource addObject:@"All"];
        [_dataSource addObjectsFromArray:data];
        
        [self.tableView reloadData];
        [indicator stopAnimating];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categorySelect"]) {
        NSString *selectedCategory = ((UITableViewCell *)sender).textLabel.text;
        
        AZSProductTableViewController *destinationController = [segue destinationViewController];
        [destinationController setCategory:selectedCategory];
        
    } else if ([segue.identifier isEqualToString:@"categoryCheckout"] && [[[AZSCart instance] getCart] count] == 0) {
        
        [AZSControllerHelper showAlertMessage:@"Cart is empty. Please add some items prior to Checkout." Duration:3 Controller:self];
        
        return;
    }
}

@end
