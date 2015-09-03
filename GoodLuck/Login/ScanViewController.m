//
//  ScanViewController.m
//  ShareSDKDemo
//
//  Created by shenyang on 15/9/3.
//  Copyright (c) 2015年 shenyang. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "API.h"
#import "MainTabBarController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, APIProtocol, UIAlertViewDelegate> {
    API *myAPI;
}

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Device
    _device = [ AVCaptureDevice defaultDeviceWithMediaType : AVMediaTypeVideo ];
    
    // Input
    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self . device error : nil ];
    
    // Output
    _output = [[ AVCaptureMetadataOutput alloc ] init ];
    [ _output setMetadataObjectsDelegate : self queue : dispatch_get_main_queue ()];
    
    // Session
    _session = [[ AVCaptureSession alloc ] init ];
    [ _session setSessionPreset : AVCaptureSessionPresetHigh ];
    if ([ _session canAddInput : self . input ])
    {
        [ _session addInput : self . input ];
    }
    
    if ([ _session canAddOutput : self . output ])
    {
        [ _session addOutput : self . output ];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output . metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ] ;
    
    // Preview
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
    _preview . videoGravity = AVLayerVideoGravityResizeAspectFill ;
    _preview . frame = self . view . layer . bounds ;
    [ self . view . layer insertSublayer : _preview atIndex : 0 ];
    // Start
    [ _session startRunning ];
    
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count ] > 0 )
    {
        // 停止扫描
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        stringValue = metadataObject. stringValue ;
        NSArray *array = [stringValue componentsSeparatedByString:@";"];
        if (array.count == 2) {
            [ _session stopRunning ];
            [myAPI regScan:array[0] password:array[1]];
        }
    }
    
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接情况" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    });
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSLog(@"%@", data);
    NSString *status_code = data[@"status_code"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([status_code  isEqual: @"0"]) {
            NSDictionary *res = data[@"data"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:res[@"userId"] forKey:@"userId"];
            [ud setObject:res[@"userName"] forKey:@"userName"];
            [ud setObject:res[@"password"] forKey:@"password"];
            [ud synchronize];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainTabBarController *vc = (MainTabBarController *)[mainStoryboard instantiateInitialViewController];
            [self presentViewController:vc animated:true completion:nil];
        }
        else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邀请码有误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
    });
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:true];
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
