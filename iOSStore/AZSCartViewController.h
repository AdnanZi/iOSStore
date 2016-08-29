//
//  AZSCartController.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/11/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AZSCart.h"

@interface AZSCartViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (weak, nonatomic) IBOutlet UIStackView *totalStackView;
@end
