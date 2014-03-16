//
//  MVActivationViewController.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 01/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVActivationViewController.h"
#import "MVPinViewController.h"
#import "MVLoginCell.h"
#import "MVRegisterService.h"
#import "MVTokenService.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MVActivationViewController ()

- (void)verifyLogin;

@end

@implementation MVActivationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Activate";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Please enter your Mobile Vikings username and password, so you can check your balance with this app!";
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        
        case 1:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MVLoginCell *cell = [[MVLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        cell.textField.delegate = self;
        
        if (indexPath.row == 0) {
            cell.textField.placeholder = @"Username";
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            [cell.textField becomeFirstResponder];
        }
        else {
            cell.textField.placeholder = @"Password";
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            cell.textField.secureTextEntry = YES;
        }
        
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Inloggen";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        MVLoginCell *cell = (MVLoginCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }
    else {
        [self verifyLogin];
    }
}

#pragma mark - Class methods

- (void)verifyLogin {
    MVLoginCell *userNameCell = (MVLoginCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MVLoginCell *passWordCell = (MVLoginCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [userNameCell.textLabel resignFirstResponder];
    [passWordCell.textLabel resignFirstResponder];
    
    NSString *userName = userNameCell.textField.text;
    NSString *passWord = passWordCell.textField.text;
    
    if (userName == nil || [userName isEqualToString:@""] || passWord == nil || [passWord isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Please enter a username and password"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [userNameCell.textField becomeFirstResponder];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Loading...";
        [hud  show:YES];
        MVTokenService *tokenService = [[MVTokenService alloc] initTokenService];
        
        [tokenService tokenCompletionBlock:^(NSHTTPCookie *token) {
            MVRegisterService *registerService = [[ MVRegisterService alloc] initServiceWithToken:token.value userName:userName passWord:passWord];
            
            [registerService registerCompletionBlock:^{
                MVPinViewController *pinViewController = [[MVPinViewController alloc] initWithNibName:@"MVPinViewController" bundle:[NSBundle mainBundle]];
                pinViewController.userName = userName;
                pinViewController.passWord = passWord;
                [self.navigationController pushViewController:pinViewController animated:YES];
                
            } onError:^(NSError *error) {
                switch (error.code) {
                    case 401:
                    case 403:
                    case kCFErrorHTTPBadCredentials: {
                        UIAlertView *userErrorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                                 message:@"Invalid username or password"
                                                                                delegate:self
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];
                        [userErrorAlert show];
                        [userNameCell.textField becomeFirstResponder];
                    }
                        break;
                        
                    case kCFHostErrorHostNotFound:
                    case kCFHostErrorUnknown:
                    case kCFErrorHTTPBadURL:
                    case kCFErrorHTTPConnectionLost:
                    case kCFURLErrorNetworkConnectionLost:
                    case kCFURLErrorCannotConnectToHost:
                    case kCFURLErrorCannotFindHost:
                    case kCFURLErrorTimedOut:
                    case kCFURLErrorSecureConnectionFailed:
                    case kCFURLErrorCannotLoadFromNetwork: {
                        UIAlertView *unknownErrorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                                    message:@"Unable to connect to server, please try again later"
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                        [unknownErrorAlert show];
                    }
                        break;
                        
                    default: {
                        UIAlertView *unknownErrorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                                 message:@"Unknown error occurerd, please try again later"
                                                                                delegate:self
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];
                        [unknownErrorAlert show];
                    }
                        break;
                }
                [hud hide:YES];
            }];
        } onError:^(NSError *error) {
            switch (error.code) {
                case kCFHostErrorHostNotFound:
                case kCFHostErrorUnknown:
                case kCFErrorHTTPBadURL:
                case kCFErrorHTTPConnectionLost:
                case kCFURLErrorNetworkConnectionLost:
                case kCFURLErrorCannotConnectToHost:
                case kCFURLErrorCannotFindHost:
                case kCFURLErrorTimedOut:
                case kCFURLErrorSecureConnectionFailed:
                case kCFURLErrorCannotLoadFromNetwork: {
                    UIAlertView *unknownErrorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                                message:@"Unable to connect to server, please try again later"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                    [unknownErrorAlert show];
                }
                    break;
                    
                default: {
                    UIAlertView *unknownErrorAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                                message:@"Unknown error occurerd, please try again later"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                    [unknownErrorAlert show];
                }
                    break;
            }
            [hud hide:YES];
        }];
    }
}

@end
