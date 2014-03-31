//
//  MVPinViewController.m
//  Drakkar
//
//  Created by Hendrik Bruinsma on 05/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVPinViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <Toast+UIView.h>

#import "MVActivationViewController.h"
#import "MVBalanceViewController.h"
#import "MVAppDelegate.h"
#import "MVTokenService.h"
#import "MVLoginService.h"
#import "MVUserData.h"
//#import "IIViewDeckController+Notifications.h"

@interface MVPinViewController ()

@property (nonatomic, strong) NSString *pin;
@property (nonatomic, assign) int pinTries;
@property (nonatomic, assign) NetworkStatus networkStatus;

- (void)textFieldDidChange;
- (void)processAccessCodeCreation;
- (void)processLogin;
- (void)openBalanceView;
- (void)showMenu;
- (void)registerNotifications;

- (void)connectionChanged:(NSNotification *)notification;
- (void)sideBarDidAppear:(NSNotification *)notification;
- (void)sideBarDidDisppear:(NSNotification *)notification;

@end

@implementation MVPinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pinTries = 0;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.title = NSLocalizedString(@"Access code", @"Title of access code screen");
    
    if (self.pinScreenState == MVPinLoginStateLogin) {
        self.explanatoryText.text = NSLocalizedString(@"Please enter your access code.", @"Pin enter screen explanation text when logging in.");
    }
    else {
        self.navigationItem.hidesBackButton = YES;
        self.explanatoryText.text = NSLocalizedString(@"Please enter an access code to protect your data.", @"Pin enter screen explanation text when activating.");
    }
    
    self.pinField.delegate = self;
    self.pinField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.pin0.layer.cornerRadius = 5.0f;
    self.pin1.layer.cornerRadius = 5.0f;
    self.pin2.layer.cornerRadius = 5.0f;
    self.pin3.layer.cornerRadius = 5.0f;
 
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", @"Menu button caption") style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.networkStatus = [ApplicationDelegate.internetReachability currentReachabilityStatus];
    
    [self registerNotifications];
    
    [self.pinField becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
        return NO;
    }

    return YES;
}

#pragma mark - Notifications

- (void)connectionChanged:(NSNotification *)notification {
    self.networkStatus = [ApplicationDelegate.internetReachability currentReachabilityStatus];
    if (self.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        [self resetPinEntry];
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:NSLocalizedString(@"Connection lost", @"Alert shown when there's no connection available.")
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
        [noConnectionAlert show];
    }
    else {
        [self.pinField becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
}
- (void)sideBarDidAppear:(NSNotification *)notification {
    [self.pinField resignFirstResponder];
}

- (void)sideBarDidDisppear:(NSNotification *)notification {
    [self.pinField becomeFirstResponder];
}


#pragma mark - Class methods

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:kReachabilityChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideBarDidAppear:) name:kIIViewDeckControllerNotificationDidOpenViewSide object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideBarDidDisppear:) name:kIIViewDeckControllerNotificationDidCloseViewSide object:nil];
}

- (void)showMenu {
    [self.pinField resignFirstResponder];
    [ApplicationDelegate.deckController toggleLeftViewAnimated:YES];
}

- (void)resetPinEntry {
    self.pin0.backgroundColor = [UIColor whiteColor];
    self.pin1.backgroundColor = [UIColor whiteColor];
    self.pin2.backgroundColor = [UIColor whiteColor];
    self.pin3.backgroundColor = [UIColor whiteColor];
    self.pin = @"";
    self.pinField.text = @"";
}

- (void)textFieldDidChange {
    switch (self.pinField.text.length) {
        case 4: {
            self.pin3.backgroundColor = [UIColor darkGrayColor];
            if (self.pinScreenState == MVPinScreenStateActivate) {
                [self processAccessCodeCreation];
            }
            else if (self.pinScreenState == MVPinLoginStateLogin) {
                [self processLogin];
            }
        }
            break;
            
        case 3: {
            self.pin0.backgroundColor = [UIColor darkGrayColor];
            self.pin1.backgroundColor = [UIColor darkGrayColor];
            self.pin2.backgroundColor = [UIColor darkGrayColor];
            self.pin3.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        case 2: {
            self.pin0.backgroundColor = [UIColor darkGrayColor];
            self.pin1.backgroundColor = [UIColor darkGrayColor];
            self.pin2.backgroundColor = [UIColor whiteColor];
            self.pin3.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        case 1: {
            self.pin0.backgroundColor = [UIColor darkGrayColor];
            self.pin1.backgroundColor = [UIColor whiteColor];
            self.pin2.backgroundColor = [UIColor whiteColor];
            self.pin3.backgroundColor = [UIColor whiteColor];
        }
            break;
        
        case 0: {
            self.pin0.backgroundColor = [UIColor whiteColor];
            self.pin1.backgroundColor = [UIColor whiteColor];
            self.pin2.backgroundColor = [UIColor whiteColor];
            self.pin3.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
}

- (void)processAccessCodeCreation {
    if ([self.pin isEqualToString:@""] || self.pin == nil) {
        self.pin = self.pinField.text;
        
        self.explanatoryText.textColor = [UIColor whiteColor];
        self.explanatoryText.text = NSLocalizedString(@"Please re-enter your access code to confirm.", @"Pin enter screen confirm access code explanation text.");
        self.pinField.text = @"";
        
        [UIView animateWithDuration:3.0f animations:^{
            self.pin0.backgroundColor = [UIColor whiteColor];
            self.pin1.backgroundColor = [UIColor whiteColor];
            self.pin2.backgroundColor = [UIColor whiteColor];
            self.pin3.backgroundColor = [UIColor whiteColor];
            
            self.explanatoryText.textColor = [UIColor blackColor];
        }];
    }
    else if([self.pinField.text isEqualToString:self.pin]) {
        [self.pinField resignFirstResponder];
        
        NSDictionary *credentials = @{@"userName" : self.userName,
                                      @"passWord" : self.passWord};
        
        NSError *error;
        [MVUserData storeCredentials:credentials withPassCode:self.pin andError:&error];
        
        if (error != nil) {
            // TODO: Something went wrong whilst encrypting, handle it
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MVLoggedInStatusChangesNotification" object:nil];
            
            [self openBalanceView];
        }
    }
    else {
        self.explanatoryText.text = NSLocalizedString(@"Please enter an access code to protect your data.", @"Pin enter screen explanation text.");
        [self resetPinEntry];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"Both access codes should be the same. Please try again", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)processLogin {
    [self.pinField resignFirstResponder];
    [self.view makeToastActivity];
    MVTokenService *tokenService = [[MVTokenService alloc] initTokenService];
    [tokenService tokenCompletionBlock:^() {
        
        NSError *error;
        MVLoginService *loginService = [[MVLoginService alloc] initServiceWithPassCode:self.pinField.text andError:&error ];
        
        if (error != nil || loginService == nil) {
            [self.view hideToastActivity];
            [self.view makeToast:NSLocalizedString(@"Unable to get credentials with entered access code. Please try again.", @"")];
            self.pinField.text = @"";
            self.pin0.backgroundColor = [UIColor whiteColor];
            self.pin1.backgroundColor = [UIColor whiteColor];
            self.pin2.backgroundColor = [UIColor whiteColor];
            self.pin3.backgroundColor = [UIColor whiteColor];
            [self.pinField becomeFirstResponder];
            return ;
        }
        else {            
            [loginService loginCompletionBlock:^{
                [self.view hideToastActivity];
                [self openBalanceView];
            } onError:^(NSError *error) {
                [self.view hideToastActivity];
                NSLog(@"%@", error);
            }];
        }
    } onError:^(NSError *error) {
        [self.view hideToastActivity];
        if (error.code == kCFErrorHTTPBadCredentials) {
            if (self.pinTries > 3) {
                [self.view makeToast:NSLocalizedString(@"Reseting app", @"App is being reset toast")];
                [MVUserData removeCredentials];
                MVActivationViewController *activationViewController = [[MVActivationViewController alloc] initWithNibName:@"MVActivationViewController" bundle:[NSBundle mainBundle]];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activationViewController];
                ApplicationDelegate.deckController.centerController = navigationController;
                [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
            }
            else {
                self.pinTries ++;
                [self.view makeToast:NSLocalizedString(@"Invalid credentials, try again", @"Invalid credential error toast shown on Activation screen")];
            }
        }
        else {
            [self.view makeToast:NSLocalizedString(@"Unable to connect to server, please try again later", @"Network error toast shown on Activation screen")];
        }
    }];
}

- (void)openBalanceView {
    [ApplicationDelegate.deckController openLeftViewAnimated:YES];
    MVBalanceViewController *balanceViewController = [[MVBalanceViewController alloc] initWithNibName:@"MVBalanceViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:balanceViewController];
    ApplicationDelegate.deckController.centerController = navigationController;
    [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
}

@end
