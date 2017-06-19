//
//  FlowLabel.m
//  FlowLabel
//
//  Created by admin on 2017/6/5.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FlowLabel.h"

typedef void(^PrepareBlock)(UILabel *preLabel);

typedef void(^TransitionBlock)(UILabel *toExitLabel, UILabel *toEnterLabel);

@interface FlowLabel ()

@property (nonatomic, copy) PrepareBlock prepareBlock;

@property (nonatomic, copy) TransitionBlock transitionBlock;

@property (nonatomic, retain) NSArray *labels;

@property (nonatomic, assign) NSInteger currentLabelIndex;

@property (nonatomic, retain) UILabel *currentLabel;

@end


@implementation FlowLabel

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self configureLabels];
        [self configureBlocks];
    }
    return self;
}

#pragma mark - configure

- (void)configureLabels
{
    NSInteger count = 2;
    self.currentLabelIndex = 0;
    NSMutableArray *labelsArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.hidden = NO;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        [labelsArr addObject:label];
    }
    _labels = labelsArr;
    _currentLabel = _labels[0];
    _currentLabel.hidden = NO;
}

- (void)configureBlocks
{
    self.prepareBlock = ^(UILabel *preLabel){
      
        CGRect frame = preLabel.frame;
        frame.origin.y = self.bounds.size.height;
        
        preLabel.frame = frame;
        preLabel.alpha = 0;
    };
    
    self.transitionBlock = ^(UILabel *toExitLabel, UILabel *toEnterLabel) {
        
        toExitLabel.alpha = 0;
        toEnterLabel.alpha = 1;
        
        CGRect frame = toExitLabel.frame;
        CGRect enterFrame = toEnterLabel.frame;
        
        frame.origin.y = -self.bounds.size.height;
        enterFrame.origin.y = self.bounds.size.height / 2 - enterFrame.size.height / 2;
        
        toExitLabel.frame = frame;
        toEnterLabel.frame = enterFrame;
    };
}

- (void)setText:(NSString *)text animated:(BOOL)animated
{
    NSInteger nextLabelIndex = [self nextLabelIndex];
    UILabel *nextLabel = [self.labels objectAtIndex:nextLabelIndex];
    UILabel *preLabel = _currentLabel;
    
    nextLabel.text = text;
    [self resetLabelWithLabel:nextLabel];
    
    _currentLabel = nextLabel;
    _currentLabelIndex = nextLabelIndex;
    
    if (_prepareBlock) {
        _prepareBlock(nextLabel);
    }else{
        nextLabel.alpha = 1;
    }
    
    void (^changeBlock)() = ^(){
      
        if (_transitionBlock) {
            
            _transitionBlock(preLabel, nextLabel);
        }else{
            
            preLabel.alpha = 1;
            nextLabel.alpha = 1;
        }
    };
    
    void (^completionBlock)(BOOL) = ^(BOOL finished){
      
        if (finished) {
            preLabel.alpha = 0;
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:2.0 animations:changeBlock completion:completionBlock];
    }
}

- (NSUInteger)nextLabelIndex
{
    return (_currentLabelIndex + 1) % [_labels count];
}

- (void)resetLabelWithLabel:(UILabel *)label
{
    label.frame = self.bounds;
    label.alpha = 1.f;
}

@end
