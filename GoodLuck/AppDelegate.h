//
//  AppDelegate.h
//  GoodLuck
//
//  Created by HoJolin on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "CallingViewController.h"
#import "API.h"

@protocol AppObserver <NSObject>

- (void)receiveMsg: (const char *)msg;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CallingViewController *currentCall;

@end

