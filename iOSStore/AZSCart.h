//
//  Cart.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/5/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZSProduct.h"

@interface AZSCartLine : NSObject

- (AZSProduct *)getProduct;
- (NSInteger)getQuantity;

@end

@interface AZSCart : NSObject

/** Singleton method */
+ (AZSCart *)instance;

- (instancetype)init NS_UNAVAILABLE;
- (void)addToCart:(AZSProduct *)product;
- (void)removeFromCart:(NSInteger)productId;
- (NSArray<AZSCartLine *> *)getCart;
- (void)clearCart;
- (NSNumber *)computeTotalValue;
- (NSString *)cartLinesToString;

@end
