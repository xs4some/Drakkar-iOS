//
//  MVAppDelegate.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 09-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#define ApplicationDelegate ((MVAppDelegate *)[UIApplication sharedApplication].delegate)

#import <UIKit/UIKit.h>
#import <IIViewDeckController.h>
#import <MKNetworkKit/MKNetworkKit.h>
#import <Reachability/Reachability.h>

#import "MVBalance.h"

@interface MVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MKNetworkEngine *engine;
@property (strong, nonatomic) NSHTTPCookie *token;
@property (strong, nonatomic) MVBalance *balance;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) IIViewDeckController *deckController;
@property (nonatomic, strong) Reachability *internetReachability;

@end
