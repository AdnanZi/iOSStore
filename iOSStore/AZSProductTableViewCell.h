//
//  ProductTableViewCell.h
//  iOSStore
//
//  Created by Adnan Zildzic on 3/17/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZSProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
