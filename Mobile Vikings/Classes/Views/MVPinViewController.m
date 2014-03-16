//
//  MVPinViewController.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 05/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVPinViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "MVUserData.h"

@interface MVPinViewController ()

@property (nonatomic, strong) NSString *pin;

- (void)textFieldDidChange;

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
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.title = @"Access code";
    self.explanatoryText.text = NSLocalizedString(@"Please enter an access code to protect your data.", @"Pin enter screen explanation text.");
    
    self.pinField.delegate = self;
    self.pinField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.pin0.layer.cornerRadius = 5.0f;
    self.pin1.layer.cornerRadius = 5.0f;
    self.pin2.layer.cornerRadius = 5.0f;
    self.pin3.layer.cornerRadius = 5.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.pinField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - Class methods

- (void)textFieldDidChange {
    switch (self.pinField.text.length) {
        case 4: {
            self.pin3.backgroundColor = [UIColor darkGrayColor];
            
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
                
                [MVUserData storeCredentials:credentials withPassCode:self.pin];
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            }
            else {
                self.explanatoryText.text = NSLocalizedString(@"Please enter an access code to protect your data.", @"Pin enter screen explanation text.");
                self.pin0.backgroundColor = [UIColor whiteColor];
                self.pin1.backgroundColor = [UIColor whiteColor];
                self.pin2.backgroundColor = [UIColor whiteColor];
                self.pin3.backgroundColor = [UIColor whiteColor];
                self.pin = @"";
                self.pinField.text = @"";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:NSLocalizedString(@"Both access codes should be the same. Please try again", @"")
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
                [alertView show];
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

@end
