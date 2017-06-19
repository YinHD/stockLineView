//
//  StockTimeView.m
//  FlowLabel
//
//  Created by admin on 2017/6/14.
//  Copyright © 2017年 admin. All rights reserved.
//

#define VW self.frame.size.width
#define VH self.frame.size.height

#import "StockTimeView.h"

@interface StockTimeView ()

@property (nonatomic, copy) NSString *high;

@property (nonatomic, copy) NSString *close;

@property (nonatomic, copy) NSString *low;

@property (nonatomic, strong) NSMutableArray *priceArr;

@property (nonatomic, strong) CALayer *heartLayer;

@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, strong) CATextLayer *timeTextLayer;

@property (nonatomic, strong) CATextLayer *priceTextLayer;

@property (nonatomic, strong) CAShapeLayer *crossLayer;

@end

@implementation StockTimeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self getData];
        [self drawFrame];
        [self drawLine];
        [self setupHeartLayer];
        [self addGesture];
    }
    return self;
}

- (void)getData
{
    self.priceArr = [NSMutableArray array];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"getcurrencylist" ofType:nil];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:NSJSONReadingMutableLeaves error:nil];
    self.high = ((NSNumber *)[dataDic objectForKey:@"High"]).stringValue;
    self.close = ((NSNumber *)[dataDic objectForKey:@"Yclose"]).stringValue;
    self.low = ((NSNumber *)[dataDic objectForKey:@"Low"]).stringValue;
    __weak typeof(self)_self = self;
    //eNSArray *recordsArr = [dataDic objectForKey:@"records"];
    [[dataDic objectForKey:@"records"] enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *priceNum = obj.firstObject;
        NSArray *locArr = @[@([_self priceLocationWithPrice:priceNum.floatValue]), @(_self.frame.size.width*4/5 / ((NSArray *)[dataDic objectForKey:@"records"]).count * idx)];
        [_self.priceArr addObject:locArr];
        
    }];
    NSNumber *lastY = ((NSArray *)_self.priceArr.lastObject).firstObject;
    NSNumber *lastX = ((NSArray *)_self.priceArr.lastObject).lastObject;
    self.currentPoint = CGPointMake(lastX.floatValue, lastY.floatValue);
    
}

- (void)drawLine
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i < self.priceArr.count; i++) {
        
        
        if (i==0) {
            [path moveToPoint:CGPointMake(0, VH - 60)];
            [path addLineToPoint:CGPointMake(((NSNumber *)((NSArray *)self.priceArr[i]).lastObject).floatValue, ((NSNumber *)((NSArray *)self.priceArr[i]).firstObject).floatValue)];
        }else{
            [path addLineToPoint:CGPointMake(((NSNumber *)((NSArray *)self.priceArr[i]).lastObject).floatValue, ((NSNumber *)((NSArray *)self.priceArr[i]).firstObject).floatValue)];
        }
        
        if (i == self.priceArr.count - 1) {
            
            [path addLineToPoint:CGPointMake(((NSNumber *)((NSArray *)self.priceArr[i]).lastObject).floatValue, VH - 60)];
        }
    }
    
    
    CAShapeLayer *timeLayer = [CAShapeLayer layer];
    timeLayer.strokeColor = [UIColor blueColor].CGColor;
    timeLayer.fillColor = [UIColor colorWithRed:175.0/255.0 green:221.0/255.0 blue:227.0/255.0 alpha:.6].CGColor;
    timeLayer.path = path.CGPath;
    
    [self.layer addSublayer:timeLayer];
    

    
}

- (void)drawFrame
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //价格线
    CGFloat rowSpace = (VH - 60.0) / 2.0;
    
    for (int i = 0; i < 3; i++) {
        [path moveToPoint:CGPointMake(0, i*rowSpace)];
        [path addLineToPoint:CGPointMake(VW, i*rowSpace)];
        if (i == 0) {
            CGRect rect = CGRectMake(-30, rowSpace*i - 10, 30, 20);
            [self drawLabelAtRect:rect text:self.high];
        }else if (i == 1){
            CGRect rect = CGRectMake(-30, rowSpace*i - 10, 30, 20);
            [self drawLabelAtRect:rect text:self.close];
        }else{
            CGRect rect = CGRectMake(-30, rowSpace*i - 10, 30, 20);
            [self drawLabelAtRect:rect text:self.low];
        }
    }
    
    //时间线
    CGFloat colSpace = VW / 4.0;
    NSString *timeStr = @"";
    for (int i = 0; i < 5; i++) {
        [path moveToPoint:CGPointMake(i*colSpace, VH - 60)];
        [path addLineToPoint:CGPointMake(i*colSpace, 0)];
        CGRect rect = CGRectMake(colSpace*i, VH - 60, 60, 20);
        if (i == 0) {
            timeStr = @"9:30";
        }else if (i == 1){
            timeStr = @"10:30";
        }else if (i == 2){
            timeStr = @"11:30/13:00";
        }else if (i == 3){
            timeStr = @"14:00";
        }else{
            timeStr = @"15:00";
        }
        [self drawLabelAtRect:rect text:timeStr];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
}

- (void)drawLabelAtRect:(CGRect)rect text:(NSString *)textStr
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = rect;
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    CFStringRef fontName = (__bridge CFStringRef)([UIFont systemFontOfSize:10].fontName);
    textLayer.font = CGFontCreateWithFontName(fontName);
    textLayer.fontSize = 10;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    textLayer.string = textStr;
    [self.layer addSublayer:textLayer];
}

- (void)drawLabelWithTextLayer:(CATextLayer *)textLayer rect:(CGRect)rect text:(NSString *)textStr
{
    textLayer.frame = rect;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    CFStringRef fontName = (__bridge CFStringRef)([UIFont systemFontOfSize:10].fontName);
    textLayer.font = CGFontCreateWithFontName(fontName);
    textLayer.fontSize = 10;
    textLayer.contentsScale = [UIScreen mainScreen].scale;

    textLayer.string = textStr;
    [self.layer addSublayer:textLayer];
}



- (CGFloat)priceLocationWithPrice:(CGFloat)price
{
    CGFloat height = VH - 60;
    CGFloat avgSpace = height / (self.high.floatValue - self.low.floatValue);
    return height - (price - self.low.floatValue) * avgSpace;
}

- (NSString *)priceNumWithLocation:(CGFloat)location
{
    CGFloat height = VH - 60;
    CGFloat avgSpace = (self.high.floatValue - self.low.floatValue) / height;
    
    return [NSString stringWithFormat:@"%.2f",47.35 - location * avgSpace];
}

- (NSString *)timeWithLocation:(CGFloat)location
{
    //每分钟代表的宽度
    CGFloat avgSpace = 4 * 60 / VH;
    NSInteger disHour = location / avgSpace / 60;
    NSInteger disMinute = location / avgSpace  - disHour * 60;
    
    if (location >= VW * 1/2) {//位于11:30/13:00 - 14:00
       
        disHour = disHour + 13;
        
        
    }else if (location < VW * 1/2){//9:30 - 11:30
        
        disHour = disHour + 9;
        
    }else{//14:00
        
        
    }
    
    return [NSString stringWithFormat:@"%ld:%02ld", (long)disHour, (long)disMinute];
}


- (void)setupHeartLayer
{
    self.heartLayer = [CALayer layer];
    self.heartLayer.frame = CGRectMake(0, 0, 4, 4);
    self.heartLayer.hidden = NO;
    self.heartLayer.backgroundColor = [UIColor redColor].CGColor;
    self.heartLayer.position = self.currentPoint;
    self.heartLayer.cornerRadius = self.heartLayer.bounds.size.width * .5;
    self.heartLayer.borderColor = [UIColor redColor].CGColor;
    self.heartLayer.masksToBounds = YES;
    [self.layer addSublayer:self.heartLayer];
    [self heartAnimationWithLayer:self.heartLayer];
}

- (void)heartAnimationWithLayer:(CALayer *)heartLayer
{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = .5f;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = @1.5;
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.toValue = @.6;
    group.animations = @[scaleAnimation, alphaAnimation];
    [heartLayer addAnimation:group forKey:nil];
}

- (void)drawCrossLineWithPoint:(CGPoint)point
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(point.x, 0)];
    [path addLineToPoint:CGPointMake(point.x, VH - 60)];
    
    [path moveToPoint:CGPointMake(0, point.y)];
    [path addLineToPoint:CGPointMake(VW, point.y)];
    
    
    self.crossLayer.strokeColor = [UIColor redColor].CGColor;
    //[crossLayer setLineDashPhase:2];
    //[crossLayer setLineWidth:1];
    [self.crossLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:1],nil]];
    self.crossLayer.path = path.CGPath;
    [self.layer addSublayer:_crossLayer];
    
}

//添加手势
- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [self addGestureRecognizer:tap];
    
}

- (void)tapClicked:(UITapGestureRecognizer *)tap
{
    [self.crossLayer removeFromSuperlayer];
    [self.priceTextLayer removeFromSuperlayer];
    [self.timeTextLayer removeFromSuperlayer];
    self.crossLayer = nil;
    CGPoint point = [tap locationInView:self];
    
    if (point.x >= VW*4/5) {
        
        point = CGPointMake(VW*4/5, point.y);
    }
    if (point.y <= 0) {
        
        point = CGPointMake(point.x, 0);
    }
    
    //找出距离最小的点
    NSInteger idx = point.x / (VW*4/5 / self.priceArr.count);
    point = CGPointMake(((NSNumber *)((NSArray *)self.priceArr[idx - 1]).lastObject).floatValue, ((NSNumber *)((NSArray *)self.priceArr[idx - 1]).firstObject).floatValue);
    
    [self drawCrossLineWithPoint:point];
    
    [self drawLabelWithTextLayer:self.timeTextLayer rect:CGRectMake(point.x, VH-35, 30, 10) text:[self timeWithLocation:point.x]];
    [self drawLabelWithTextLayer:self.priceTextLayer rect:CGRectMake(0, point.y, 30, 10) text:[self priceNumWithLocation:point.y]];
}

#pragma mark - lazy

-(CAShapeLayer *)crossLayer
{
    if (!_crossLayer) {
        
        _crossLayer = [CAShapeLayer layer];
    }
    return _crossLayer;
}

-(CATextLayer *)priceTextLayer
{
    if (!_priceTextLayer) {
        
        _priceTextLayer = [CATextLayer layer];
    }
    
    return _priceTextLayer;
}

-(CATextLayer *)timeTextLayer
{
    if (!_timeTextLayer) {
        _timeTextLayer = [CATextLayer layer];
    }
    return _timeTextLayer;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
