//
//  AZSCheckoutViewController.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/15/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AZSCheckoutViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *addressLineTextBox;
@property (weak, nonatomic) IBOutlet UITextField *cityTextBox;
@property (weak, nonatomic) IBOutlet UITextField *zipTextBox;
@property (weak, nonatomic) IBOutlet UITextField *stateTextBox;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UISwitch *useAddressSwitch;
@property (weak, nonatomic) IBOutlet UIStackView *addressStackView;
@property (weak, nonatomic) IBOutlet UILabel *validationMessageLabel;

@end
