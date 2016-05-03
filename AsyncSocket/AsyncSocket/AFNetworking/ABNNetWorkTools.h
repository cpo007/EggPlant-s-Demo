//
//  ABNNetWorkTools.h
//  AirBoxNex
//
//  Created by cpo007@qq.com on 16/2/15.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ABNNetWorkTools : AFHTTPSessionManager
typedef void (^ABNNetworkToolsCallBack)(id response,NSError *error);
typedef enum {
    GET,
    Post
    
}ABNRequestMethod;
+(instancetype)shareNetWorkTools;
-(void)requestNetWorkWithurlString:(NSString *)urlstring Params:(id)params method:(ABNRequestMethod)method callback:(ABNNetworkToolsCallBack )callbackBlock;

@end
