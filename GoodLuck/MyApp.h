//
//  MyApp.h
//  GoodLuck
//
//  Created by HoJolin on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#include "MyPJ.h"

#define SIP_PORT 6000
#define LOG_LEVEL 5

@protocol MyAppObserver <NSObject>

- (void)notifyRegState:(pjsip_status_code)code reason:(string)reason expiration:(int)expiration;
- (void)notifyIncomingCall:(MyCall *)call;
- (void)notifyCallState:(MyCall *)call;
- (void)notifyCallMediaState:(MyCall *)call;
- (void)notifyBuddyState:(MyBuddy *)buddy;

@end

@interface MyApp : NSObject

@property (nonatomic) id<MyAppObserver> observer;
@property (nonatomic) MyLogWriter logWriter;
@property (nonatomic) Endpoint ep;
@property (nonatomic) TransportConfig sipTpConfig;
@property (nonatomic) EpConfig epConfig;
//@property (nonatomic) MyBuddy bud;

@end
