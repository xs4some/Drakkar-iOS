//
//  MVBalance.m
//  Drakkar
//
//  Created by Hendrik Bruinsma on 15-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVBalance.h"

@implementation MVBalance

- (id)initWithDictionary:(NSDictionary *)dictionary {
    MVBalance *balance = [[MVBalance alloc] init];
    
    balance.credit = dictionary[@"balance"][@"credit"];
    NSString *dataFull = [dictionary[@"balance"][@"data_full"] stringByReplacingOccurrencesOfString:@" GB" withString:@""];
    balance.dataFull = [NSNumber numberWithFloat:dataFull.floatValue * 1000 * 1000 * 1000];
    balance.dataNow = dictionary[@"balance"][@"data_now"];
    balance.dataPct = dictionary[@"balance"][@"data_pct"];
    balance.smsFull = dictionary[@"balance"][@"sms_full"];
    balance.smsNow = dictionary[@"balance"][@"sms_now"];
    balance.smsPct = dictionary[@"balance"][@"sms_pct"];
    balance.daysLeft = dictionary[@"balance"][@"days_left"];
    
    return balance;
}

- (NSString *)description {
    NSArray *keys = @[ @"credit",
                       @"dataFull",
                       @"dataNow",
                       @"dataPct",
                       @"smsFull",
                       @"smsNow",
                       @"smsPct",
                       @"daysLeft"];
    
    return [[self dictionaryWithValuesForKeys:keys] description];
}

@end
