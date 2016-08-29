//
//  Product.h
//  iOSStore
//
//  Created by Adnan Zildzic on 3/17/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZSProduct : NSObject

@property NSInteger ID;
@property NSString *productName;
@property NSString *productDescription;
@property NSString *categoryName;
@property NSNumber *price;
@property NSData *image;

@end
