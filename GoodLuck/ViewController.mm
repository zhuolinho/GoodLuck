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

@end

@implementation ViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    [AppDelegate getApp].observer = self;
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
    
}

- (void)notifyBuddyState:(MyBuddy *)buddy {
    
}

@end
