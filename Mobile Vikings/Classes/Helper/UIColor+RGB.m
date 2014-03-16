//
//  UIColor+RGB.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 16-01-14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor *)colorWithRGB:(int)rgbValue {
    UIColor *color = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                                     green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                                      blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
    
    return color;
}

@end
