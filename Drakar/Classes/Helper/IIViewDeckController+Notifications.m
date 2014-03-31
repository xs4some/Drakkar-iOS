//
//  IIViewDeckController+Notifications.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 21/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "IIViewDeckController+Notifications.h"



@implementation IIViewDeckControllerNotifications

- (instancetype)initWithIIViewDeckController:(IIViewDeckController *)viewDeckController {
    self = [super init];
    if (self) {
        
    }
    return self;
}

# pragma mark IIViewDeck delegate

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationWillOpenViewSide object:@(viewDeckSide)];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationDidOpenViewSide object:@(viewDeckSide)];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationWillCloseViewSide object:@(viewDeckSide)];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationDidCloseViewSide object:@(viewDeckSide)];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationDidShowCenterViewFromSide object:@(viewDeckSide)];
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willPreviewBounceViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationWillPreviewBounceViewSide object:@(viewDeckSide)];
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController didPreviewBounceViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {    [[NSNotificationCenter defaultCenter] postNotificationName:kIIViewDeckControllerNotificationDidPreviewBounceViewSide object:@(viewDeckSide)];
}

@end
