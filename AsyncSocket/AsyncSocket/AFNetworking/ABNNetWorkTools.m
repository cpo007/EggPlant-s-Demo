//
//  ABNNetWorkTools.m
//  AirBoxNex
//
//  Created by cpo007@qq.com on 16/2/15.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "ABNNetWorkTools.h"

@implementation ABNNetWorkTools

+(instancetype)shareNetWorkTools{
    static ABNNetWorkTools *networktools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networktools = [[ABNNetWorkTools alloc]init];
    });
    return networktools;
}
-(void)requestUploadWithurlString:(NSString *)urlstring Params:(id)params callback:(ABNNetworkToolsCallBack)callbackBlock{
    
}
-(void)requestNetWorkWithurlString:(NSString *)urlstring Params:(id)params method:(ABNRequestMethod)method callback:(ABNNetworkToolsCallBack)callbackBlock{
    if (method == GET) {
        [self GET:urlstring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            callbackBlock(responseObject,nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            callbackBlock(nil,error);
        }];
    }else{
        [self POST:urlstring parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            callbackBlock(responseObject,nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            callbackBlock(nil,error);
        }];
    }
}


@end
