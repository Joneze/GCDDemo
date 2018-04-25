//
//  ViewController.m
//  GCDDemo
//
//  Created by jay on 2018/3/12.
//  Copyright © 2018年 曾辉. All rights reserved.
//  GCDdemo

#import "ViewController.h"
#import "GCDDemoViewController.h"
#import "RACDemoViewController.h"
#import "RuntimeDemoViewController.h"
#import "QRCodeViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *cellArrData;

@end

@implementation ViewController


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf3f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主页面";
    [self confinCellData];
    [self.view addSubview:self.tableView];
    
    
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellWithIdentifier = @"mainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.cellArrData[indexPath.section];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            GCDDemoViewController *gcdView = [GCDDemoViewController new];
            [self.navigationController pushViewController:gcdView animated:YES];
        }
            break;
        
        case 1:
        {
            RACDemoViewController *racView = [RACDemoViewController new];
            [self.navigationController pushViewController:racView animated:YES];
        }
            break;
            
        case 2:
        {
            RuntimeDemoViewController *racView = [RuntimeDemoViewController new];
            [self.navigationController pushViewController:racView animated:YES];
        }
            break;
        case 3:
        {
            QRCodeViewController *racView = [QRCodeViewController new];
            [self.navigationController pushViewController:racView animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)confinCellData{
    self.cellArrData = @[@"GCD Demo",@"RAC demo",@"Runtime demo",@"二维码生成"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
