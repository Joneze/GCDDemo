//
//  RACSliderView.m
//  GCDDemo
//
//  Created by jay on 2018/4/4.
//  Copyright © 2018年 曾辉. All rights reserved.
//

#import "RACSliderView.h"

@interface RACSliderView ()
@property(nonatomic,strong)UILabel *redLabel ;
@property(nonatomic,strong)UILabel *blueLabel ;
@property(nonatomic,strong)UILabel *greenLabel ;

@property(nonatomic,strong)UISlider *redSlider;
@property(nonatomic,strong)UISlider *blueSlider;
@property(nonatomic,strong)UISlider *greenSlider;

@property(nonatomic,strong)UITextField *redTextfield;
@property(nonatomic,strong)UITextField *blueTextfield;
@property(nonatomic,strong)UITextField *greenTextfield;

@property(nonatomic,strong)UIView *colorBGM;

@end

@implementation RACSliderView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUIForView];
        [self fooRAC];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)fooRAC
{
    RACSignal *redSignal = [self blindSlider:self.redSlider textField:self.redTextfield];
    RACSignal *blueSignal = [self blindSlider:self.blueSlider textField:self.blueTextfield];
    RACSignal *greenSignal = [self blindSlider:self.greenSlider textField:self.greenTextfield];
    RACSignal *changeSignal = [[RACSignal combineLatest:@[redSignal,blueSignal,greenSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[2] floatValue] blue:[value[1] floatValue] alpha:1];
    }];
    
    RAC(self.colorBGM,backgroundColor) = changeSignal;
    
}

-(RACSignal *)blindSlider:(UISlider *)slider textField:(UITextField *)textField
{
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalTextfield = [textField rac_newTextChannel];
    
    [signalTextfield subscribe:signalSlider];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }]subscribe:signalTextfield];
    
    return [[signalSlider merge:signalTextfield] merge:textSignal];
}

-(void)configUIForView
{
    self.redLabel = ({
        UILabel *label  = [UILabel new];
        label.text = @"R";
        [self addSubview:label];
        label;
    });
    
    self.blueLabel = ({
        UILabel *label  = [UILabel new];
        label.text = @"B";
        [self addSubview:label];
        label;
    });
    
    self.greenLabel = ({
        UILabel *label  = [UILabel new];
        label.text = @"G";
        [self addSubview:label];
        label;
    });
    
    self.redSlider = ({
        UISlider *slider = [UISlider new];
        [self addSubview:slider];
        slider;
    });
    
    self.blueSlider = ({
        UISlider *slider = [UISlider new];
        [self addSubview:slider];
        slider;
    });
    
    self.greenSlider = ({
        UISlider *slider = [UISlider new];
        [self addSubview:slider];
        slider;
    });
    
    self.redTextfield =({
        UITextField *input = [UITextField new];
        input.text = @"0.5";
        input.borderStyle = UITextBorderStyleLine;
        [self addSubview:input];
        input;
    });
    
    self.blueTextfield =({
        UITextField *input = [UITextField new];
        input.text = @"0.5";
        input.borderStyle = UITextBorderStyleLine;
        [self addSubview:input];
        input;
    });
    
    self.greenTextfield =({
        UITextField *input = [UITextField new];
        input.text = @"0.5";
        input.borderStyle = UITextBorderStyleLine;
        [self addSubview:input];
        input;
    });
    
    self.colorBGM  = ({
        UIView *bgm = [UIView new];
        bgm.backgroundColor = [UIColor redColor];
        [self addSubview:bgm];
        bgm;
    });
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.redSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redLabel);
        make.left.equalTo(self.redLabel.mas_right).offset(10);
    }];
    
    [self.redTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redLabel);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self.redSlider.mas_right).offset(10);
        make.width.mas_equalTo(40);
    }];
    
    [self.blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.blueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueLabel);
        make.left.equalTo(self.blueLabel.mas_right).offset(10);
    }];
    
    [self.blueTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueLabel);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self.blueSlider.mas_right).offset(10);
        make.width.mas_equalTo(40);
    }];
    
    [self.greenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(20);
    }];
    
    [self.greenSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.greenLabel);
        make.left.equalTo(self.greenLabel.mas_right).offset(10);
    }];
    
    [self.greenTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.greenLabel);
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self.greenSlider.mas_right).offset(10);
        make.width.mas_equalTo(40);
    }];
    
    [self.colorBGM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.greenLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo(140);
    }];
    
}

@end
