//
//  EmailSender.h
//  iOSStore
//
//  Created by Adnan Zildzic on 4/27/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZSEmailSender : NSObject

- (void)sendMail: (NSString *)body Subject: (NSString *)subject Addresses: (NSArray<NSString *> *)addresses Username: (NSString *)username Password: (NSString *)password CompletionHandler: (void(^)(BOOL success))completionHandler;

@end
