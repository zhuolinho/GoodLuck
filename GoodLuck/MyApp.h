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
#define CHAR_AT "@"
#define SIP_PREFIX "sip:"
#define TRANSPORT_TCP_SUFFIX ";transport=tcp"
#define YARLUNG_SERVER_IP "121.40.49.168"
#define YARLUNG_SERVER_PORT "6010"
#define YARLUNG_SERVER YARLUNG_SERVER_IP ":" YARLUNG_SERVER_PORT
#define YARLUNG_REGISTRAR SIP_PREFIX YARLUNG_SERVER
#define YARLUNG_PROXY SIP_PREFIX YARLUNG_SERVER TRANSPORT_TCP_SUFFIX;
#define mUserName "9000"
#define mPassWord "p9000"

@protocol MyAppObserver <NSObject>

- (void)notifyRegState:(pjsip_status_code)code reason:(string)reason expiration:(int)expiration;
- (void)notifyIncomingCall:(MyCall *)call;
- (void)notifyCallState:(MyCall *)call;
- (void)notifyCallMediaState:(MyCall *)call;
- (void)notifyBuddyState:(MyBuddy *)buddy;

@end

@interface MyApp : NSObject
{
@public
    MyLogWriter *logWriter;
    Endpoint ep;
    TransportConfig sipTpConfig;
    EpConfig epConfig;
    vector<MyAccount *> accList;
    vector<MyAccountConfig *> accCfgs;
}

@property (nonatomic) id<MyAppObserver> observer;

- (MyAccount *)addAcc: (AccountConfig) cfg;
- (void)delAcc: (MyAccount *) acc;
+ (void)initAccountConfigForYarlung: (AccountConfig *) accConfig;
+ (string)makeUriFromUsername: (string) username;

@end
