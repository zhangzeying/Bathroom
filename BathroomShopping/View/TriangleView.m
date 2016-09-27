//
//  TriangleView.m
//  BathroomShopping
//
//  Created by zzy on 9/8/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "TriangleView.h"
@implementation TriangleView

//绘制带箭头的矩形
- (void)drawArrowRectangle:(CGRect)frame {
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    //启始位置坐标x，y
    CGFloat origin_x = frame.origin.x;
    CGFloat origin_y = frame.origin.y;
    //第一条线的位置坐标
    CGFloat line_1_x = frame.size.width;
    CGFloat line_1_y = origin_y;
    //第二条线的位置坐标
    CGFloat line_2_x = line_1_x;
    CGFloat line_2_y = frame.size.height;
    //第三条线的位置坐标
    CGFloat line_3_x = origin_x + 20;
    CGFloat line_3_y = line_2_y;
    //尖角的顶点位置坐标
    CGFloat line_4_x = line_3_x - 5;
    CGFloat line_4_y = line_2_y + 10;
    //第五条线位置坐标
    CGFloat line_5_x = line_4_x - 5;
    CGFloat line_5_y = line_3_y;
    //第六条线位置坐标
    CGFloat line_6_x = origin_x;
    CGFloat line_6_y = line_2_y;
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    
    CGContextAddLineToPoint(ctx, line_1_x, line_1_y);
    CGContextAddLineToPoint(ctx, line_2_x, line_2_y);
    CGContextAddLineToPoint(ctx, line_3_x, line_3_y);
    CGContextAddLineToPoint(ctx, line_4_x, line_4_y);
    CGContextAddLineToPoint(ctx, line_5_x, line_5_y);
    CGContextAddLineToPoint(ctx, line_6_x, line_6_y);
    
    CGContextClosePath(ctx);
    
    UIColor *costomColor = [UIColor colorWithWhite:0 alpha:0.8];
    CGContextSetFillColorWithColor(ctx, costomColor.CGColor);
    
    CGContextFillPath(ctx);
}

//重写绘图，调用刚才绘图的方法
- (void)drawRect:(CGRect)rect {
    
    CGRect frame = rect;
    frame.size.height = frame.size.height -20;
    rect = frame;
    //绘制带箭头的框框
    [self drawArrowRectangle:rect];
}

@end
