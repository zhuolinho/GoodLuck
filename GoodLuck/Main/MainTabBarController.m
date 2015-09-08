//
//  MainTabBarController.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/19.
//
//

#import "MainTabBarController.h"
//#include "pjsua_app_cli.c"


@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // Do any additional setup after loading the view.
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//    pjsua_acc_config acc_cfg;
//    pj_status_t status;
//
//    pjsua_acc_config_default(&acc_cfg);
//    acc_cfg.id = cval->argv[1];
//    acc_cfg.reg_uri = cval->argv[2];
//    acc_cfg.cred_count = 1;
//    acc_cfg.cred_info[0].scheme = pj_str("Digest");
//    acc_cfg.cred_info[0].realm = cval->argv[3];
//    acc_cfg.cred_info[0].username = cval->argv[4];
//    acc_cfg.cred_info[0].data_type = 0;
//    acc_cfg.cred_info[0].data = cval->argv[5];
//    
////    acc_cfg.rtp_cfg = app_config.rtp_cfg;
//    app_config_init_video(&acc_cfg);
//    
//    status = pjsua_acc_add(&acc_cfg, PJ_TRUE, NULL);
//    [AppDelegate setObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveMsg:(const char *)msg {
    printf("shit %s\n", msg);
//    char str[10];
//    if (msg[0] == "T" && msg[1] == ) {
//        ui_add_account()
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
