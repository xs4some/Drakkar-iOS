//
//  MVBalanceService.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 15-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#define kBalanceNlUrl @"https://mobilevikings.nl/nl/mysims/sim/736/balance/json/"
#define kBalanceEnUrl @"https://mobilevikings.nl/en/mysims/sim/736/balance/json/"

#import "MVBalanceService.h"
#import "MVAppDelegate.h"

@implementation MVBalanceService

- (id)initServiceWithToken:(NSString *)token {
    NSString *balanceUrl = [[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:@"nl"] ? kBalanceNlUrl : kBalanceEnUrl;
    self = [super initWithURLString:balanceUrl params:nil httpMethod:@"GET"];
    
    NSDictionary *headers= @{@"X-CSRFToken" : token,
                             @"X-Requested-With" : @"XMLHttpRequest",
                             @"Referer" : @"https://mobilevikings.nl/en/mysims/"};
    
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
            else {
                [ApplicationDelegate.engine emptyCache];
                ApplicationDelegate.token = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MVLoggedInStatusChangesNotification" object:nil];
                NSError *error = [NSError errorWithDomain:@"MobileVikings" code:kCFErrorHTTPConnectionLost userInfo:nil];
                errorBlock(error);
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [ApplicationDelegate.engine emptyCache];
        ApplicationDelegate.token = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MVLoggedInStatusChangesNotification" object:nil];
        errorBlock(error);
    }];
    
    [ApplicationDelegate.engine enqueueOperation:self forceReload:YES];
}

@end
