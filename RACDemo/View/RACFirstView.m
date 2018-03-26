//
//  RACFirstView.m
//  GCDDemo
//
//  Created by jay on 2018/3/26.
//  Copyright © 2018年 曾辉. All rights reserved.
//

#import "RACFirstView.h"


@interface RACFirstView ()
@property(nonatomic,strong)UIButton *buttonFirst;
@end

@implementation RACFirstView

-(instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        [self configUIForView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)configUIForView
{
    self.buttonFirst = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"点我啊" forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"点了");
            NSLog(@"--- %@",x);
        }];
        [button setBackgroundColor:[UIColor redColor]];
        [self addSubview:button];
        button;
    });
    
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.buttonFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-50);
        make.height.mas_equalTo(50);
    }];
}

@end
