//
//  AZSCartController.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/11/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSCartViewController.h"
#import "AZSCartTableViewCell.h"
#import "AZSControllerHelper.h"
#import "AZSGeneralHelper.h"

@interface AZSCartViewController ()

@end

@implementation AZSCartViewController {
    NSArray<AZSCartLine *> *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = self.cartTableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
   _dataSource = [[AZSCart instance] getCart];
    
    [tableView reloadData];
    
    self.totalLabel.text = [AZSGeneralHelper priceWithCurrency:[[AZSCart instance] computeTotalValue].stringValue];
    
    CGRect frame = self.cartTableView.frame;
    self.cartTableView.frame = frame;
}

- (void)viewWillLayoutSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect tableFrame = self.cartTableView.frame;
        tableFrame.size.height = self.cartTableView.contentSize.height;
        self.cartTableView.frame = tableFrame;
        
        CGRect totalStackFrame = self.totalStackView.frame;
        totalStackFrame.origin.y = self.cartTableView.frame.origin.y + self.cartTableView.frame.size.height;
        self.totalStackView.frame = totalStackFrame;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)removeClicked:(id)sender {
    UIView *button = (UIView *)sender;
    
    [[AZSCart instance] removeFromCart:[button tag]];
    
    [self recreateTable];
}

- (void)recreateTable {
    _dataSource = [[AZSCart instance] getCart];
    [self.cartTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AZSCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier2" forIndexPath:indexPath];
    
    AZSCartLine *currentLine = [_dataSource objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.itemLabel.text  = [NSString stringWithFormat:@"%@ (%ld)", [currentLine getProduct].productName, currentLine.getQuantity];
    
    cell.priceLabel.text = [AZSGeneralHelper priceWithCurrency:[currentLine getProduct].price.stringValue];
    cell.removeButton.tag = [currentLine getProduct].ID;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"checkout"] && [[[AZSCart instance] getCart] count] == 0) {
        [AZSControllerHelper showAlertMessage:@"Cart is empty. Please add some items prior to Checkout." Duration:3 Controller:self];
        
        return;
    }
}

@end
