//
//  Son.m
//  FlowLabel
//
//  Created by admin on 2017/6/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "Son.h"

@implementation Son

-(instancetype)init
{
    self = [super init];
    NSLog(@"self class-->%@",[self class]);
    NSLog(@"super class-->%@",[super class]);
    return self;
}


-(void)setName:(NSString *)name{
    NSLog(@"%s，%@", __PRETTY_FUNCTION__, @"会调用这个方法");
    if ([name isEqualToString:@""]){
        [NSException raise:NSInvalidArgumentException format:@"姓名不能为空"];
    }
    
    
}

@end
