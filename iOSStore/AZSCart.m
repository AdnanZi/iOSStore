//
//  Cart.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/5/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSCart.h"
#import "AZSProduct.h"
#import "AZSGeneralHelper.h"

@interface AZSCartLine(CartLineAdditions)

- (instancetype)initWithProductAnd:(AZSProduct *)product Quantity:(NSInteger)quantity;
- (void)incrementQuantity;

@end

@implementation AZSCart {
    NSMutableDictionary<NSNumber *, AZSCartLine *> *_lines;
}

- (instancetype)initCart
{
    self = [super init];
    if (self) {
        _lines = [[NSMutableDictionary alloc]init];
    }
    return self;
}

+ (AZSCart *)instance {
    static AZSCart *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[AZSCart alloc] initCart];
    });
    
    return instance;
}

- (void)addToCart:(AZSProduct *)product {
    if (product == nil) {
        return;
    }
    
    if ([_lines objectForKey:[NSNumber numberWithInteger:product.ID]] != nil) {
        AZSCartLine *line = [_lines objectForKey:[NSNumber numberWithInteger:product.ID]];
        [line incrementQuantity];
    } else {
        AZSCartLine *line = [AZSCartLine alloc];
        line = [line initWithProductAnd:product Quantity:1];
        
        [_lines setObject: [[AZSCartLine alloc]initWithProductAnd:product Quantity:1] forKey:[NSNumber numberWithInteger:product.ID]];
    }
}

- (void)removeFromCart:(NSInteger)productId {
    if ([_lines objectForKey:[NSNumber numberWithInteger:productId]] != nil) {
        [_lines removeObjectForKey:[NSNumber numberWithInteger:productId]];
    }
}

- (NSArray<AZSCartLine *> *)getCart{
//    NSMutableArray<AZSCartLine *> *lines = [[NSMutableArray alloc]init];
//    
//    [_lines enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, AZSCartLine * _Nonnull obj, BOOL * _Nonnull stop) {
//        [lines addObject:obj];
//    }];
//    
//    return lines;
    return _lines.allValues;
}

- (void)clearCart {
    if (_lines != nil) {
        [_lines removeAllObjects];
    }
}

- (NSNumber *)computeTotalValue {
    __block double value = 0;
    
    [_lines enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, AZSCartLine * _Nonnull obj, BOOL * _Nonnull stop) {
        value += [[obj getProduct].price doubleValue] * [obj getQuantity];
    }];
    
    return [NSNumber numberWithDouble:value];
}

- (NSString *)cartLinesToString {
    __block NSMutableString* value = [[NSMutableString alloc]init];
    
    [_lines enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, AZSCartLine * _Nonnull obj, BOOL * _Nonnull stop) {
        float price = [[obj getProduct].price floatValue] * [obj getQuantity];
        
        [value appendString: [NSString stringWithFormat:@"\n%@ (%ld) \t %@",
                              [obj getProduct].productName,
                              [obj getQuantity],
                              [AZSGeneralHelper priceWithCurrency:[NSNumber numberWithFloat:price].stringValue]]];
    }];
    
    [value appendString:@"\n"];
    [value appendString:[NSString stringWithFormat:@"\nTotal order value: %@", [AZSGeneralHelper priceWithCurrency:self.computeTotalValue.stringValue]]];
    
    return value;
}

@end

@implementation AZSCartLine {
    AZSProduct *_product;
    NSInteger _quantity;
}

- (AZSProduct *)getProduct {
    return _product;
}

- (NSInteger)getQuantity {
    return _quantity;
}

@end

@implementation AZSCartLine(CartLineAdditions)

- (instancetype)initWithProductAnd:(AZSProduct *)product Quantity:(NSInteger)quantity {
    self = [super init];
    if (self) {
        _product = product;
        _quantity = quantity;
    }
    return self;
}

- (void)incrementQuantity {
    _quantity++;
}

@end

