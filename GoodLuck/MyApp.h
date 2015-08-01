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
#import "pjsua2.hpp"

class MyAppObserver;

class MyApp {
public:
    static pj::Endpoint ep;
    static MyAppObserver observer;
};




#endif /* defined(__GoodLuck__MyApp__) */
