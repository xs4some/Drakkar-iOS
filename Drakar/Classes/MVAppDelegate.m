//
//  MVAppDelegate.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 09-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVAppDelegate.h"

#import <KeychainItemWrapper/KeychainItemWrapper.h>

#import "MVSideBarViewController.h"
#import "MVActivationViewController.h"
#import "MVPinViewController.h"
#import "MVBalanceViewController.h"
//#import "IIViewDeckController+Notifications.h"

@interface MVAppDelegate ()

@end

@implementation MVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.engine = [[MKNetworkEngine alloc] initWithHostName:nil customHeaderFields:nil];
    [self.engine useCache];
    
    MVSideBarViewController *sideBarViewController = [[MVSideBarViewController alloc] initWithNibName:@"MVSideBarViewController" bundle:[NSBundle mainBundle]];
    
    MVBalanceViewController *balanceViewController = [[MVBalanceViewController alloc] initWithNibName:@"MVBalanceViewController" bundle:[NSBundle mainBundle]];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:balanceViewController];

    self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.navigationController leftViewController:sideBarViewController];
//    IIViewDeckControllerNotifications *deckNotifications = [[IIViewDeckControllerNotifications alloc] init];
//    self.deckController.delegate = deckNotifications;

    self.window.rootViewController = self.deckController;
    [self.window makeKeyAndVisible];

#if TARGET_IPHONE_SIMULATOR
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"encryptedUserName"] == nil) {
        
#else
        
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MobileVikingsNL" accessGroup:nil];
        
    if ([keychain objectForKey:(__bridge id)kSecAttrAccount] == nil) {

#endif
    
        MVActivationViewController *activationController = [[MVActivationViewController alloc] initWithNibName:@"MVActivationViewController" bundle:[NSBundle mainBundle]];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activationController];
        
        self.deckController.centerController = navigationController;
    }
    else {
        MVPinViewController *pinController = [[MVPinViewController alloc] initWithNibName:@"MVPinViewController" bundle:[NSBundle mainBundle]];
        pinController.pinScreenState = MVPinLoginStateLogin;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pinController];
        
        self.deckController.centerController = navigationController;
    }
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
