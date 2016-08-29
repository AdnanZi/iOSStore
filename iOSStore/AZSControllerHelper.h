//
//  ControllerHelper.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/11/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AZSiOSStoreApi.h"

@interface AZSControllerHelper : NSObject

+ (void)showAlertMessage:(NSString *)message Duration:(NSInteger)duration Controller:(UIViewController *)controller;

+ (UIActivityIndicatorView *)getProgressIndicator:(UIViewController *)controller;

+ (void)addButtonClicked:(id)sender Controller:(UIViewController *)controller StoreApi:(AZSiOSStoreApi *)productApi;

@end
