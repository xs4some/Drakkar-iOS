//
//  MVActivationViewController.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 01/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVActivationViewController.h"

#import <Toast+UIView.h>

#import "MVPinViewController.h"
#import "MVLoginCell.h"
#import "MVRegisterService.h"
#import "MVTokenService.h"

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

    self.title = NSLocalizedString(@"Activate", @"Activate screen title");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Please enter your Mobile Vikings username and password, so you can check your balance with this app!", @"Explanatory text on activation screen");
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
            cell.textField.placeholder = NSLocalizedString(@"Username", @"Username placeholder on activation screen");
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            [cell.textField becomeFirstResponder];
        }
        else {
            cell.textField.placeholder = NSLocalizedString(@"Password", @"Password placeholder on activation screen");
            cell.textField.keyboardType = UIKeyboardTypeAlphabet;
            cell.textField.secureTextEntry = YES;
        }
        
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"Login", @"Login button caption on activation screen");
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

    [userNameCell.textField resignFirstResponder];
    [passWordCell.textField resignFirstResponder];
    
    NSString *userName = userNameCell.textField.text;
    NSString *passWord = passWordCell.textField.text;
    
    if (userName == nil || [userName isEqualToString:@""] || passWord == nil || [passWord isEqualToString:@""]) {
        [self.view makeToast:NSLocalizedString(@"Please enter a username and password", @"Username or password is empty toast on Activation screen")];
        [userNameCell.textField becomeFirstResponder];
    }
    else {
       [self.view makeToastActivity];
        MVTokenService *tokenService = [[MVTokenService alloc] initTokenService];
        
        [tokenService tokenCompletionBlock:^(void) {
            MVRegisterService *registerService = [[ MVRegisterService alloc] initServiceWithUserName:userName passWord:passWord];
            
            [registerService registerCompletionBlock:^{
                
                MVPinViewController *pinViewController = [[MVPinViewController alloc] initWithNibName:@"MVPinViewController" bundle:[NSBundle mainBundle]];
                pinViewController.userName = userName;
                pinViewController.passWord = passWord;
                pinViewController.pinScreenState = MVPinScreenStateActivate;
                [self.navigationController pushViewController:pinViewController animated:YES];
                
            } onError:^(NSError *error) {
                switch (error.code) {
                    case 401:
                    case 403:
                    case kCFErrorHTTPBadCredentials: {
                        [self.view makeToast:NSLocalizedString(@"Invalid username or password", @"Invalid username or password toast on Activation screen")];
                        [passWordCell.textField becomeFirstResponder];
                    }
                        break;
                    default: {
                        [self.view makeToast:NSLocalizedString(@"Unable to connect to server, please try again later", @"Network error toast shown on Activation screen")];
                    }
                        break;
                }
            }];
        } onError:^(NSError *error) {
            [self.view makeToast:NSLocalizedString(@"Unable to connect to server, please try again later", @"Network error toast shown on Activation screen")];
        }];
    }
}

@end
