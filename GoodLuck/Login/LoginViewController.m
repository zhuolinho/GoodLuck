//
//  ScanViewController.m
//  ShareSDKDemo
//
//  Created by shenyang on 15/9/3.
//  Copyright (c) 2015年 shenyang. All rights reserved.
//

#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "API.h"
#import "ScanViewController.h"
#import "MainTabBarController.h"
#import "tabBarController.h"

@interface LoginViewController ()<APIProtocol>
{
    API *myAPI;
    int ifScan;
}

@end

@implementation LoginViewController

- (IBAction)scanButtonClick:(UIButton *)sender {
//    [myAPI login];
    ifScan = 1;
}

- (IBAction)wxButtonClick:(UIButton *)sender {
//    [myAPI login];
    ifScan = 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    ifScan = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接情况" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
    ifScan = -1;
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSString *status_code = data[@"status_code"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([status_code  isEqual: @"0"]) {
            NSDictionary *res = data[@"data"];
            NSLog(@"%@",res);
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:res[@"userId"] forKey:@"userId"];
            [ud setObject:res[@"userName"] forKey:@"userName"];
            [ud setObject:res[@"password"] forKey:@"password"];
            [ud synchronize];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainTabBar" bundle:nil];
            tabBarController *vc = (tabBarController *)[mainStoryboard instantiateInitialViewController];
            [self presentViewController:vc animated:true completion:nil];
        }
        else if (ifScan == 1) {
            ScanViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanViewController"];
            [self.navigationController pushViewController:vc animated:true];
        }
    });
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
