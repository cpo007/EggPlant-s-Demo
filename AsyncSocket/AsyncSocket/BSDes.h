//
//  BSDes.h
//  AsyncSocket
//
//  Created by cpo007@qq.com on 16/3/23.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDes : NSObject

+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

@end
