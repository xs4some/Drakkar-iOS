//
//  MVLoginCell.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 01/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVLoginCell.h"

@implementation MVLoginCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 300, 40)];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
