//
//  MVTokenService.h
//  Drakkar
//
//  Created by Hendrik Bruinsma on 02/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MKNetworkOperation.h"

@interface MVTokenService : MKNetworkOperation

- (id)initTokenService;
- (void)tokenCompletionBlock:(void(^)(void))completionBlock onError:(MKNKErrorBlock)errorBlock;

@end
