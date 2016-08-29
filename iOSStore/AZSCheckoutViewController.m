//
//  AZSCheckoutViewController.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/15/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSCheckoutViewController.h"
#import "AZSControllerHelper.h"
#import "AZSEmailSender.h"
#import "AZSCart.h"
#import "AZSGeneralHelper.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AZSCheckoutViewController ()

@end

@implementation AZSCheckoutViewController {
    NSString *_addressLabelDefaultText;
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    UIActivityIndicatorView *_locationIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameTextBox.delegate = self;
    self.addressLineTextBox.delegate = self;
    self.cityTextBox.delegate = self;
    self.stateTextBox.delegate = self;
    self.zipTextBox.delegate = self;
    
    _addressLabelDefaultText = @"Unavailable";
    
    self.addressStackView.hidden = YES;
    self.useAddressSwitch.enabled = NO;
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([_locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _geocoder = [[CLGeocoder alloc]init];
    _locationIndicator = [AZSControllerHelper getProgressIndicator:self];
    
    [_locationIndicator startAnimating];
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

// Hides keyboard on return/done
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Hides keyboard on touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location could not be found: %@", [error localizedDescription]);
    
    [self handleLocationError];
    [_locationIndicator stopAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    [_locationManager stopUpdatingLocation]; // Quit updating location if location is retrieved
    
    [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error != nil || placemarks.count <= 0) {
            [self handleLocationError];
            [_locationIndicator stopAnimating];
            return;
        }
        
        [self handleLocationSuccess:[placemarks lastObject]];
        
        [_locationIndicator stopAnimating];
    }];
}

- (void)handleLocationError {
    self.addressStackView.hidden = NO;
    self.useAddressSwitch.enabled = NO;
    self.addressLabel.text = _addressLabelDefaultText;
}

- (void)handleLocationSuccess:(CLPlacemark *)placemark {
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.thoroughfare
                              , placemark.locality, placemark.postalCode, placemark.country];
    
    self.useAddressSwitch.enabled = YES;
    [self.useAddressSwitch setOn:YES animated: YES];
    self.addressStackView.hidden = YES;
}

- (IBAction)completeOrderClicked:(id)sender {
    if (!self.validationMessageLabel.isHidden) {
        self.validationMessageLabel.hidden = YES;
    }
    
    if (![self isValid]) {
        self.validationMessageLabel.hidden = NO;
        [self.validationMessageLabel becomeFirstResponder];
        
        return;
    }
    
    NSDictionary *configuration = [AZSGeneralHelper getConfiguration];
    
    if (configuration == nil) {
        NSLog(@"Configuration could not be retrieved.");
        [AZSControllerHelper showAlertMessage:@"Something went wrong. Please try again later." Duration:10 Controller:self];
    }
    
    AZSEmailSender *emailSender = [[AZSEmailSender alloc]init];
    
    UIActivityIndicatorView *completeIndicator = [AZSControllerHelper getProgressIndicator:self];
    [completeIndicator startAnimating];
    
    [emailSender sendMail:[self createEmailBody] Subject:@"New order" Addresses:@[[configuration valueForKey:@"EmailAddress"]] Username:[configuration valueForKey:@"EmailUsername"] Password:[configuration valueForKey:@"EmailPassword"] CompletionHandler:^(BOOL success) {
        
        [completeIndicator stopAnimating];
        
        if (!success) {
            [AZSControllerHelper showAlertMessage:@"Unable to complete order. Please enable network connection or try again later." Duration:10 Controller:self];
        } else {
            [[AZSCart instance] clearCart];
            
            UIViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompleteViewController"];
            
            [self.navigationController pushViewController:destinationController animated:YES];
        }
    }];
}
- (IBAction)useAddressSwitchCliked:(id)sender {
    if (self.useAddressSwitch.isOn == NO) {
        self.addressStackView.hidden = NO;
    } else {
        self.addressStackView.hidden = YES;
    }
}

- (BOOL)isValid {
    return !(([self.addressLabel.text isEqual: _addressLabelDefaultText] || [self.nameTextBox.text isEqual:@""] || self.useAddressSwitch.isOn == NO)
             && ([self.nameTextBox.text isEqual:@""] || [self.addressLineTextBox.text isEqual:@""] || [self.cityTextBox.text isEqual:@""] || [self.zipTextBox.text isEqual:@""] || [self.stateTextBox.text isEqual:@""]));
}

- (NSString *)createEmailBody {
    NSMutableString *body = [[NSMutableString alloc]init];
    
    [body appendString:@"New order\n"];
    [body appendString:@"\n"];
    [body appendString:@"\nItems:"];
    
    [body appendString: [[AZSCart instance] cartLinesToString]];
    
    [body appendString:@"\n"];
    [body appendString:@"\nShip to:"];
    
    [body appendString:[self shippingInfoToString]];
    
    return body;
}

- (NSString *)shippingInfoToString {
    NSMutableString *info = [[NSMutableString alloc]init];
    
    [info appendFormat:@"\n%@", self.nameTextBox.text];
    
    if (![self.addressLabel.text isEqual:_addressLabelDefaultText] && self.useAddressSwitch.isOn == YES) {
        [info appendFormat:@"\n%@", self.addressLabel.text];
    } else {
        [info appendFormat:@"\n%@, %@, %@, %@", self.addressLineTextBox.text, self.cityTextBox.text, self.zipTextBox.text, self.stateTextBox.text];
    }
    
    return info;
}

@end
