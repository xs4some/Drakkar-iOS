//
//  IIViewDeckController+Notifications.h
//  Drakkar
//
//  Created by Hendrik Bruinsma on 21/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ViewDeck/IIViewDeckController.h>

NSString *const kIIViewDeckControllerNotificationWillOpenViewSide =  @"kIIViewDeckControllerNotificationWillOpenViewSide";
NSString *const kIIViewDeckControllerNotificationDidOpenViewSide = @"kIIViewDeckControllerNotificationDidOpenViewSide";
NSString *const kIIViewDeckControllerNotificationWillCloseViewSide = @"kIIViewDeckControllerNotificationWillCloseViewSide";
NSString *const kIIViewDeckControllerNotificationDidCloseViewSide = @"kIIViewDeckControllerNotificationDidCloseViewSide";
NSString *const kIIViewDeckControllerNotificationDidShowCenterViewFromSide = @"kIIViewDeckControllerNotificationDidShowCenterViewFromSide";
NSString *const kIIViewDeckControllerNotificationWillPreviewBounceViewSide = @"kIIViewDeckControllerNotificationWillPreviewBounceViewSide";
NSString *const kIIViewDeckControllerNotificationDidPreviewBounceViewSide = @"kIIViewDeckControllerNotificationDidPreviewBounceViewSide";

@interface IIViewDeckControllerNotifications : NSObject <IIViewDeckControllerDelegate>

@end
