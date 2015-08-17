//
//  MyPJ.cpp
//  GoodLuck
//
//  Created by HoJolin on 15/8/6.
//
//

#include "MyPJ.h"
#import "AppDelegate.h"

void MyLogWriter::write(const LogEntry &entry) {
    cout << entry.msg << endl;
}

MyAccount::MyAccount(AccountConfig &config): Account(){
    cfg = config;
}
MyBuddy* MyAccount::addBuddy(BuddyConfig &bud_cfg) {
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
void MyAccount::delBuddy(MyBuddy *buddy) {
    for (vector<MyBuddy*>::iterator it = buddyList.begin(); it != buddyList.end(); ++it)
    {
        if (*it == buddy) {
            buddyList.erase(it);
            break;
        }
    }
}
void MyAccount::delBuddy(int index) {
    buddyList.erase(buddyList.begin() + index);
}
void MyAccount::onRegState(OnRegStateParam &prm) {
    [[AppDelegate getApp].observer notifyRegState:prm.code reason:prm.reason expiration:prm.expiration];
}
void MyAccount::onInstantMessage(OnInstantMessageParam &prm) {
    cout << "======== Incoming pager ========\n";
    cout << "From     : " << prm.fromUri << endl;
    cout << "To       : " << prm.toUri << endl;
    cout << "Contact  : " << prm.contactUri << endl;
    cout << "Mimetype : " << prm.contentType << endl;
    cout << "Body     : " << prm.msgBody << endl;
}

void MyAccount::onIncomingCall(OnIncomingCallParam &prm) {
    cout << "======== Incoming call ========\n";
    MyCall *call = new MyCall(*this, prm.callId);
    [[AppDelegate getApp].observer notifyIncomingCall:call];
}

MyCall::MyCall(MyAccount &acc, int call_id): Call(acc, call_id){
    vidWin = NULL;
    wid = INVALID_ID;
}

void MyCall::onCallState(OnCallStateParam &prm) {
    [[AppDelegate getApp].observer notifyCallState:this];
    try {
        CallInfo ci = getInfo();
        if (ci.state == PJSIP_INV_STATE_DISCONNECTED) {
            this->~MyCall();
        }
    } catch (exception e) {
        return;
    }
}

void MyCall::onCallMediaState(OnCallMediaStateParam &prm) {
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
        printf("shit%i", cmi.type);
        if (cmi.type == PJMEDIA_TYPE_AUDIO && (cmi.status == PJSUA_CALL_MEDIA_ACTIVE || cmi.status == PJSUA_CALL_MEDIA_REMOTE_HOLD)) {
            // unfortunately, on Java too, the returned Media cannot be
            // downcasted to AudioMedia
            Media *m = getMedia(i);
            AudioMedia am = *AudioMedia::typecastFromMedia(m);
            // connect ports
            try {
                cout << "Wonder: onCallMediaState() startTransmit\n";
//                am.startTransmit([AppDelegate getApp]->ep.audDevManager().getPlaybackDevMedia());
//                [AppDelegate getApp]->ep.audDevManager().getCaptureDevMedia().startTransmit(am);
//                am.startTransmit([AppDelegate getApp]->ep.audDevManager().getCaptureDevMedia());
            } catch (exception e) {
                continue;
            }
        } else if (cmi.type == PJMEDIA_TYPE_VIDEO && cmi.status == PJSUA_CALL_MEDIA_ACTIVE && cmi.videoIncomingWindowId != INVALID_ID) {
            vidWin = new VideoWindow(cmi.videoIncomingWindowId);
            wid = cmi.videoIncomingWindowId;
        }
    }
    [[AppDelegate getApp].observer notifyCallMediaState:this];
}

void MyCall::onStreamCreated(OnStreamCreatedParam &prm) {
    cout << "Wonder: onStreamCreated()\n";
    
}

MyBuddy::MyBuddy(BuddyConfig &config): Buddy() {
    cfg = config;
}

string MyBuddy::getStatusText() {
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

void MyBuddy::onBuddyState() {
    [[AppDelegate getApp].observer notifyBuddyState:this];
}

void MyAccountConfig::readObject(ContainerNode &node){
    try{
        ContainerNode acc_node = node.readContainer("Account");
        accCfg.readObject(acc_node);
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

void MyAccountConfig::writeObject(ContainerNode &node) {
    try{
        ContainerNode acc_node = node.writeNewContainer("Account");
        accCfg.writeObject(acc_node);
        ContainerNode buddies_node = acc_node.writeNewArray("buddies");
        for (vector<BuddyConfig*>::iterator it = buddyCfgs.begin(); it != buddyCfgs.end(); ++it)
        {
            (*it)->writeObject(buddies_node);
        }
    }catch(exception e){
    }
}
