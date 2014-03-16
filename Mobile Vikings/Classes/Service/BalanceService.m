//
//  BalanceService.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 15-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#define kBalanceUrl @"https://mobilevikings.com/nld/nl/mysims/sim/736/balance/json/"

#import "BalanceService.h"
#import "AppDelegate.h"

@implementation BalanceService

- (id)initServiceWithToken:(NSString *)token {
    self = [super initWithURLString:kBalanceUrl params:nil httpMethod:@"GET"];
    
    NSDictionary *headers= @{@"X-CSRFToken" : token,
                             @"X-Requested-With" : @"XMLHttpRequest",
                             @"Referer" : @"https://mobilevikings.com/nld/nl/mysims/"};
    
    [self addHeaders:headers];
    
    return self;
}

- (void)balanceCompletionBlock:(void(^)(NSDictionary *))completionBlock onError:(MKNKErrorBlock)errorBlock {
    [self addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if (![completedOperation isCachedResponse]) {
            if (completedOperation.responseJSON != nil) {
                NSDictionary *balance = (NSDictionary *)completedOperation.responseJSON;
                completionBlock(balance);
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [ApplicationDelegate.engine enqueueOperation:self forceReload:YES];
}

@end
