//
//  EmailSender.m
//  iOSStore
//
//  Created by Adnan Zildzic on 4/27/16.
//  Copyright © 2016 flounderware. All rights reserved.
//

#import "AZSEmailSender.h"
#import <MailCore/MailCore.h>

@implementation AZSEmailSender

- (void)sendMail: (NSString *)body Subject: (NSString *)subject Addresses: (NSArray<NSString *> *)addresses Username: (NSString *)username Password: (NSString *)password CompletionHandler: (void(^)(BOOL success))completionHandler {

    MCOSMTPSession *session = [[MCOSMTPSession alloc]init];
    session.hostname = @"smtp.gmail.com";
    session.port = 465;
    session.username = username;
    session.password = password;
    session.connectionType = MCOConnectionTypeTLS;
    
    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc]init];
    
    [[builder header] setFrom:[MCOAddress addressWithMailbox:username]];
    
    NSMutableArray *to = [[NSMutableArray alloc]init];
    
    for (NSString *address in addresses) {
        MCOAddress *newAddress = [MCOAddress addressWithMailbox:address];
        [to addObject:newAddress];
    }
    
    [[builder header] setTo:to];
    
    [[builder header] setSubject:subject];
    [builder setTextBody:body];
    
    NSData *data = [builder data];
    
    MCOSMTPOperation *sendOperation = [session sendOperationWithData:data];
    [sendOperation start:^(NSError * _Nullable error) {
        BOOL success;
        
        if (error) {
            NSLog(@"Error while sending email: %@", [error localizedDescription]);
            success = NO;
        } else {
            success = YES;
        }
        
        completionHandler(success);
    }];
}

@end
