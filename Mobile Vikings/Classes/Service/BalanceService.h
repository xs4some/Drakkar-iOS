//
//  BalanceService.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 15-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MKNetworkOperation.h"

@interface BalanceService : MKNetworkOperation

- (id)initServiceWithToken:(NSString *)token;
- (void)balanceCompletionBlock:(void(^)(NSDictionary *balance))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
