//
//  CirCleLayer.m
//  AnimationDemo
//
//  Created by cpo007@qq.com on 16/2/22.
//  Copyright © 2016年 Origins. All rights reserved.
//

#import "CirCleLayer.h"
#import <UIKit/UIKit.h>
#define outsideRectSize 90
typedef enum{
    Point_B,
    Point_D
}movePoint;
@interface CirCleLayer ()
@property(assign,nonatomic)movePoint movePoint;
@property(assign,nonatomic)CGRect outsideRect;


@end
@implementation CirCleLayer

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (progress<0.5) {
        NSLog(@"向左移动");
        self.movePoint = Point_D;
    }else{
        NSLog(@"向右移动");
        self.movePoint = Point_B;
    }
    CGFloat outsideRectX = self.position.x-outsideRectSize/2+(progress-0.5)*self.frame.size.width;
    CGFloat outsideRectY = self.position.y-outsideRectSize/2;

    self.outsideRect = CGRectMake(outsideRectX, outsideRectY, outsideRectSize, outsideRectSize);
    [self setNeedsDisplay];
}
-(void)drawInContext:(CGContextRef)ctx{
    CGFloat offset = self.outsideRect.size.width/3.6;
    CGFloat moveDistance = (self.outsideRect.size.width *1/6)*fabs(self.progress-0.5)*2;
    CGPoint rectcenter = CGPointMake(self.outsideRect.origin.x+self.outsideRect.size.width/2, self.outsideRect.origin.y+self.outsideRect.size.height/2);
    
    CGPoint pointA = CGPointMake(rectcenter.x, self.outsideRect.origin.y+moveDistance);
    CGPoint pointB = CGPointMake(self.movePoint == Point_D?rectcenter.x+self.outsideRect.size.width/2:rectcenter.x + self.outsideRect.size.width/2 + moveDistance*2,rectcenter.y);
    CGPoint pointC = CGPointMake(rectcenter.x, rectcenter.y+self.outsideRect.size.height/2-moveDistance);
    CGPoint pointD = CGPointMake(self.movePoint == Point_D?self.outsideRect.origin.x - moveDistance*2:self.outsideRect.origin.x, rectcenter.y);
    CGPoint c1 = CGPointMake(pointA.x+offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x,self.movePoint == Point_D?pointB.y-offset:pointB.y-offset+moveDistance );
    CGPoint c3 = CGPointMake(pointB.x, self.movePoint== Point_D?pointB.y + offset:pointB.y+offset -moveDistance);
    CGPoint c4 = CGPointMake(pointC.x+offset, pointC.y);
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movePoint == Point_D?pointD.y+offset-moveDistance:pointD.y+offset);
    CGPoint c7 = CGPointMake(pointD.x, self.movePoint == Point_D?pointD.y-offset+moveDistance:pointD.y-offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
    UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectpath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGFloat dash[] = {5.0,5.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    CGContextStrokePath(ctx);
    
    UIBezierPath *ovalpath = [UIBezierPath bezierPath];
    [ovalpath moveToPoint:pointA];
    [ovalpath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalpath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalpath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalpath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalpath closePath];
    
    CGContextAddPath(ctx , ovalpath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
    
    
}
@end
