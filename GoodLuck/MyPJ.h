//
//  MyPJ.h
//  GoodLuck
//
//  Created by HoJolin on 15/8/6.
//
//

#ifndef __GoodLuck__MyPJ__
#define __GoodLuck__MyPJ__

#include <iostream>
#include "pjsua2.hpp"

using namespace pj;
using namespace std;

class MyBuddy: public Buddy {
public:
    BuddyConfig cfg;
    MyBuddy(BuddyConfig &config);
    string getStatusText();
    void onBuddyState();
};

class MyLogWriter: public LogWriter {
public:
    void write(const LogEntry &entry);
};

class MyAccount: public Account {
public:
    vector<MyBuddy*> buddyList;
    AccountConfig cfg;
    MyAccount(AccountConfig &config);
    MyBuddy* addBuddy(BuddyConfig &bud_cfg);
    void delBuddy(MyBuddy *buddy);
    void delBuddy(int index);
    void onRegState(OnRegStateParam &prm);
    void onIncomingCall(OnIncomingCallParam &prm);
    void onInstantMessage(OnInstantMessageParam &prm);
};

class MyCall: public Call {
public:
    VideoWindow *vidWin;
    pjsua_vid_win_id wid;
    MyCall(MyAccount &acc, int call_id);
    void onCallState(OnCallStateParam &prm);
    void onCallMediaState(OnCallMediaStateParam &prm);
    void onStreamCreated(OnStreamCreatedParam &prm);
};

class MyAccountConfig {
public:
    AccountConfig accCfg;
    vector<BuddyConfig*> buddyCfgs;
    void readObject(ContainerNode &node);
    void writeObject(ContainerNode &node);
};

#endif /* defined(__GoodLuck__MyPJ__) */
