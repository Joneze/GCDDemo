//
//  Person.h
//  GCDDemo
//
//  Created by jay on 2018/4/18.
//  Copyright © 2018年 曾辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSNumber *age;

-(void)fun1;
-(void)fun2;
-(void)fun3;
-(void)fun4;

@end
