//
//  MyApp.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/6.
//
//

#import "MyApp.h"


@implementation MyApp

- (id)init
{
    ep.libCreate();
    sipTpConfig.port = SIP_PORT;
    epConfig.logConfig.level = LOG_LEVEL;
    epConfig.logConfig.consoleLevel = LOG_LEVEL;
    LogConfig log_cfg = epConfig.logConfig;
    logWriter = new MyLogWriter();
    log_cfg.writer = logWriter;
    log_cfg.decor = log_cfg.decor & ~(PJ_LOG_HAS_CR | PJ_LOG_HAS_NEWLINE);
    UaConfig ua_cfg = epConfig.uaConfig;
    ua_cfg.userAgent = "PjsipiOS";
    StringVector stun_servers;
    stun_servers.push_back(YARLUNG_SERVER_IP);
    ua_cfg.stunServer = stun_servers;
    if (false) {
        ua_cfg.threadCnt = 0;
        ua_cfg.mainThreadOnly = true;
    }
    try {
        ep.libInit(epConfig);
    } catch (exception e) {
        return NULL;
    }
    try {
        ep.transportCreate(PJSIP_TRANSPORT_UDP, sipTpConfig);
    } catch (exception e) {
        cout << &e;
    }
    
    try {
        ep.transportCreate(PJSIP_TRANSPORT_TCP, sipTpConfig);
    } catch (exception e) {
        cout << &e;
    }
    for (int i = 0; i < accCfgs.size(); i++) {
        MyAccountConfig my_cfg = *accCfgs[i];
        
        /* Customize account config */
        my_cfg.accCfg.natConfig.iceEnabled = true;
        my_cfg.accCfg.videoConfig.autoTransmitOutgoing = true;
        my_cfg.accCfg.videoConfig.autoShowIncoming = true;
//        
        [MyApp initAccountConfigForYarlung: &my_cfg.accCfg];    // Added by wonder
        
        MyAccount *acc = [self addAcc: my_cfg.accCfg];
        if (acc == NULL) continue;
        
        /* Add Buddies */
        for (int j = 0; j < my_cfg.buddyCfgs.size(); j++) {
            BuddyConfig bud_cfg = *my_cfg.buddyCfgs[j];
            acc->addBuddy(bud_cfg);
        }
    }
    try {
        ep.libStart();
    } catch (exception e) {
        return NULL;
    }
    return self;
}

- (MyAccount *)addAcc: (AccountConfig) cfg
{
    MyAccount *acc = new MyAccount(cfg);
    try {
        acc->create(cfg);
    } catch (exception e) {
        acc = NULL;
        return NULL;
    }
    
    accList.push_back(acc);
    return acc;
}

- (void)delAcc:(MyAccount *)acc
{
    for (vector<MyAccount*>::iterator it = accList.begin(); it != accList.end(); ++it)
    {
        if (*it == acc) {
            accList.erase(it);
            break;
        }
    }
}

+ (void)initAccountConfigForYarlung:(pj::AccountConfig *)accConfig
{
    string username = mUserName;
    string password = mPassWord;
    string proxy = YARLUNG_PROXY;
    string registrar = YARLUNG_REGISTRAR;
    if (username.length() == 0 || password.length() == 0) {
        return;
    }
    accConfig->idUri = SIP_PREFIX + username + CHAR_AT + YARLUNG_SERVER;
    accConfig->natConfig.iceEnabled = true;
    accConfig->regConfig.registrarUri = registrar;
    AuthCredInfoVector creds = accConfig->sipConfig.authCreds;
    creds.clear();
    if (username.length() != 0) {
        creds.push_back(AuthCredInfo("Digest", "*", username, 0, password));
    }
    StringVector proxies = accConfig->sipConfig.proxies;
    proxies.clear();
    if (proxy.length() != 0) {
        proxies.push_back(proxy);
    }
}

+ (string)makeUriFromUsername: (string) username
{
    string uri = "";
    if (username.length() != 0) {
        uri = SIP_PREFIX + username + CHAR_AT + YARLUNG_SERVER;
    }
    return uri;
}

@end
