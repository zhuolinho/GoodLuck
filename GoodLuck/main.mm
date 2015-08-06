//
//  main.m
//  GoodLuck
//
//  Created by HoJolin on 15/7/26.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        MyApp app
//        ;
//        AccountConfig accCfg;
//        accCfg.idUri = "sip:localhost";
//        accCfg.natConfig.iceEnabled = true;
//        app.initAccountConfigForYarlung(accCfg);
//        accCfg.videoConfig.autoTransmitOutgoing = true;
//        accCfg.videoConfig.autoShowIncoming = true;
//        MyAccount *accout = new MyAccount(accCfg);
//        MyAppObserver *obs;
//        app.init(*obs, "");
//        pj::Endpoint ep;
//        ep.libCreate();
//        pj::EpConfig epConfig;
//        pj::TransportConfig sipTpConfig;
//        sipTpConfig.port = 6000;
//        epConfig.logConfig.level = 5;
//        epConfig.logConfig.consoleLevel = 5;
//        
//        pj::LogConfig log_cfg = epConfig.logConfig;
//        log_cfg.decor = log_cfg.decor & ~(PJ_LOG_HAS_CR | PJ_LOG_HAS_NEWLINE);
//        pj::UaConfig ua_cfg = epConfig.uaConfig;
//        ua_cfg.userAgent = "PjsipiOS";
//        pj::StringVector stun_servers;
//        stun_servers.insert(stun_servers.end(), "121.40.49.168");
//        ua_cfg.stunServer = stun_servers;
//        ep.libInit(epConfig);
//        ep.transportCreate(PJSIP_TRANSPORT_UDP, sipTpConfig);
//        ep.transportCreate(PJSIP_TRANSPORT_TCP, sipTpConfig);
//        ep.libStart();
//        pj::AccountConfig accCfg;
//        accCfg.natConfig.iceEnabled = true;
//        accCfg.idUri = "sip:9000@121.40.49.168:6010";
//        accCfg.regConfig.registrarUri = "sip:121.40.49.168:6010";
//        pj::AuthCredInfoVector creds = accCfg.sipConfig.authCreds;
//        creds.clear();
//        creds.insert(creds.end(), *new pj::AuthCredInfo("Digest", "*", "9000", 0, "p9000"));
//        accCfg.sipConfig.proxies.clear();
//        accCfg.sipConfig.proxies.insert(accCfg.sipConfig.proxies.end(), "sip:121.40.49.168:6010;transport=tcp");
//        accCfg.videoConfig.autoShowIncoming = true;
//        accCfg.videoConfig.autoTransmitOutgoing = true;
//        pj::Account account = pj::Account();
//        account.create(accCfg);
//        pj::Call call = pj::Call(account, -1);
//        pj::CallOpParam prm = pj::CallOpParam(true);
//        call.makeCall("sip:9002@121.40.49.168:6010", prm);
//        try {
//            ep.transportCreate(PJSIP_TRANSPORT_UDP, tcfg);
//        } catch (pj::Error &err) {
//            printf("sssssssss/n");
//            return 1;
//        }
//        ep.libStart();
//        printf("fuckyou\n");
//        pj::AccountConfig acfg;
//        acfg.idUri = "sip:test@pjsip.org";
//        acfg.regConfig.registrarUri = "sip:pjsip.org";
//        pj::AuthCredInfo cred = pj::AuthCredInfo("digest", "*", "test", 0, "secret");
//        acfg.sipConfig.authCreds.push_back(cred);
//        pj::Account *acc = new pj::Account;
//        pj_thread_sleep(10000);
//        delete acc;
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

