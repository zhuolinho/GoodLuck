//
//  API.h
//  GoodLuck
//
//  Created by HoJolin on 15/8/22.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define HOST @"http://120.24.255.55:9000"

@protocol APIProtocol;

@interface API : NSObject

@property (nonatomic) id<APIProtocol> delegate;

- (void)regScan:(NSString *)username password:(NSString *)password;
- (void)login;

//- (void)post:(NSString *)action dic:(NSDictionary *)dic;
+ (UIImage *)getPicByKey:(NSString *)key;
+ (void)setPicByKey:(NSString *)key pic:(UIImage *)pic;

@end

@protocol APIProtocol <NSObject>

- (void)didReceiveAPIResponseOf: (API *)api data: (NSDictionary *)data;
- (void)didReceiveAPIErrorOf: (API *)api data: (int)errorNo;

@end