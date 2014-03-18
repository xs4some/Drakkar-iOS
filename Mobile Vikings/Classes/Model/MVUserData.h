//
//  MVUserData.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 01/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVUserData : NSObject

+ (NSDictionary *)credentialsWithPassCode:(NSString *)passCode andError:(NSError **)error;
+ (BOOL)storeCredentials:(NSDictionary *)credentials withPassCode:(NSString *)passCode andError:(NSError **)error;

@end
