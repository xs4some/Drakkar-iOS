//
//  MVUserData.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 01/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVUserData.h"
#import <RNCryptor/RNEncryptor.h>
#import <RNCryptor/RNDecryptor.h>
#import <KeychainItemWrapper/KeychainItemWrapper.h>

@implementation MVUserData


+ (NSDictionary *)credentialsWithPassCode:(NSString *)passCode {

    NSData *encryptedData = nil;
    
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    encryptedData = [userDefaults objectForKey:@"encryptedData"];
    
#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    encryptedData = [keychain objectForKey:@"encryptedData"];
    
#endif
    
    NSError *error;
    NSData *data = [RNDecryptor decryptData:encryptedData
                               withSettings:kRNCryptorAES256Settings
                                   password:passCode
                                      error:&error];
    if (error != nil) {
        return nil;
    }
    
    NSDictionary *credentials = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];

    return credentials;
}

+ (BOOL)storeCredentials:(NSDictionary *)credentials withPassCode:(NSString *)passCode {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:credentials];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:passCode
                                               error:&error];
    
    if (error != nil) {
        return  NO;
    }
    
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encryptedData forKey:@"encryptedData"];

#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    [keychain setObject:encryptedData forKey:@"encryptedData"];
    
#endif
    
    return YES;
}


@end
