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

    NSData *encryptedUserName = nil;
    NSData *encryptedPassWord = nil;
    
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    encryptedUserName = [userDefaults objectForKey:@"encryptedUserName"];
    encryptedPassWord = [userDefaults objectForKey:@"encryptedPassWord"];
    
#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    encryptedUserName = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    encryptedPassWord = [keychain objectForKey:(__bridge id)kSecValueData];
    
#endif
    
    NSData *decryptedUserName = [RNDecryptor decryptData:encryptedUserName
                                            withSettings:kRNCryptorAES256Settings
                                                password:passCode
                                                   error:error];
    
    NSData *decryptedPassWord = [RNDecryptor decryptData:encryptedPassWord
                                            withSettings:kRNCryptorAES256Settings
                                                password:passCode
                                                   error:error];
    
    NSDictionary *credentials = @{@"userName" : [NSKeyedUnarchiver unarchiveObjectWithData:decryptedUserName],
                                  @"passWord" : [NSKeyedUnarchiver unarchiveObjectWithData:decryptedPassWord]};

    return credentials;
}

+ (BOOL)storeCredentials:(NSDictionary *)credentials withPassCode:(NSString *)passCode andError:(NSError *__autoreleasing *)error {
    NSData *userNameData = [NSKeyedArchiver archivedDataWithRootObject:[credentials objectForKey:@"userName"]];
    NSData *encryptedUserName = [RNEncryptor encryptData:userNameData
                                            withSettings:kRNCryptorAES256Settings
                                                password:passCode
                                                   error:error];

    NSData *passwordData = [NSKeyedArchiver archivedDataWithRootObject:[credentials objectForKey:@"passWord"]];
    NSData *encryptedPassword = [RNEncryptor encryptData:passwordData
                                            withSettings:kRNCryptorAES256Settings
                                                password:passCode
                                                   error:error];
    
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encryptedUserName forKey:@"encryptedUserName"];
    [userDefaults setObject:encryptedPassword forKey:@"encryptedPassWord"];
    
    [userDefaults synchronize];

#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    [keychain setObject:encryptedUserName forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:encryptedPassword forKey:(__bridge id)kSecValueData];
    
#endif
    
    return YES;
}


+ (void)removeCredentials {
#if TARGET_IPHONE_SIMULATOR
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"encryptedData"];
    [userDefaults synchronize];
    
#else
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
    [keychain resetKeychainItem];
    
#endif

}

@end
