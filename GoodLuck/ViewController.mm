//
//  ViewController.m
//  GoodLuck
//
//  Created by HoJolin on 15/7/26.
//
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<MyAppObserver>
{
//    AccountConfig accCfg;
//    MyAccount *account;
    MyCall *ascall;
    MyApp * app;
//    VideoWindowHandle vidWH;
//    MyAccount *account;
//    pj::Endpoint ep;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageWindow;

@end

@implementation ViewController
- (IBAction)kkkkkk:(UIButton *)sender {
//    String buddy_uri = item.get("uri");
//    
//    MyCall call = new MyCall(account, -1);
    ascall = [AppDelegate getCall];
    
    CallOpParam prm(true);
    prm.opt.audioCount = 1;
    prm.opt.videoCount = 0;
    
    try {
        ascall->makeCall("sip:9002@121.40.49.168:6010", prm);
    } catch (exception e) {
        return;
    }
}

- (IBAction)ffff:(UIButton *)sender {
//    pj::CallOpParam prm = pj::CallOpParam(true);
//    call->makeCall("sip:9003@121.40.49.168:6010", prm);
//    call
    ascall = [AppDelegate getCall];
    CallOpParam prm(true);
//    try {
        //        call->makeCall(cfg.uri, CallOpParam(true));
        ascall->makeCall("sip:9003@121.40.49.168:6010", prm);
//    } catch (exception e) {
//        call->~MyCall();
//        return;
//    }
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    app = [AppDelegate getApp];
    app.observer = self;
//    if ([AppDelegate getApp]->accList.size() == 0) {
////
//        [MyApp initAccountConfigForYarlung: &accCfg];    // Added by wonder
//        accCfg.natConfig.iceEnabled = true;
//        accCfg.videoConfig.autoTransmitOutgoing = true;
//        accCfg.videoConfig.autoShowIncoming = true;
//        account = [app addAcc: accCfg];
//    } else {
//        account = app->accList[0];
//        accCfg = account->cfg;
//    }
//    BuddyConfig cfg;
//    cfg.uri = [MyApp makeUriFromUsername: "9001"];
//    cfg.subscribe = true;
//    account->addBuddy(cfg);
//    call = new MyCall(*(account), -1);


//    pj::VideoWindowHandle
    
//    ep.libCreate();
//    pj::EpConfig epConfig;
//    pj::TransportConfig sipTpConfig;
//    sipTpConfig.port = 6000;
//    epConfig.logConfig.level = 5;
//    epConfig.logConfig.consoleLevel = 5;
//    
//    pj::LogConfig log_cfg = epConfig.logConfig;
//    log_cfg.decor = log_cfg.decor & ~(PJ_LOG_HAS_CR | PJ_LOG_HAS_NEWLINE);
//    pj::UaConfig ua_cfg = epConfig.uaConfig;
//    ua_cfg.userAgent = "PjsipiOS";
//    pj::StringVector stun_servers;
//    stun_servers.insert(stun_servers.end(), "121.40.49.168");
//    ua_cfg.stunServer = stun_servers;
//    ep.libInit(epConfig);
//    ep.transportCreate(PJSIP_TRANSPORT_UDP, sipTpConfig);
//    ep.transportCreate(PJSIP_TRANSPORT_TCP, sipTpConfig);
//    ep.libStart();
//    pj::AccountConfig accCfg;
//    accCfg.natConfig.iceEnabled = true;
//    accCfg.idUri = "sip:9000@121.40.49.168:6010";
//    accCfg.regConfig.registrarUri = "sip:121.40.49.168:6010";
//    pj::AuthCredInfoVector creds = accCfg.sipConfig.authCreds;
//    creds.clear();
//    creds.insert(creds.end(), *new pj::AuthCredInfo("Digest", "*", "9000", 0, "p9000"));
//    accCfg.sipConfig.proxies.clear();
//    accCfg.sipConfig.proxies.insert(accCfg.sipConfig.proxies.end(), "sip:121.40.49.168:6010;transport=tcp");
//    accCfg.videoConfig.autoShowIncoming = true;
//    accCfg.videoConfig.autoTransmitOutgoing = true;
//    account = new MyAccount(accCfg);
//    account->create(accCfg);
//    call = new MyCall(*(account), -1);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyRegState:(pjsip_status_code)code reason:(string)reason expiration:(int)expiration {
    
}

- (void)notifyIncomingCall:(MyCall *)call {
    
}

- (void)notifyCallState:(MyCall *)call {
    
}

- (void)notifyCallMediaState:(MyCall *)call {
    if (call->vidWin != NULL) {
        printf("fucker%i", call->wid);
        [self displayWindow: call->wid];
//         = new VideoWindowHandle();
//        Video
//        vidWH.handle.window = (__bridge void *)_imageWindow;
//        try {
//            call->vidWin->setWindow(vidWH);
//        } catch (exception e) {
//        }
    }
}

- (void)notifyBuddyState:(MyBuddy *)buddy {
    
}

- (void)displayWindow:(pjsua_vid_win_id)wid {
    int i, last;
    
    i = (wid == PJSUA_INVALID_ID) ? 0 : wid;
    last = (wid == PJSUA_INVALID_ID) ? PJSUA_MAX_VID_WINS : wid+1;
    
    for (;i < last; ++i) {
        pjsua_vid_win_info wi;
        
        if (pjsua_vid_win_get_info(i, &wi) == PJ_SUCCESS) {
            UIView *parent = _imageWindow;
            UIView *view = (__bridge UIView *)wi.hwnd.info.ios.window;
            
            if (view) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    /* Add the video window as subview */
                    if (![view isDescendantOfView:parent])
                        [parent addSubview:view];
                    
                    if (!wi.is_native) {
                        /* Resize it to fit width */
                        view.bounds = CGRectMake(0, 0, parent.bounds.size.width,
                                                 (parent.bounds.size.height *
                                                  1.0*parent.bounds.size.width/
                                                  view.bounds.size.width));
                        /* Center it horizontally */
                        view.center = CGPointMake(parent.bounds.size.width/2.0,
                                                  view.bounds.size.height/2.0);
                    } else {
                        /* Preview window, move it to the bottom */
                        view.center = CGPointMake(parent.bounds.size.width/2.0,
                                                  parent.bounds.size.height-
                                                  view.bounds.size.height/2.0);
                    }
                });
            }
        }
    }

}

@end
