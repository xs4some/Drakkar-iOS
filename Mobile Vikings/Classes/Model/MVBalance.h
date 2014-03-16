//
//  MVBalance.h
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 15-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVBalance : NSObject

/*
 Remaining credit in EUR
 */
@property (nonatomic, strong) NSNumber *credit;

/*
 Full monthly data balance in bytes
 */
@property (nonatomic, strong) NSNumber *dataFull;

/*
 Remaining data balance in bytes
 */
@property (nonatomic, strong) NSNumber *dataNow;

/*
 Remaining data balance in percentage
 */
@property (nonatomic, strong) NSNumber *dataPct;

/*
 Full monthly text messages
 */
@property (nonatomic, strong) NSNumber *smsFull;

/*
 Remaining monthly text messages
 */
@property (nonatomic, strong) NSNumber *smsNow;

/*
 Remaining monthly text messages
 */
@property (nonatomic, strong) NSNumber *smsPct;

/* 
 Remaining days left of your subscription, in which the data and text messages are valid.
 */
@property (nonatomic, strong) NSString *daysLeft;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
