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


+ (NSDictionary *)credentialsWithPassCode:(NSString *)passCode andError:(NSError *__autoreleasing *)error {

    NSData *encryptedData = nil;
    
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    encryptedData = [userDefaults objectForKey:@"encryptedData"];
    
#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    encryptedData = [keychain objectForKey:@"encryptedData"];
    
#endif
    
    NSData *data = [RNDecryptor decryptData:encryptedData
                               withSettings:kRNCryptorAES256Settings
                                   password:passCode
                                      error:error];
    
    NSDictionary *credentials = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];

    return credentials;
}

+ (BOOL)storeCredentials:(NSDictionary *)credentials withPassCode:(NSString *)passCode andError:(NSError *__autoreleasing *)error{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:credentials];
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:passCode
                                               error:error];
    
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encryptedData forKey:@"encryptedData"];
    [userDefaults synchronize];

#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    [keychain setObject:encryptedData forKey:@"encryptedData"];
    
#endif
    
    return YES;
}


@end
