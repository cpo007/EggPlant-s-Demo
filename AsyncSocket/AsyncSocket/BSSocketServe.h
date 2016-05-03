//
//  BSSocketServe.h
//  AsyncSocket
//
//  Created by cpo007@qq.com on 16/3/18.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSocketServe : NSObject
@property(copy,nonatomic)void(^MessageBlock)(NSString *message);
@property(copy,nonatomic) NSString* (^CallBackBlock)(BOOL Success);

+(instancetype)shareSocketServe;
-(void)startSocket;
-(void)cutOffSocket;
- (void)sendMessage:(id)message;
@end
