//
//  CallingViewController.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/20.
//
//

#import "CallingViewController.h"
#import "AppDelegate.h"
#include "pjsua_app_common.h"
void ui_answer_call();
void ui_make_new_call();

@interface CallingViewController ()

@end

@implementation CallingViewController
- (IBAction)hangUpButtonClick:(UIButton *)sender {
    pjsua_call_hangup_all();
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentCall = NULL;
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)answerButtonClick:(UIButton *)sender {
    pjsua_call_set_vid_strm(current_call,
                            PJSUA_CALL_VID_STRM_ADD, NULL);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentCall = self;
    if (_toSip != NULL) {
        char str[100] = "sip:";
        ui_make_new_call(strcat(str, _toSip));
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
