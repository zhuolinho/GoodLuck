//
//  MyApp.h
//  GoodLuck
//
//  Created by HoJolin on 15/8/1.
//
//

#ifndef __GoodLuck__MyApp__
#define __GoodLuck__MyApp__

#include <stdio.h>
#include <iostream>
#import "pjsua2.hpp"

using namespace pj;
using namespace std;

#define mUserName "9000"
#define mPassWord "p9000"

#define CHAR_AT "@"
#define SIP_PREFIX "sip:"
#define TRANSPORT_TCP_SUFFIX ";transport=tcp"
#define YARLUNG_SERVER_IP "121.40.49.168"
#define YARLUNG_SERVER_PORT "6010"
#define YARLUNG_SERVER YARLUNG_SERVER_IP ":" YARLUNG_SERVER_PORT
#define YARLUNG_PROXY SIP_PREFIX YARLUNG_SERVER TRANSPORT_TCP_SUFFIX
#define YARLUNG_REGISTRAR SIP_PREFIX YARLUNG_SERVER

class MyAppObserver;
class MyAccount;
class MyAccountConfig;

class MyLogWriter: public LogWriter {
    public:
    void write(const LogEntry &entry) {
        cout << entry.msg << endl;
    }
};

class MyApp {
public:
    static Endpoint *ep;
    static MyAppObserver *observer;
    vector<MyAccount*> accList;
private:
    vector<MyAccountConfig*> accCfgs;
    EpConfig *epConfig = new pj::EpConfig();
    TransportConfig *sipTpConfig = new TransportConfig();
    string appDir;
    MyLogWriter *logWriter;
    const string configName = "pjsua2.json";
    const int SIP_PORT = 6000;
    const int LOG_LEVEL = 5;    // Modified by wonder
public:
    void init(MyAppObserver &obs, string app_dir);
    void init(MyAppObserver &obs, string app_dir, bool own_worker_thread);
    MyAccount *addAcc(AccountConfig &cfg);
    void delAcc(MyAccount *acc);
    void buildAccConfigs();
    void deinit();
    static void initAccountConfigForYarlung(AccountConfig &accConfig);
};




#endif /* defined(__GoodLuck__MyApp__) */
