//
//  ViewController.m
//  GCDDemo
//
//  Created by jay on 2018/3/12.
//  Copyright © 2018年 曾辉. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self serialDispatchQueue]; //串行列队
    
//    [self concurrentDispatchQueue];//并行列队
//    [self concurrentQueueApply]; //并发队列的应用 6个任务完成后刷新UI
//    [self multipleRequestsApply]; //限制线程个数的多任务并发应用
    [self SemaphoreDemo]; //Semaphore信号量的应用
}

#pragma mark  ======== 串行列队 =========
//串行队列
-(void)serialDispatchQueue{
    
    //首先创建一个全局列队 global 也可以直接创建serial 正常情况global用在并发列队里
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //DISPATCH_QUEUE_PRIORITY_DEFAULT 默认优先级，第二个传递除0之外的任何值都可能导致NULL返回值。
    
    //创建串行列队
    const char *serialQueueIdentifier = "gcdDemoSerialQueue";
    dispatch_queue_t serialQueue = dispatch_queue_create(serialQueueIdentifier, DISPATCH_QUEUE_SERIAL);
    //测试是否锁死阻塞线程
    
    //建立多个串行任务
    //在当前globalQueue线程执行队列
    dispatch_async(globalQueue, ^{
        
        NSLog(@"--- 0000");
        
        dispatch_async(serialQueue, ^{
            sleep(4);
            NSLog(@"---- 1111");
        });
        
        
        dispatch_async(serialQueue, ^{
            sleep(1);
            NSLog(@"---- 2222");
        });
        
        //回跳转到主线程、注意此线程如果直接在主线程调用，会导致锁死，蹦掉
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"有没有同步主线程?");
//        });
        
        dispatch_async(serialQueue, ^{
            NSLog(@"---- 3333");
        });
        
        NSLog(@"---- 提交结束");
    });
    
    //打印结果 1、0000 2、 提交结束 3、 1111 ，4、2222， 5、3333，注意加了sleep能更好的理解同步的概念, 有意思的是在中间加了跳转到主线程后发现打印顺序有变化。
    
}

#pragma mark  ======== 并行列队 =========
-(void)concurrentDispatchQueue{
    
    //使用信号量来管理并发任务
    
    //首先创建一个全局列队 global
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //DISPATCH_QUEUE_PRIORITY_DEFAULT 默认优先级，第二个传递除0之外的任何值都可能导致NULL返回值。
    
    //创建并行列队
    const char *concurrentQueueIdentifier = "gcdDemoConcurrentQueue";
    dispatch_queue_t concurrentQueue = dispatch_queue_create(concurrentQueueIdentifier, DISPATCH_QUEUE_CONCURRENT);
    
    //多个并行任务
    dispatch_async(globalQueue, ^{
        
        NSLog(@"第一个走的？");
        
        dispatch_async(concurrentQueue, ^{
            NSLog(@"first blood");
        });
        
        dispatch_async(concurrentQueue, ^{
            sleep(2);
            NSLog(@"double kill");
        });
        
        dispatch_async(concurrentQueue, ^{
            NSLog(@"triple kill");
        });
        
        dispatch_async(concurrentQueue, ^{
            NSLog(@"quadra kill");
        });
        
        dispatch_async(concurrentQueue, ^{
            NSLog(@"penta kill");
        });
        
        NSLog(@"ace");
        
        //你会发现打印出来的可能性大多数是按顺序来的，因为程序执行的顺序就是这个顺序，如果在性能稳定一样的情况下确实是正常的。然后加上sleep就会发现跟串行的区别在哪里了。
    });
    
}

#pragma mark  ======== 并发队列的应用 6个任务完成后刷新UI =========
//多任务场景
//我们在开发的过程中，大家应该都会遇到已进入某个页面，就要请求多个API，然后我们在完
//成所有请求以后再进行其他操作，对于这种需求，我们如何来设计我们的代码呢？
//例如下面的场景，在发现的页面有6个模块，但是后端给的接口又是分别不同的接口来调用。然后通过所有请求都完成了再在主线程进行UI刷新。
-(void)concurrentQueueApply
{
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //获取全局并发队列。dispatch_get_global_queue 是系统默认创建的全局并发队列
    
    //任务1
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行了任务1");
        [self getAdvertList:^{
        }];
    });
    
    //任务2
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行了任务2");
        [self getHotCultureList:^{
        }];
    });
    
    //任务3
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行了任务3");
        [self getSurroundCulture:^{
        }];
    });
    
    //任务4
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行了任务4");
        [self getMySubscibe:^{
        }];
    });
    
    //任务5
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行了任务5");
        [self getRecommendCulture:^{
        }];
    });
    
    //任务6
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"执行了任务6");
        [self getNews:^{
        }];
    });
    
    //信息汇总 监听group组中任务的完成状态，当所有的任务都执行完成后，触发block块，执行总结性处理。
    dispatch_group_notify(group, globalQueue, ^{
        
        NSLog(@"打印了这里呢？");
        //这里可以执行相关其他任务或者回到主线程,也就是所有异步任务请求结束后执行的代码
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"到主线程了？");
        });
    });
}

#pragma mark  ======== 限制线程个数的多任务并发应用=========
//应用场景 我们要下载很多图片，并发异步进行，每个下载都会开辟一个新线程，可是我们又担心太多线程肯定cpu吃不消，那么我们这里也可以用信号量控制一下最大开辟线程数。
-(void)dispatchSignal{
    //crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2); //起始信号量,发散思维-变换起始信号量成1、3会发生什么？
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
    
}


#pragma mark  ======== 某界面存在多个请求，希望请求依次执行。 =========


/**
 首先考虑到的是串行队列
 */
-(void)multipleRequestsApply
{
    const char *mutipleQueue = "mutipleQueue";
    dispatch_queue_t serialQueue = dispatch_queue_create(mutipleQueue, DISPATCH_QUEUE_SERIAL);
    
    //任务1
    dispatch_async(serialQueue, ^{
        NSLog(@"执行了任务1");
        [self getAdvertList:^{
            
        }];
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"执行了任务2");
        [self getHotCultureList:^{
            
        }];
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"执行了任务3");
        [self getSurroundCulture:^{
            NSLog(@"在最后一个任务的回调里做其他的操作");
        }];
    });
    
    
    
}


#pragma mark  ======== Semaphore信号量的应用 =========
/**
 我们可以通过设置信号量的大小，来解决并发过多导致资源吃紧的情况，以单核CPU做并发为例，
 一个CPU永远只能干一件事情，那如何同时处理多个事件呢，聪明的内核工程师让CPU干第一件事情，
 一定时间后停下来，存取进度，干第二件事情以此类推，所以如果开启非常多的线程，单核CPU会变得非常吃力，
 即使多核CPU，核心数也是有限的，所以合理分配线程，变得至关重要，那么如何发挥多核CPU的性能呢？
 如果让一个核心模拟传很多线程，经常干一半放下干另一件事情，那效率也会变低，所以我们要合理安排，
 将单一任务或者一组相关任务并发至全局队列中运算或者将多个不相关的任务或者关联不紧密的任务并发至用户队列中运算，
 所以用好信号量，合理分配CPU资源，程序也能得到优化，当日常使用中，信号量也许我们只起到了一个计数的作用，真的有点大材小用。
 
 */
-(void)SemaphoreDemo
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);//为了让一次输出10个，初始信号量为10
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i <100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//每进来1次，信号量-1;进来10次后就一直hold住，直到信号量大于0；
        dispatch_async(queue, ^{
            NSLog(@"%i",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);//由于这里只是log,所以处理速度非常快，我就模拟2秒后信号量+1;
        });
    }
    
}


#pragma mark  ======== 模拟网络请求的6个方法 =========
// 任务一
- (void)getAdvertList:(void(^)(void))requestisScu{
    
    sleep(9);
    NSLog(@"完成了任务1");
    requestisScu();
}

// 任务2
- (void)getHotCultureList:(void(^)(void))requestisScu{
    
    sleep(2);
    NSLog(@"完成了任务2");
    requestisScu();
}

// 任务3
- (void)getSurroundCulture:(void(^)(void))requestisScu{
    sleep(2);
    NSLog(@"完成了任务3");
    requestisScu();
}

// 任务4
- (void)getMySubscibe:(void(^)(void))requestisScu{
    sleep(2);
    NSLog(@"完成了任务4");
    requestisScu();
}

// 任务5
- (void)getRecommendCulture:(void(^)(void))requestisScu{
    
    sleep(2);
    NSLog(@"完成了任务5");
    requestisScu();
}

// 任务6
- (void)getNews:(void(^)(void))requestisScu{
    
    sleep(5);
    NSLog(@"完成了任务6");
    requestisScu();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
