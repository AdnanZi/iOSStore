//
//  AZSGeneralHelper.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/28/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSGeneralHelper.h"

@implementation AZSGeneralHelper

+ (NSString *)priceWithCurrency:(NSString *)price {
    // TODO: Get currency from configuration
    return [NSString stringWithFormat: @"$%@", price];
}

+ (NSDictionary *)getConfiguration {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    
    if (path == nil) {
        return nil;
    }
    
    return [[NSDictionary alloc]initWithContentsOfFile:path];
}

@end
