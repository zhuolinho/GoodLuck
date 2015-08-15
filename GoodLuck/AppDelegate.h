//
//  AppDelegate.h
//  GoodLuck
//
//  Created by HoJolin on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "MyApp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (MyApp*)getApp;
+ (MyCall *)getCall;

@end

