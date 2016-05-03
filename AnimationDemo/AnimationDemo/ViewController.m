//
//  ViewController.m
//  AnimationDemo
//
//  Created by cpo007@qq.com on 16/2/22.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property(strong,nonatomic)AnimationView *animationview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AnimationView *view = [[AnimationView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-320/2, self.view.frame.size.height/2-320/2, 320, 320)];
    view.backgroundColor = [UIColor blueColor];
    self.animationview = view;
    [self.view addSubview:view];
    self.animationview.circlelayer.progress =self.slider.value;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)valuehadChanged:(UISlider *)sender {
    self.animationview.circlelayer.progress =sender.value;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
