//
//  API.m
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import "API.h"

static NSMutableDictionary *picDic;

@implementation API

- (void)post:(NSString *)action dic:(NSDictionary *)dic {
    NSString *str = [NSString stringWithFormat:@"%@/Yarlung/User/%@", HOST, action];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"1000912345" forHTTPHeaderField:@"uuid"];
//    NSDictionary *json = @{@"userName" : @"123", @"pasword" : @"789"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError == nil) {
            NSError *err = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            if(jsonObject != nil && err == nil){
                if([jsonObject isKindOfClass:[NSDictionary class]]){
                    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
//                    long errNo = [deserializedDictionary[@"errno"] integerValue];
//                    if (errNo == 0) {
                        if (self->_delegate) {
                            [self->_delegate didReceiveAPIResponseOf:self data:deserializedDictionary];
                        }
//                    }
//                    else {
//                        if (self->_delegate) {
//                            [self->_delegate didReceiveAPIErrorOf:self data:errNo];
//                        }
//                    }
                }else if([jsonObject isKindOfClass:[NSArray class]]){
                    if (self->_delegate) {
                        [self->_delegate didReceiveAPIErrorOf:self data:-999];
                    }
                }
            }
            else if(err != nil){
                if (self->_delegate) {
                    [self->_delegate didReceiveAPIErrorOf:self data:-777];
                }
            }
        }
        else {
            if (self->_delegate) {
                [self->_delegate didReceiveAPIErrorOf:self data:-888];
            }
        }
    }];
}

- (void)regScan:(NSString *)username password:(NSString *)password {
    [self post:@"Regscan.action" dic:@{@"userName": username, @"password": password}];
}

- (void)login {
    [self post:@"Login.action" dic:@{}];
}

+ (UIImage *)getPicByKey:(NSString *)key {
    if (picDic != nil) {
        return [picDic objectForKey:key];
    }
    return nil;
}

+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic {
    if (picDic == nil) {
        picDic = [[NSMutableDictionary alloc]init];
    }
    [picDic setValue:pic forKey:key];
}


@end
