//
//  RACDemoViewController.m
//  GCDDemo
//
//  Created by jay on 2018/3/26.
//  Copyright © 2018年 曾辉. All rights reserved.
//

#import "RACDemoViewController.h"
#import "RACFirstView.h"
@interface RACDemoViewController ()

@end

@implementation RACDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"响应式编程 demo";
    
    RACFirstView *firstView = [[RACFirstView alloc] initWithFrame:CGRectMake(0, 100, DEVICE_WIDTH, 100)];
    
        
    [self.view addSubview:firstView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
