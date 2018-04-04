//
//  RACDemoViewController.m
//  GCDDemo
//
//  Created by jay on 2018/3/26.
//  Copyright © 2018年 曾辉. All rights reserved.
//

#import "RACDemoViewController.h"
#import "RACFirstView.h"
#import "RACSliderView.h"

@interface RACDemoViewController ()

@end

@implementation RACDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"响应式编程 demo";
    
    RACFirstView *firstView = [[RACFirstView alloc] initWithFrame:CGRectMake(0, 100, DEVICE_WIDTH, 200)];
    [self.view addSubview:firstView];
    
    RACSliderView *sliderView = [[RACSliderView alloc] initWithFrame:CGRectMake(0, 300, DEVICE_WIDTH, 400)];
    [self.view addSubview:sliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
