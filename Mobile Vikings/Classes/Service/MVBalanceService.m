//
//  MVBalanceService.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 15-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#define kBalanceNlUrl @"https://mobilevikings.com/nld/nl/mysims/sim/736/balance/json/"
#define kBalanceEnUrl @"https://mobilevikings.com/nld/en/mysims/sim/736/balance/json/"

#import "MVBalanceService.h"
#import "MVAppDelegate.h"

@implementation MVBalanceService

- (id)initServiceWithToken:(NSString *)token {
    NSString *balanceUrl = [[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:@"nl"] ? kBalanceNlUrl : kBalanceEnUrl;
    self = [super initWithURLString:balanceUrl params:nil httpMethod:@"GET"];
    
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
