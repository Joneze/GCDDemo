### GCDDemo

##### 本demo一开始主要是总结GCD在工作中比较常用的应用场景，所谓好钢要用到刀刃上。后来，我发现我还有其他知识点需要去巩固于是就有了算法的demo

**总共分六个模块**

1. 串行列队的创建
2. 并行列队的创建
3. 并发队列的应用 6个任务完成后刷新UI
4. 限制线程个数的多任务并发应用
5. 某界面存在多个请求，希望请求依次执行。
6. Semaphore信号量的应用


下面这一段是串行列队代码

```
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
```


