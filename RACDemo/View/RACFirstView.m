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
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *passwordLabel;
@property(nonatomic,strong)UITextField *userNameInput;
@property(nonatomic,strong)UITextField *passwordInput;




@end

@implementation RACFirstView

-(instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        [self configUIForView];
        [self intRacFoo];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)intRacFoo
{
    //单个信号量映射
//    RACSignal *userNameSingnal = [self.userNameInput.rac_textSignal map:^id (NSString * value) {
//
//        return @(value.length>0);
//    }];
    
    //多个输入框信号量元祖集合
    RACSignal *enabeldSignal = [[RACSignal combineLatest:@[self.userNameInput.rac_textSignal,self.passwordInput.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return @([value[0] length]>0&&[value[1] length]>=6);
    }];
    
    self.buttonFirst.rac_command = [[RACCommand alloc] initWithEnabled:enabeldSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

-(void)configUIForView
{
    self.buttonFirst = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"登陆" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor orangeColor]];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"点了");
        }];
        [self addSubview:button];
        button;
    });
    
    
    self.userNameLabel = ({
        UILabel *label  = [UILabel new];
        label.text = @"用户名";
        [self addSubview:label];
        label;
    });
    
    self.userNameInput =({
        UITextField *input = [UITextField new];
        input.placeholder = @"请输入用户名";
        [self addSubview:input];
        input;
    });
    
    
    self.passwordLabel = ({
        UILabel *label  = [UILabel new];
        label.text = @"密码";
        [self addSubview:label];
        label;
    });
    
    self.passwordInput =({
        UITextField *input = [UITextField new];
        input.placeholder = @"请输入密码";
        [self addSubview:input];
        input;
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
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonFirst.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.userNameInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonFirst.mas_bottom).offset(20);
        make.left.equalTo(self.userNameLabel.mas_right).offset(20);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(self.userNameLabel);
    }];
    
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(20);
        make.width.equalTo(self.userNameLabel);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(20);
        make.left.equalTo(self.passwordLabel.mas_right).offset(20);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(self.passwordLabel);
    }];
    
}

@end
