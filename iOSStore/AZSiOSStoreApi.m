//
//  AndroidStoreApi.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/6/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSiOSStoreApi.h"
#import <UIKit/UIKit.h>
#import "AZSGeneralHelper.h"

@implementation AZSiOSStoreApi {
    NSArray<AZSProduct *> *_products;
    NSMutableArray<NSString *> *_categories;
}

- (void)getProducts:(void(^)(NSArray<AZSProduct *> *data))completionHandler {
    if (_products != nil && _products.count > 0) {
        completionHandler(_products);
    }
    
    NSString *url = [self getUrlForEndpoint:@"MobileStoreGetProductsEndpoint"];
    
    if (url == nil) {
        completionHandler(nil);
        return;
    }
    
    [self getAndParseData:url CompletionHandler:completionHandler ParseBlock:^(NSArray *jsonArray){
        _products = [self parseProducts:jsonArray];
        
        completionHandler(_products);
    }];
}

- (void)getProductsWithCategory:(NSString *)category CompletionHandler: (void(^)(NSArray<AZSProduct *> *data))completionHandler {
    
    if (_products != nil && _products.count > 0) {
        completionHandler([_products filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"categoryName==%@", category]]);
        return;
    }
    
    NSString *url = [NSString stringWithFormat:[self getUrlForEndpoint:@"MobileStoreGetByCategoryEndpoint"], category];
    
    if (url == nil) {
        completionHandler(nil);
        return;
    }
    
    [self getAndParseData:url CompletionHandler:completionHandler ParseBlock:^(NSArray *jsonArray) {
        NSArray<AZSProduct *> *products = [self parseProducts:jsonArray];
        
        completionHandler(products);
    }];
}

- (void)getProductWithId:(NSInteger)productId CompletionHandler: (void(^)(AZSProduct *data))completionHandler {
    if (_products != nil && _products.count > 0) {
        NSUInteger index = [_products indexOfObjectPassingTest:^BOOL(AZSProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ID == productId;
        }];
    
        completionHandler(_products[index]);
        return;
    }
    
    NSString *url = [NSString stringWithFormat:[self getUrlForEndpoint:@"MobileStoreGetProductByIdEndpoint"], productId];
    
    if (url == nil) {
        completionHandler(nil);
        return;
    }
    
    [self getAndParseData:url CompletionHandler:completionHandler ParseBlock:^(NSDictionary *jsonData) {
        AZSProduct *product = [self parseProduct:jsonData];
        
        completionHandler(product);
    }];
}

- (void)getCategories:(void(^)(NSArray<NSString *> *data))completionHandler {
    
    if (_categories != nil && _categories.count > 0) {
        completionHandler(_categories);
        return;
    }
    
    NSString *url = [self getUrlForEndpoint:@"MobileStoreGetCategoriesEndpoint"];
    
    if (url == nil) {
        completionHandler(nil);
        return;
    }
    
    [self getAndParseData:url CompletionHandler:completionHandler ParseBlock:^(NSArray *jsonArray){
        _categories = [[NSMutableArray alloc]init];
        
        for (NSString *category in jsonArray) {
            [_categories addObject:category];
        }
        
        completionHandler(_categories);
    }];
}

#pragma mark - Private methods

- (NSString *)getUrlForEndpoint:(NSString *)endpointConfigurationKey {
    NSDictionary *configuration = [AZSGeneralHelper getConfiguration];
    
    if (configuration == nil)
    {
        NSLog(@"Configuration could not be retrieved.");
        return nil;
    }
    
    NSString *endpoint = [NSString stringWithFormat:@"%@%@", [configuration valueForKey:@"MobileStoreHost"], [configuration valueForKey:endpointConfigurationKey]];
    
    if ([endpoint length] == 0) {
        NSLog(@"GetCategories endpoint could not be retrieved from configuration.");
        return nil;
    }
    
    return endpoint;
}

- (void)getAndParseData:(NSString *)url CompletionHandler:(void(^)(id data))completionHandler ParseBlock:(void(^)(id jsonData))parseBlock {
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"Could not retrieve data: %@", [error localizedDescription]);
            completionHandler(nil);
            
        } else if (((NSHTTPURLResponse *)response).statusCode == 200) {
            
            NSError *jsonError;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (jsonError != nil) {
                NSLog(@"Could not parse JSON response: %@", [error localizedDescription]);
                completionHandler(nil);
            }
            
            parseBlock(jsonData);
            
            return;
        } else {
            completionHandler(nil);
        }
    }];
    
    [dataTask resume];
}
             
- (NSArray<AZSProduct *> *)parseProducts:(NSArray *)jsonArray {
    NSMutableArray<AZSProduct *> *products = [[NSMutableArray alloc]init];
    
    for (NSDictionary *entry in jsonArray) {
        AZSProduct *product = [self parseProduct:entry];
        
        [products addObject:product];
    }
    
    return products;
}

- (AZSProduct *)parseProduct:(NSDictionary *)jsonArrayEntry {
    AZSProduct *product = [[AZSProduct alloc]init];
    
    product.ID = [(NSNumber *)jsonArrayEntry[@"ID"] longValue];
    product.productName = jsonArrayEntry[@"Name"];
    product.productDescription = jsonArrayEntry[@"Description"];
    product.categoryName = jsonArrayEntry[@"Category"];
    product.price = jsonArrayEntry[@"Price"];
    
    product.image = [[NSData alloc]initWithBase64EncodedString:jsonArrayEntry[@"Image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return product;
}

@end
