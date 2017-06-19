//
//  Father.m
//  FlowLabel
//
//  Created by admin on 2017/6/6.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "Father.h"

@implementation Father

-(instancetype)init
{
    self = [super init];
    
    self.name = @"";
    return self;
}

-(void)setName:(NSString *)name
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _name = name;
}

@end
