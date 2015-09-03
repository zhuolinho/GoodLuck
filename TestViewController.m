//
//  TestViewController.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import "TestViewController.h"
#import "API.h"

@interface TestViewController ()<APIProtocol> {
    API *myAPI;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [[API alloc]init];
    myAPI.delegate = self;
    
//    NSURL *url = [NSURL URLWithString:@"http://120.24.255.55:9000/Yarlung/User/Regscan.action"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    [request setValue:@"1234567890" forHTTPHeaderField:@"uuid"];
//    NSDictionary *json = @{@"userName" : @"123", @"password" : @"789"};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
//    request.HTTPBody = data;
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSError *err = nil;
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
//        if(jsonObject != nil && err == nil){
//            NSLog(@"Successfully deserialized … ");
//            if([jsonObject isKindOfClass:[NSDictionary class]]){
//                NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
//                NSLog(@"Dersialized JSON Dictionary = %@",deserializedDictionary);
//            }else if([jsonObject isKindOfClass:[NSArray class]]){
//                NSArray *deserializedArray = (NSArray *)jsonObject;
//                NSLog(@"Dersialized JSON Array =%@",deserializedArray);
//            }
//        }
//        else if(err != nil){
//            NSLog(@"An error happened while deserializing the JSON data.");
//        }
//    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [myAPI regScan:@"123" password:@"789"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveAPIErrorOf:(API *)api data:(int)errorNo {
    NSLog(@"%d", errorNo);
}

- (void)didReceiveAPIResponseOf:(API *)api data:(NSDictionary *)data {
    NSLog(@"%@", data);
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
