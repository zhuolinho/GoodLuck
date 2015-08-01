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
    virtual void notifyRegState(pjsip_status_code code, std::string reason, int expiration) = 0;
    virtual void notifyIncomingCall(MyCall call) = 0;
    virtual void notifyCallState(MyCall call) = 0;
    virtual void notifyCallMediaState(MyCall call) = 0;
    virtual void notifyBuddyState(MyBuddy buddy) = 0;
};

class MyLogWriter: public pj::LogWriter {
public:
    void write(const pj::LogEntry &entry) {
        printf("%s\n", entry.msg.c_str());
    }
};

class MyBuddy: public pj::Buddy {
public:
    pj::BuddyConfig cfg;
    MyBuddy(pj::BuddyConfig config): Buddy() {
        cfg = config;
    }
    
    std::string getStatusText(){
        pj::BuddyInfo bi;
        try{
            bi = getInfo();
        } catch(std::exception e){
            return "?";
        }
        
        String status = "Unknown";
        
    }
    
    void onBuddyState() {
        
    }
};



class MyAccount: public pj::Account {
public:
    pj::BuddyVector buddyList;
    pj::AccountConfig cfg;
    MyAccount(pj::AccountConfig config): Account(){
        cfg = config;
    }
    MyBuddy* addBuddy(pj::BuddyConfig bud_cfg) {
        MyBuddy *bud = new MyBuddy(bud_cfg);
        try {
            bud->create(*this, bud_cfg);
        } catch (std::exception e) {
            bud->~MyBuddy();
            bud = NULL;
        }
        if (bud != NULL) {
            buddyList.push_back(bud);
            if (bud_cfg.subscribe)
                try {
                    bud->subscribePresence(true);
                } catch (std::exception e) {
                }
        }
        return bud;
    }
    void delBuddy(MyBuddy *buddy) {
        for (pj::BuddyVector::iterator it = buddyList.begin(); it != buddyList.end(); ++it)
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
    void onRegState(pj::OnRegStateParam &prm) {
        MyApp::observer.notifyRegState(prm.code, prm.reason, prm.expiration);
    }
    void onIncomingCall(pj::OnIncomingCallParam &prm);
    void onInstantMessage(pj::OnInstantMessageParam &prm) {
        printf("======== Incoming pager ========\n");
        printf("From     : %s\n", prm.fromUri.c_str());
        printf("To       : %s\n", prm.toUri.c_str());
        printf("Contact  : %s\n", prm.contactUri.c_str());
        printf("Mimetype : %s\n", prm.contentType.c_str());
        printf("Body     : %s\n", prm.msgBody.c_str());
    }
};



class MyCall: public pj::Call {
public:
    pj::VideoWindow *vidWin;
    MyCall(MyAccount &acc, int call_id): Call(acc, call_id) {
        vidWin = NULL;
    }
};

void MyAccount::onIncomingCall(pj::OnIncomingCallParam &prm) {
    printf("======== Incoming call ========\n");
    MyCall *call = new MyCall(*this, prm.callId);
    MyApp::observer.notifyIncomingCall(*call);
}



//class MyApp {
//};