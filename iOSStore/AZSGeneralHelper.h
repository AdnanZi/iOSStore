//
//  AZSGeneralHelper.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/28/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZSGeneralHelper : NSObject

+ (NSString *)priceWithCurrency:(NSString *)price;

+ (NSDictionary *)getConfiguration;

@end
