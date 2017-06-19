//
//  ViewController.m
//  FlowLabel
//
//  Created by admin on 2017/6/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "FlowLabel.h"
#import "Father.h"
#import <objc/runtime.h>
#import "StockTimeView.h"

@interface ViewController ()

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, assign) NSUInteger a;

@property (nonatomic, retain) FlowLabel *flowLabel;

@property (nonatomic, retain) NSArray *titleArr;

@end

@implementation ViewController

+(void)load
{
    [super load];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.flowLabel = [[FlowLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
//    self.flowLabel.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:self.flowLabel];
//    self.titleArr = @[@"111111111111", @"222222222222", @"3333333333", @"44444444", @"555555555", @"66666666", @"7777777777"];
//    _a = 0;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(change) userInfo:nil repeats:YES];
    
    //Father *f = [[Father alloc] init];
    
//    Class newClass = objc_allocateClassPair([NSError class], "RuntimeErrorSubClass", 0);
//    class_addMethod(newClass, @selector(report), (IMP)ReportFunction, "v@:");
//    objc_registerClassPair(newClass);
//    
//    id instanceOfNewClass = [[newClass alloc] initWithDomain:@"someDomain" code:0 userInfo:nil];
//    [instanceOfNewClass performSelector:@selector(report)];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 1.2;
    CGFloat height = width * 0.8;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - width) / 2.0;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - height) / 2.0;
    CGRect rect = CGRectMake(x, y, width, height);
    StockTimeView *timeView = [[StockTimeView alloc] initWithFrame:rect];
    [self.view addSubview:timeView];
    
    
}




void ReportFunction(id self, SEL _cmd)
{
    NSLog(@"This object is %p", self);
    NSLog(@"Class is %@, and super is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 5; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = object_getClass(currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}


- (void)change
{
    [self.flowLabel setText:[self.titleArr objectAtIndex:self.a % self.titleArr.count] animated:YES];
    _a += 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
