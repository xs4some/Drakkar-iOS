//
//  MVPinViewController.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 05/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MVPinScreenState) {
    MVPinLoginStateLogin,
    MVPinScreenStateActivate,
};

@interface MVPinViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *explanatoryText;

@property (nonatomic, strong) IBOutlet UITextField *pinField;

@property (nonatomic, strong) IBOutlet UIView *pinView;
@property (nonatomic, strong) IBOutlet UIView *pin0;
@property (nonatomic, strong) IBOutlet UIView *pin1;
@property (nonatomic, strong) IBOutlet UIView *pin2;
@property (nonatomic, strong) IBOutlet UIView *pin3;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;

@property (nonatomic, assign) MVPinScreenState pinScreenState;

@end
