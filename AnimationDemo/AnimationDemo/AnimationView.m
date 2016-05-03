//
//  AnimationView.m
//  AnimationDemo
//
//  Created by cpo007@qq.com on 16/2/22.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.circlelayer = [CirCleLayer layer];
        self.circlelayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:self.circlelayer];
    }
    return self;
}
@end
