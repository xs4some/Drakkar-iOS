//
//  MVRegisterService.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 14-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkOperation.h"

@interface MVRegisterService : MKNetworkOperation

// The actual login
- (id)initServiceWithUserName:(NSString *)userName passWord:(NSString *)passWord;
- (void)registerCompletionBlock:(void(^)(void))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
