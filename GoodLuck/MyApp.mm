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
    _ep.libCreate();
    _sipTpConfig.port = SIP_PORT;
    _epConfig.logConfig.level = LOG_LEVEL;
    _epConfig.logConfig.consoleLevel = LOG_LEVEL;
    return self;
}

@end
