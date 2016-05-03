//
//  ViewController.m
//  PNChartDemo
//
//  Created by cpo007@qq.com on 16/3/16.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "ViewController.h"
#import <PNChart.h>
typedef enum {
    ScrollDirectionLeft,
    ScrollDirectionRight
}ScrollDirection;
@interface ViewController ()<PNChartDelegate,UIScrollViewDelegate>
{
    
    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
    
}
@property(strong,nonatomic)PNLineChart *lineChart;
@property(strong,nonatomic)UIView *blueview;
@property(strong,nonatomic)NSMutableArray *numbers;
@property(strong,nonatomic)UIScrollView *scrollview;
@property(assign,nonatomic)int Direction;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //For Line Chart
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    self.scrollview = sc;
    sc.delegate = self;
    sc.backgroundColor = [UIColor redColor];
    sc.bounces = NO;
    [self.view addSubview:sc];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *numbers = [NSMutableArray array];
    self.numbers = numbers;
    for (int i =0; i<999; i++) {
        [array addObject:@"-"];
        int asda = i;
        NSInteger number = i % 300 ;
        [numbers addObject:@(number)];
    }
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0,array.count, 200.0)];

    lineChart.yFixedValueMax = 300;
    lineChart.thousandsSeparator = YES;
    lineChart.showCoordinateAxis = YES;
    lineChart.chartMarginLeft = 40;
    lineChart.chartMarginRight = 0;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor blueColor];
    self.blueview.frame = CGRectMake(0,0 , 5, 5);
    self.blueview = view;
    sc.contentSize = CGSizeMake(array.count , 0);
    [lineChart setXLabels:array];
    self.lineChart = lineChart;
    lineChart.delegate = self;
    [sc addSubview:lineChart];
    // Line Chart No.1
    NSArray * data01Array = numbers;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    [sc addSubview:view];

    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    self.scrollview.contentOffset = CGPointMake(self.scrollview.contentSize.width - self.view.frame.size.width, 0);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.lineChart.yFixedValueMax = 200;
    [self.lineChart strokeChart];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offset =  (scrollView.contentOffset.x) / (self.scrollview.contentSize.width -self.view.frame.size.width);

    CGPoint point = CGPointMake(offset * (scrollView.contentOffset.x+self.view.frame.size.width), scrollView.contentOffset.y);

//    NSLog(@"%@",NSStringFromCGPoint(point));
    [self.lineChart ViewDidScroll:point];
}
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    int index = point.x-1;
    if (index > 999 || index < 0) {
        return;
    }
     NSNumber  *number = [self.numbers objectAtIndex:index];
   NSString *str = self.lineChart.CGPointArray[index];
    CGPoint po = CGPointFromString(str);
    NSLog(@"%@",NSStringFromCGPoint(po));
    NSInteger num = [number integerValue];
//    CGFloat offset =  (self.view.frame.size.width-5) / (self.scrollview.contentSize.width - self.view.frame.size.width);
    self.blueview.frame = CGRectMake(0,0 , 5, 5);
    self.blueview.center = CGPointMake(po.x, po.y);
    NSLog(@"%@",NSStringFromCGRect(self.blueview.frame));


    
}
-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
//    NSLog(@"%@",NSStringFromCGPoint(point));
//    NSLog(@"%ld",lineIndex);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
