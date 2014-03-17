//
//  MVTokenService.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 02/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVTokenService.h"
#import "MVAppDelegate.h"

#define kLoginUrl @"https://mobilevikings.com/nld/nl/account/login/?"
#define kErrorDomain @"https://www.mobilevikings.com/"

@implementation MVTokenService

- (id)initTokenService {
    NSDictionary *headers = @{ @"Referer" : @"https://www.mobilevikings.com/"};
    
    self = [super initWithURLString:kLoginUrl params:nil httpMethod:@"GET"];
    
    [self addHeaders:headers];
    
    return self;
}

- (void)tokenCompletionBlock:(void(^)(NSHTTPCookie *))completionBlock onError:(MKNKErrorBlock)errorBlock {
    
    [self addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSArray *cookieJar = [NSHTTPCookie cookiesWithResponseHeaderFields:[completedOperation.readonlyResponse allHeaderFields] forURL:[NSURL URLWithString:@"https://mobilevikings.com/"]];
        
        for (NSHTTPCookie *cookie in cookieJar) {
            if ([cookie.name isEqualToString:@"csrftoken"]) {
                completionBlock(cookie);
                return;
            }
        }
        NSError *error = [NSError errorWithDomain:kErrorDomain code:500 userInfo:@{@"Reason": NSLocalizedString(@"Session token not found in response! Unable to login", @"Error stating session token cannot be found")}];
        [ApplicationDelegate.engine emptyCache];
        errorBlock(error);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [ApplicationDelegate.engine emptyCache];
        errorBlock(error);
    }];
    
    [ApplicationDelegate.engine enqueueOperation:self forceReload:YES];
}

@end
