//
//  MyApp.cpp
//  GoodLuck
//
//  Created by HoJolin on 15/8/1.
//
//

#include "MyApp.h"

class MyCall;
class MyAccount;
class MyBuddy;

class MyAppObserver {
public:
    virtual void notifyRegState(pjsip_status_code &code, string reason, int expiration) = 0;
    virtual void notifyIncomingCall(MyCall &call) = 0;
    virtual void notifyCallState(MyCall &call) = 0;
    virtual void notifyCallMediaState(MyCall &call) = 0;
    virtual void notifyBuddyState(MyBuddy &buddy) = 0;
};

class MyBuddy: public Buddy {
public:
    BuddyConfig cfg;
    MyBuddy(BuddyConfig &config): Buddy() {
        cfg = config;
    }
    
    string getStatusText() {
        BuddyInfo bi;
        try{
            bi = getInfo();
        } catch(exception e){
            return "?";
        }
        
        string status = "Unknown";
        if (bi.subState == PJSIP_EVSUB_STATE_ACTIVE) {
            if (bi.presStatus.status == PJSUA_BUDDY_STATUS_ONLINE) {
                status = bi.presStatus.statusText;
                if (status.length() == 0) {
                    status = "Online";
                }
            }else if (bi.presStatus.status == PJSUA_BUDDY_STATUS_OFFLINE) {
                status = "Offline";
            }else {
                status = "Unknown";
            }
        }
        return status;
    }
    
    void onBuddyState() {
        MyApp::observer->notifyBuddyState(*this);
    }
};



class MyAccount: public Account {
public:
    vector<MyBuddy*> buddyList;
    AccountConfig cfg;
    MyAccount(AccountConfig &config): Account(){
        cfg = config;
    }
    MyBuddy* addBuddy(BuddyConfig &bud_cfg) {
        MyBuddy *bud = new MyBuddy(bud_cfg);
        try {
            bud->create(*this, bud_cfg);
        } catch (exception e) {
            bud->~MyBuddy();
            bud = NULL;
        }
        if (bud != NULL) {
            buddyList.push_back(bud);
            if (bud_cfg.subscribe)
                try {
                    bud->subscribePresence(true);
                } catch (exception e) {
                }
        }
        return bud;
    }
    void delBuddy(MyBuddy *buddy) {
        for (vector<MyBuddy*>::iterator it = buddyList.begin(); it != buddyList.end(); ++it)
        {
            if (*it == buddy) {
                buddyList.erase(it);
                break;
            }
        }
        
    }
    void delBuddy(int index) {
        buddyList.erase(buddyList.begin() + index);
    }
    void onRegState(OnRegStateParam &prm) {
        MyApp::observer->notifyRegState(prm.code, prm.reason, prm.expiration);
    }
    void onIncomingCall(OnIncomingCallParam &prm);
    void onInstantMessage(OnInstantMessageParam &prm) {
        cout << "======== Incoming pager ========\n";
        cout << "From     : " << prm.fromUri << endl;
        cout << "To       : " << prm.toUri << endl;
        cout << "Contact  : " << prm.contactUri << endl;
        cout << "Mimetype : " << prm.contentType << endl;
        cout << "Body     : " << prm.msgBody << endl;
    }
};

class MyCall: public Call {
public:
    VideoWindow *vidWin;
    MyCall(MyAccount &acc, int call_id): Call(acc, call_id) {
        vidWin = NULL;
    }
    void onCallState(OnCallStateParam &prm) {
        MyApp::observer->notifyCallState(*this);
        try {
            CallInfo ci = getInfo();
            if (ci.state == PJSIP_INV_STATE_DISCONNECTED) {
                this->~MyCall();
            }
        } catch (exception e) {
            return;
        }
    }
    void onCallMediaState(OnCallMediaStateParam &prm) {
        CallInfo ci;
        try {
            ci = getInfo();
        } catch (exception e) {
            return;
        }
        CallMediaInfoVector cmiv = ci.media;
        cout << "Wonder: onCallMediaState() cmiv.size=" << cmiv.size() << endl;
        for (int i = 0; i < cmiv.size(); i++) {
            CallMediaInfo cmi = cmiv[i];
            if (cmi.type == PJMEDIA_TYPE_AUDIO && (cmi.status == PJSUA_CALL_MEDIA_ACTIVE || cmi.status == PJSUA_CALL_MEDIA_REMOTE_HOLD)) {
                // unfortunately, on Java too, the returned Media cannot be
                // downcasted to AudioMedia
                Media *m = getMedia(i);
                AudioMedia am = *AudioMedia::typecastFromMedia(m);
                // connect ports
                try {
                    cout << "Wonder: onCallMediaState() startTransmit\n";
                    MyApp::ep->audDevManager().getCaptureDevMedia().
                    startTransmit(am);
                    am.startTransmit(MyApp::ep->audDevManager().getPlaybackDevMedia());
                } catch (exception e) {
                    continue;
                }
            } else if (cmi.type == PJMEDIA_TYPE_VIDEO && cmi.status == PJSUA_CALL_MEDIA_ACTIVE && cmi.videoIncomingWindowId != INVALID_ID) {
                vidWin = new VideoWindow(cmi.videoIncomingWindowId);
            }
        }
        MyApp::observer->notifyIncomingCall(*this);
    }
    void onStreamCreated(OnStreamCreatedParam &prm) {
        cout << "Wonder: onStreamCreated()\n";
    }
};

void MyAccount::onIncomingCall(OnIncomingCallParam &prm) {
    cout << "======== Incoming call ========\n";
    MyCall *call = new MyCall(*this, prm.callId);
    MyApp::observer->notifyIncomingCall(*call);
}

class MyAccountConfig {
public:
    AccountConfig *accCfg = new AccountConfig();
    vector<BuddyConfig*> buddyCfgs;
    
    void readObject(ContainerNode &node){
        try{
            ContainerNode acc_node = node.readContainer("Account");
            accCfg->readObject(acc_node);
            ContainerNode buddies_node = acc_node.readArray("buddies");
            buddyCfgs.clear();
            while (buddies_node.hasUnread()) {
                BuddyConfig *bud_cfg = new BuddyConfig();
                bud_cfg->readObject(buddies_node);
                buddyCfgs.push_back(bud_cfg);
            }
        } catch (exception e) {
        }
    }
    
    void writeObject(ContainerNode &node){
        try{
            ContainerNode acc_node = node.writeNewContainer("Account");
            accCfg->writeObject(acc_node);
            ContainerNode buddies_node = acc_node.writeNewArray("buddies");
            for (vector<BuddyConfig*>::iterator it = buddyCfgs.begin(); it != buddyCfgs.end(); ++it)
            {
                (*it)->writeObject(buddies_node);
            }
        }catch(exception e){
        }
    }
    
};

void MyApp::init(MyAppObserver &obs, string app_dir) {
    init(obs, app_dir, false);
}

void MyApp::init(MyAppObserver &obs, string app_dir, bool own_worker_thread) {
    observer = &obs;
    appDir = app_dir;
    try {
        ep->libCreate();
    } catch (exception e) {
        return;
    }
    string configPath = appDir + "/" + configName;
//    File f = new File(configPath);
    if (false) {
//        loadConfig(configPath);
    } else {
        /* Set 'default' values */
        sipTpConfig->port = SIP_PORT;
    }
    epConfig->logConfig.level = LOG_LEVEL;
    epConfig->logConfig.consoleLevel = LOG_LEVEL;
    LogConfig log_cfg = epConfig->logConfig;
    logWriter = new MyLogWriter();
    log_cfg.writer = logWriter;
    log_cfg.decor = log_cfg.decor & ~(PJ_LOG_HAS_CR | PJ_LOG_HAS_NEWLINE);
    UaConfig ua_cfg = epConfig->uaConfig;
    ua_cfg.userAgent = "PjsipiOS";
    StringVector stun_servers;
    stun_servers.push_back(YARLUNG_SERVER_IP);
    ua_cfg.stunServer = stun_servers;
    if (own_worker_thread) {
        ua_cfg.threadCnt = 0;
        ua_cfg.mainThreadOnly = true;
    }
    try {
        ep->libInit(*epConfig);
    } catch (exception e) {
        return;
    }
    try {
        ep->transportCreate(PJSIP_TRANSPORT_UDP, *sipTpConfig);
    } catch (exception e) {
        cout << &e << endl;
    }
    try {
        ep->transportCreate(PJSIP_TRANSPORT_TCP, *sipTpConfig);
    } catch (exception e) {
        cout << &e << endl;
    }
    for (int i = 0; i < accCfgs.size(); i++) {
        MyAccountConfig my_cfg = *accCfgs[i];
        
        /* Customize account config */
        my_cfg.accCfg->natConfig.iceEnabled = true;
        my_cfg.accCfg->videoConfig.autoTransmitOutgoing = true;
        my_cfg.accCfg->videoConfig.autoShowIncoming = true;
        
        initAccountConfigForYarlung(*my_cfg.accCfg);    // Added by wonder
        
        MyAccount *acc = addAcc(*my_cfg.accCfg);
        if (acc == NULL) continue;
        
        /* Add Buddies */
        for (int j = 0; j < my_cfg.buddyCfgs.size(); j++) {
            BuddyConfig bud_cfg = *my_cfg.buddyCfgs[j];
            acc->addBuddy(bud_cfg);
        }
    }
    try {
        ep->libStart();
    } catch (exception e) {
        return;
    }
}

MyAccount *MyApp::addAcc(AccountConfig &cfg) {
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

void MyApp::delAcc(MyAccount *acc) {
    for (vector<MyAccount*>::iterator it = accList.begin(); it != accList.end(); ++it)
    {
        if (*it == acc) {
            accList.erase(it);
            break;
        }
    }
}

void MyApp::buildAccConfigs() {
    /* Sync accCfgs from accList */
    accCfgs.clear();
    for (int i = 0; i < accList.size(); i++) {
        MyAccount acc = *accList[i];
        MyAccountConfig *my_acc_cfg = new MyAccountConfig();
        my_acc_cfg->accCfg = &acc.cfg;
        
        my_acc_cfg->buddyCfgs.clear();
        for (int j = 0; j < acc.buddyList.size(); j++) {
            MyBuddy *bud = acc.buddyList[j];
            my_acc_cfg->buddyCfgs.push_back(&bud->cfg);
        }
        
        accCfgs.push_back(my_acc_cfg);
    }
}

void MyApp::initAccountConfigForYarlung(AccountConfig &accConfig) {
    string username = mUserName;
    string password = mPassWord;
    string proxy = YARLUNG_PROXY;
    string registrar = YARLUNG_REGISTRAR;
    
    if (username.length() == 0 || password.length() == 0) {
        return;
    }
    accConfig.idUri = SIP_PREFIX mUserName CHAR_AT YARLUNG_SERVER;
    accConfig.natConfig.iceEnabled = true;
    accConfig.regConfig.registrarUri = registrar;
    
}

