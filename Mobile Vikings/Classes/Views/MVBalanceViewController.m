//
//  MVBalanceViewController.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 09-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVBalanceViewController.h"

#import <TYMProgressBarView/TYMProgressBarView.h>
#import <Toast+UIView.h>

#import "MVAppDelegate.h"
#import "MVBalanceService.h"
#import "MVBalance.h"
#import "UIColor+RGB.h"

@interface MVBalanceViewController ()

@property (nonatomic, strong) NSHTTPCookie *tokenCookie;
@property (nonatomic, strong) MVBalance *balance;
@property (nonatomic, strong) TYMProgressBarView *dataProgressBar;
@property (nonatomic, strong) TYMProgressBarView *smsProgressBar;

- (void)drawBalanceBars;
- (void)resetApp;

@end

@implementation MVBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Balance", @"Title of balance screen");
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataProgressBar = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(20, 120, 280, 25)];
    
    self.dataProgressBar.barBorderWidth = 1.0f;
    self.dataProgressBar.progress = 0.0f;
    
    [self.view addSubview:self.dataProgressBar];
    
    self.smsProgressBar = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(20, 200, 280, 25)];
    
    self.smsProgressBar.barBorderWidth = 1.0f;
    self.smsProgressBar.progress = 0.0f;
    
    [self.view addSubview:self.smsProgressBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (ApplicationDelegate.token.value != nil) {
        [self.view makeToastActivity];
        MVBalanceService *balanceService = [[MVBalanceService alloc] initServiceWithToken:ApplicationDelegate.token.value];
        
        [balanceService balanceCompletionBlock:^(NSDictionary *balance) {
            self.balance = [[MVBalance alloc] initWithDictionary:balance];
            [self.view hideToastActivity];
            [self drawBalanceBars];
        } onError:^(NSError *error) {
            NSLog(@"%@", error);
            [self.view hideToastActivity];
        }];
    }
}

#pragma mark - class methods

- (void)drawBalanceBars {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"nl_NL"]];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    // Text above porgessbar
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 280, 25)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.text = [NSString stringWithFormat:@"%@ %@",
                      [NSByteCountFormatter stringFromByteCount:self.balance.dataNow.longLongValue countStyle:NSByteCountFormatterCountStyleDecimal], NSLocalizedString(@"remaining", @"... remaining bytes caption")];
    dataLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:dataLabel];

    // Text above porgessbar
    UILabel *smsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 280, 25)];
    smsLabel.textAlignment = NSTextAlignmentCenter;
    smsLabel.text = [NSString stringWithFormat:@"%@ %@", self.balance.smsNow, NSLocalizedString(@"SMS remaining", @"... remaining text messages caption")];
    smsLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:smsLabel];
    
    UILabel *creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 270, 280, 25)];
    creditLabel.textAlignment = NSTextAlignmentCenter;
    creditLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Balance %@", @"Text surrounding remaining balance"), [numberFormatter stringFromNumber:self.balance.credit]];
    creditLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:creditLabel];
    
    UILabel *daysLeft = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 280, 25)];
    daysLeft.textAlignment = NSTextAlignmentCenter;
    daysLeft.text = self.balance.daysLeft;
    daysLeft.textColor = [UIColor darkGrayColor];
    [self.view addSubview:daysLeft];
    
    [UIView beginAnimations:@"DataProgressBarAnimation" context:nil];
    self.dataProgressBar.progress = (self.balance.dataNow.floatValue / self.balance.dataFull.floatValue);
    [UIView commitAnimations];

    [UIView beginAnimations:@"SMSProgressBarAnimation" context:nil];
    self.smsProgressBar.progress = (self.balance.smsNow.floatValue / self.balance.smsFull.floatValue);
    [UIView commitAnimations];
}

- (void)resetApp {
    
}

@end
