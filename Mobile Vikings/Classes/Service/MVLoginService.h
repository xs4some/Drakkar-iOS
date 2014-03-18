//
//  MVLoginService.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 14-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkOperation.h"

@interface MVLoginService : MKNetworkOperation

- (id)initServiceWithPassCode:(NSString *)passCode andError:(NSError **)error;
- (void)loginCompletionBlock:(void(^)(void))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
