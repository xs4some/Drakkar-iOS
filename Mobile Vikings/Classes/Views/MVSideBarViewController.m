//
//  MVSideBarViewController.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 18/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVSideBarViewController.h"

#import <Toast+UIView.h>

#import "MVAppDelegate.h"
#import "MVDisclaimerTableViewController.h"
#import "MVActivationViewController.h"
#import "MVBalanceViewController.h"
#import "MVPinViewController.h"
#import "MVUserData.h"

@interface MVSideBarViewController ()

- (void)registerForNotifications;
- (void)MVLoggedInStatusChangesNotification:(NSNotification *)notification;
- (void)setUpTableData;

@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation MVSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0)];
    self.tableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.separatorColor = [UIColor darkGrayColor];
    self.tableView.scrollEnabled = NO;
    
    [self setUpTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"SideBarCell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }

    NSDictionary *itemDictionary = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [itemDictionary objectForKey:@"title"];    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return NSLocalizedString(@"Settings", @"Side bar tittle for Settings");
    }
    
    return nil;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (ApplicationDelegate.token == nil) {
                if ([MVUserData isActivated]) {
                    MVPinViewController *pinViewController = [[MVPinViewController alloc] initWithNibName:@"MVPinViewController" bundle:[NSBundle mainBundle]];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pinViewController];
                    ApplicationDelegate.deckController.centerController = navigationController;
                    [ApplicationDelegate.deckController closeLeftViewAnimated:YES];                }
                else {
                    MVActivationViewController *activationViewController = [[MVActivationViewController alloc] initWithNibName:@"MVActivationViewController" bundle:[NSBundle mainBundle]];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activationViewController];
                    ApplicationDelegate.deckController.centerController = navigationController;
                    [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
                }
            }
            else {
                [self.view makeToast:NSLocalizedString(@"Logged out", @"Toast shown when side bar option 'logout' is tapped")];
                [ApplicationDelegate.engine emptyCache];
            }
            
        }
        else if (indexPath.row == 1) {
            if (ApplicationDelegate.token == nil) {
                if ([MVUserData isActivated]) {
                    MVPinViewController *pinViewController = [[MVPinViewController alloc] initWithNibName:@"MVPinViewController" bundle:[NSBundle mainBundle]];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pinViewController];
                    ApplicationDelegate.deckController.centerController = navigationController;
                    [ApplicationDelegate.deckController closeLeftViewAnimated:YES];                }
                else {
                    MVActivationViewController *activationViewController = [[MVActivationViewController alloc] initWithNibName:@"MVActivationViewController" bundle:[NSBundle mainBundle]];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activationViewController];
                    ApplicationDelegate.deckController.centerController = navigationController;
                    [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
                }
            }
            else {
                MVBalanceViewController *balanceViewController = [[MVBalanceViewController alloc] initWithNibName:@"MVBalanceViewController" bundle:[NSBundle mainBundle]];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:balanceViewController];
                ApplicationDelegate.deckController.centerController = navigationController;
                [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
            }
        }
    }
    else {
        if (indexPath.row == 0) {
            MVDisclaimerTableViewController *disclaimerTableViewController = [[MVDisclaimerTableViewController alloc] initWithNibName:@"MVDisclaimerTableViewController" bundle:[NSBundle mainBundle]];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:disclaimerTableViewController];
            ApplicationDelegate.deckController.centerController = navigationController;
            [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
        }
        else {
            UIAlertView *resetAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:NSLocalizedString(@"Tap 'OK' to reset the app.", @"")
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
            [resetAlertView show];
        }
    }
}

#pragma mark - Class methods

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MVLoggedInStatusChangesNotification:) name:@"MVLoggedInStatusChangesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReachabilityChangedNotification:) name:kReachabilityChangedNotification object:nil];
}

- (void)ReachabilityChangedNotification:(NSNotification *)notification {
    if (ApplicationDelegate.internetReachability.currentReachabilityStatus == NotReachable) {
        ApplicationDelegate.token = nil;
        [ApplicationDelegate.engine emptyCache];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MVLoggedInStatusChangesNotification" object:nil];
    }
}

- (void)MVLoggedInStatusChangesNotification:(NSNotification *)notification {
    [self setUpTableData];
    
    [self.tableView reloadData];
}

- (void)setUpTableData {
    self.tableData = [NSMutableArray array];
    
    NSArray *functions = nil;
    
    if (ApplicationDelegate.token == nil) {
        functions = @[
                      @{@"title" : NSLocalizedString(@"Login", @"Title of side bar item Login")},
                      @{@"title" : NSLocalizedString(@"Balance", @"Title of side bar item Balance")},
//                      @{@"title" : NSLocalizedString(@"History", @"Title of side bar item History")},
                      ];
    }
    else {
        functions = @[
                      @{@"title" : NSLocalizedString(@"Logout", @"Title of side bar item Logout")},
                      @{@"title" : NSLocalizedString(@"Balance", @"Title of side bar item Balance")},
//                      @{@"title" : NSLocalizedString(@"History", @"Title of side bar item History")},
                      ];

    }
    
    [self.tableData addObject:functions];
    
    NSArray *settings = @[@{@"title" : NSLocalizedString(@"Licences", @"Title of side bar item Licenses in Settings")},
                          @{@"title" : NSLocalizedString(@"Reset", @"Title of side bar item Reset in Settings")}];
    
    [self.tableData addObject:settings];
}

#pragma mark - AlertView delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.view makeToast:NSLocalizedString(@"Reseting app", @"App is being reset toast")];
        [MVUserData removeCredentials];
        MVActivationViewController *activationViewController = [[MVActivationViewController alloc] initWithNibName:@"MVActivationViewController" bundle:[NSBundle mainBundle]];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activationViewController];
        ApplicationDelegate.deckController.centerController = navigationController;
        [ApplicationDelegate.deckController closeLeftViewAnimated:YES];
    }
}

@end
