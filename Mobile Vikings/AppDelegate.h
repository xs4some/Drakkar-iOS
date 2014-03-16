//
//  AppDelegate.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 09-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#import <UIKit/UIKit.h>
#import "MKNetworkKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MKNetworkEngine *engine;

@end
