//
//  BSSocketServe.m
//  AsyncSocket
//
//  Created by cpo007@qq.com on 16/3/18.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "BSSocketServe.h"
#import "AsyncSocket.h"


#define HOST @"20.16.1.1"
#define PORT 21601
#define TIME_OUT 20

typedef enum {
    SocketOffLineByServe ,
    SocketOffLineByUser ,
    SocketOffLineByWiFiCut
}SocketOffLineBy;



@interface BSSocketServe ()<AsyncSocketDelegate>
@property(strong,nonatomic)AsyncSocket *socket;

@end
@implementation BSSocketServe


+(instancetype)shareSocketServe{
    static BSSocketServe * socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[[self class] alloc]init];
    });
    return socket;
}
-(void)startSocket{
    self.socket = [[AsyncSocket alloc]initWithDelegate:self];
    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if (![self SocketOpen:HOST port:PORT]) {
        
    }
   
}
-(NSInteger)SocketOpen:(NSString *)addr port:(NSInteger)port{
    if (![self.socket isConnected]) {
        NSError *error = nil;
        [self.socket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error];
    }
    
    return 0;
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"成功连接");
//    [self sendMessage:@"APP:BONJOUR(V16.03-002)"];
   NSString * str =  self.CallBackBlock(YES);
    [self sendMessage:str];
    
    
}

-(void)cutOffSocket{
    [self.socket disconnect];
}
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
    if (err.code == 57) {
        self.socket.userData = SocketOffLineByWiFiCut;
    }

    
}
-(void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"7878 sorry the connect is failure %ld",sock.userData);
    
    if (sock.userData == SocketOffLineByUser) {
        // 服务器掉线，重连
        [self startSocket];
    }
    else if (sock.userData == SocketOffLineByUser) {
        
        // 如果由用户断开，不进行重连
        return;
    }else if (sock.userData == SocketOffLineByWiFiCut) {
        
        // wifi断开，不进行重连
        return;
    }
    
}

- (void)sendMessage:(id)message
{
    if ([message isKindOfClass:[NSString class]]) {
        NSData *cmdData = [message dataUsingEncoding:NSASCIIStringEncoding];
        [self.socket writeData:cmdData withTimeout:-1 tag:1];
        

    }else{
        [self.socket writeData:message withTimeout:-1 tag:1];
    }
    //像服务器发送数据
}

//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:1024 tag:0];
}

//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    self.MessageBlock(str);

    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
//    if( data.length < 1024 )
//    {
//        //收到结果解析...
//        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
//        //解析出来的消息，可以通过通知、代理、block等传出去
//        
//    }
}

@end
