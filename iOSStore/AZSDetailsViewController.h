//
//  DetailsViewController.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/7/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZSDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (void)setProductId:(NSInteger)productId;

@end
