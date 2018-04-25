//
//  RuntimeDemoViewController.m
//  GCDDemo
//
//  Created by jay on 2018/4/18.
//  Copyright © 2018年 曾辉. All rights reserved.
// 如何使用Runtime获取一个类的成员变量，属性，方法，协议。如何动态修改一个类的变量值，如何交换方法的实现，如何动态添加类。

#import "RuntimeDemoViewController.h"
#import "Person.h"
#import <objc/runtime.h>
@interface RuntimeDemoViewController ()

@end

@implementation RuntimeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"runtime";
    [self getAllIvars];
    
    //获取方法列表
    [self getFunctionLists];
    
    //交换fun1和fun2里面的实现
    [self exchangeFunction];
    Person *person = [Person new];
    [person fun1];
    [person fun2];
    
    //动态创建类
    [self addMethodFromRuntime];
}


#pragma mark  ======== //获取类属性 =========
//获取类属性
-(void)getAllIvars{
    Person *person = [Person new];
    person.name = @"张三";
    person.age = @25;
    
    //获取所以成员变量
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([person class], &count);
    
    //先打印看看没有改变变量值的时候
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"看看成员变量:%@",[NSString stringWithUTF8String:ivar_getName(ivar)]);
    }
    
    //修改name变量
    Ivar ivar = class_getInstanceVariable([Person class], "_name");
    object_setIvar(person, ivar, @"王五");
    
    NSLog(@"%@||%@",person.name,object_getIvar(person, ivar));
    
    free(ivars);
    
}

#pragma mark  ======== //获取方法列表 =========
//获取方法列表

/**
 只要是在.m文件中实现的方法，不管又没有在.h文件中声明，都会被找到。不过若是在.h中声明的方法，没有在.m中实现的方法，是不会被找到的。
 1)SEL其实就是一个整形标识，用来唯一标识一个方法名而已。而IMP是一个函数指针，表示方法实现的代码块地址。
 2) OC在编译时会为每个方法的名字生成一个唯一的整型标识来替代方法名，这个整型标识就是SEL。在一个类中是不可能存在两个同名的方法的，
 即使参数类型不同也不行。但是不同的类是可以有相同的SEL的，即使这些类有继承关系也行。因为不同的类，调用方法的对象实例是不一样的。
 
 3) 在一个工程中，所有的SEL会组成一个set集合，这就意味着不会有重复的SEL。
 */
-(void)getFunctionLists
{
    unsigned int count;
    //所有在.m文件里的方法都能被找到
    Method *methods = class_copyMethodList([Person class], &count);
    
    for (int i =0; i<count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSLog(@"看看分发表里的方法：%@",NSStringFromSelector(sel));
    }
    free(methods);
}


#pragma mark  ======== //交换方法 =========
/**
 SEL method_getName(Method m); //获取方法名
 IMP method_getImplementation(Method m)； //返回方法的实现
 
 IMP  method_setImplementation(Method m, IMP imp); //设置方法的实现
 void method_exchangeImplementations(Method m1,Method m2); //交换两个方法的实现
 
 SEL sel_registerName(const char *str) //在objective-C Runtime系统中注册一个方法，将
      方法名映射到一个选择器，并返回这个选择器
 */
-(void)exchangeFunction{
    Method method1 = class_getInstanceMethod([Person class], @selector(fun1));
    Method method2 = class_getInstanceMethod([Person class], @selector(fun2));
    
    method_exchangeImplementations(method1, method2);
}


#pragma mark  ======== 动态创建类 =========
-(void)addMethodFromRuntime
{
    Class cls = objc_allocateClassPair([NSObject class], "runtimeClass", 0);
    
    class_addIvar(cls, "name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    class_addIvar(cls, "age", sizeof(int), sizeof(int), @encode(int));
    SEL s = sel_registerName("testRuntimeMethod");
    class_addMethod(cls, s, (IMP)testRuntimeMethodIMP, "i@:@");
    
    objc_registerClassPair(cls);
    
    
    id person = [cls new];
    NSLog(@"实例所属类:%@，实例所属类的父类:%@",object_getClass(person),class_getSuperclass(object_getClass(person)));

    Ivar nameIvar = class_getInstanceVariable(cls, "name");
    [person setValue:@"xiaFan" forKey:@"name"];
    
    Ivar ageIvar = class_getInstanceVariable(cls, "age");
    object_setIvar(person, ageIvar, @18);
    
    NSLog(@"看看实例变量值的person的值%@||%@",object_getIvar(person, nameIvar),object_getIvar(person, ageIvar));
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"giy",@"name",@"25",@"age", nil];
    [person performSelector:@selector(testRuntimeMethod) withObject:dic];
}

void testRuntimeMethodIMP(id self , SEL _cmd, NSDictionary *dic)
{
    NSLog(@"打印传递进来的dic：%@",dic);
    NSLog(@"成员变量的名称%@",object_getIvar(self, class_getInstanceVariable([self class], "name")));
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
