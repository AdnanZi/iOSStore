//
//  AndroidStoreApi.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/6/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZSProduct.h"

@interface AZSiOSStoreApi : NSObject

- (void)getProducts:(void(^)(NSArray<AZSProduct *> *data))completionHandler;
- (void)getProductsWithCategory:(NSString *)category CompletionHandler: (void(^)(NSArray<AZSProduct *> *data))completionHandler;
- (void)getProductWithId:(NSInteger)id CompletionHandler: (void(^)(AZSProduct *data))completionHandler;
- (void)getCategories:(void(^)(NSArray<NSString *> *data))completionHandler;

@end
