//
//  RegisterService.m
//  Drakkar
//
//  Created by Hendrik Bruinsma on 14-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVRegisterService.h"
#import "MVAppDelegate.h"

#define kLoginUrl @"https://mobilevikings.nl/en/account/login/?"
#define kErrorDomain @"https://www.mobilevikings.nl/"

@interface MVRegisterService ()

@end

@implementation MVRegisterService

- (id)initServiceWithUserName:(NSString *)userName passWord:(NSString *)passWord {
    NSDictionary *headers = @{ @"Referer" : kLoginUrl,
                               @"X-Requested-With" : @"XMLHttpRequest",
                               @"X-CSRFToken" : ApplicationDelegate.token.value};
    
    NSDictionary *params = @{ @"csrfmiddlewaretoken" : ApplicationDelegate.token.value,
                              @"username" : userName,
                              @"password" : passWord,
                              @"next" : @"/nld/nl"};
    
    self = [super initWithURLString:kLoginUrl params:params httpMethod:@"POST"];

    [self addHeaders:headers];
    [self setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    return self;
}

- (void)registerCompletionBlock:(void(^)(void))completionBlock onError:(MKNKErrorBlock)errorBlock {
    [self addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if (![completedOperation isCachedResponse]) {
            if ([completedOperation.responseString rangeOfString:@"form-error"].location != NSNotFound) {
                NSError *error = [NSError errorWithDomain:kErrorDomain code:kCFErrorHTTPBadCredentials userInfo:@{@"":@""}];
                [ApplicationDelegate.engine emptyCache];
                errorBlock(error);
            }
            else {
                completionBlock();
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [ApplicationDelegate.engine emptyCache];
        errorBlock(error);
    }];
    
    [ApplicationDelegate.engine enqueueOperation:self forceReload:YES];
}

@end
