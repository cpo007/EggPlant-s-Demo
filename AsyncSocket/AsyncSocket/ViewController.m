//
//  ViewController.m
//  AsyncSocket
//
//  Created by cpo007@qq.com on 16/3/18.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "ViewController.h"
#import "BSSocketServe.h"
#import "ABNNetWorkTools.h"
#import "BSDes.h"
#import "MBProgressHUD+ZJ.h"
#define APIUpdate @"http://api.origins-china.cn:30600/getfile"
//?filename=LasereggV16.03-002
@interface ViewController ()
@property(strong,nonatomic)NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *Connect;
@property (weak, nonatomic) IBOutlet UIButton *Download;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Connect.enabled = NO;
    
       // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}
- (IBAction)download:(UIButton*)sender {
    sender.enabled = NO;
    NSLog(@"%@",self.textField.text);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.textField.text,@"filename", nil];
    NSLog(@"%@",dic);
    [[ABNNetWorkTools shareNetWorkTools]requestNetWorkWithurlString:APIUpdate Params:dic method:Post callback:^(id response, NSError *error) {
        NSLog(@"%@",response);
        if ([[response valueForKey:@"code"] integerValue] != 200 || error ){
            [MBProgressHUD showError:@"你输入的版本号有误"];
            sender.enabled = YES;
            return;
        }
        self.Connect.enabled = YES;
        NSDictionary *datas = [response valueForKey:@"data"];
        NSString *str = [datas valueForKey:@"data"];
        NSData *data = [BSDes dataWithBase64EncodedString:str];
        NSInteger number = data.length/1024;
        NSMutableArray *daArray = [NSMutableArray array];
        for (int i = 0 ; i< number+1; i++) {
            NSInteger p = i*1024;
            NSRange range = NSMakeRange(p, 1024);
            if (data.length - p < 1024) {
                range = NSMakeRange(p,data.length - p );
            }
            
            NSData *da = [data subdataWithRange:range];
            [daArray addObject:da];
            
        }
        self.array = daArray;
        self.label.text = [NSString stringWithFormat:@"目前数据为:%ld组",self.array.count];
    }];

}
- (IBAction)buttonDidClick:(id)sender {
    [[BSSocketServe shareSocketServe]startSocket];
    [[BSSocketServe shareSocketServe]setMessageBlock:^void (NSString *message) {
        NSLog(@"%@",message);
        if ([message isEqualToString:@"LASEREGG:OUI;"]) {
            [[BSSocketServe shareSocketServe]sendMessage:@"again"];
            return;
        }
        
        if ([message hasPrefix:@"LASEREGG:WANT"]) {
            NSString * index = [message substringWithRange:NSMakeRange(14, 4)];
            int number = [index intValue];
            NSLog(@"%d",number);
            NSData *da = self.array[number];
            
            //            NSString *sr = [[NSString alloc]initWithData:da encoding:NSASCIIStringEncoding];
            NSString *lastString = @"TBC";
            NSLog(@"%ld",da.length);
            if (da.length < 1024) {
                lastString = @"FIN";
            }
            
            NSString *header_s = [NSString stringWithFormat:@"APP:DATA(%@)[%04ld]{",index,da.length];
            NSData *header_d =[header_s dataUsingEncoding:NSASCIIStringEncoding];
            NSString *tail_s = [NSString stringWithFormat:@"}[CR]%@;",lastString];
            NSData *tail_d =[tail_s dataUsingEncoding:NSASCIIStringEncoding];
            
            NSMutableData *payload = [[NSMutableData alloc]init];
            [payload appendData:header_d];
            [payload appendData:da];
            [payload appendData:tail_d];
            
            
            [[BSSocketServe shareSocketServe]sendMessage:payload];
            NSLog(@"%@",payload);

            return;
        }
        if ([message isEqualToString:@"LASEREGG:SUCCEED!"]) {
            NSLog(@"上传成功");
            [[BSSocketServe shareSocketServe]cutOffSocket];
            return;
        }
        
    }];

}

- (IBAction)reduction:(id)sender {
    self.textField.text = @"LasereggV16.03-002";
    self.Download.enabled = YES;
    [self.array removeAllObjects];
    self.label.text = [NSString stringWithFormat:@"目前数据为:%ld组",self.array.count];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
