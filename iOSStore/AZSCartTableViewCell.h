//
//  AZSCartTableViewCell.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/11/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZSCartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end
