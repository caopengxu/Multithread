//
//  ViewController.m
//  d
//
//  Created by cpx on 2017/4/1.
//  Copyright © 2017年 cpx. All rights reserved.
//

#import "ViewController.h"
#import "PXThread.h"

@interface ViewController ()
{
    NSUInteger _count;
}
@property (nonatomic, strong) PXThread *thread;
@property (nonatomic, strong) PXThread *thread1;
@property (nonatomic, strong) PXThread *thread2;
@property (weak, nonatomic) IBOutlet UITextField *textTest;
@end


@implementation ViewController

#pragma mark === viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _count = 100;
}


#pragma mark === 模仿延时操作
//- (IBAction)test:(id)sender
//{
//    for (NSUInteger i = 0; i < 50000; i++)
//    {
//        NSLog(@"===%zd", i);
//    }
//
//    NSLog(@"%@ %@",[NSThread mainThread], [NSThread currentThread]);
//}


#pragma mark === pthread
//void * run(void *param)
//{
//    for (NSUInteger i = 0; i < 50000; i++)
//    {
//        NSLog(@"===%zd", i);
//    }
//
//    NSLog(@"---%@", [NSThread currentThread]);
//    
//    return NULL;
//}
//- (IBAction)test:(id)sender
//{
//    pthread_t thread;  // 就代表一条线程
//    // “<#void * _Nullable (* _Nonnull)(void * _Nullable)#>”指向函数的指针
//    pthread_create(&thread, NULL, run, NULL);
//    
//    pthread_t thread1;  // 就代表一条线程
//    pthread_create(&thread1, NULL, run, NULL);
//}


#pragma mark === NSThread
- (void)run
{
    // 计算代码执行时间
    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    
    for (NSUInteger i = 0; i < 5000; i++)
    {
        NSLog(@"%@", [NSThread currentThread]);
        
        // 睡
//        [NSThread sleepForTimeInterval:1];
//        [NSThread sleepUntilDate:[NSDate distantFuture]];
//        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
        // 直接杀死线程
//        [NSThread exit];
    }
    
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"=====%f", end - begin);
    
    // 回调 "waitUntilDone"是否等待“returnTest”执行完再继续执行下面的”NSLog“
//    [self performSelectorOnMainThread:@selector(returnTest) withObject:@"one" waitUntilDone:NO];
//    [_textTest performSelectorOnMainThread:@selector(setText:) withObject:@"one" waitUntilDone:NO];
    [_textTest performSelector:@selector(setText:) onThread:[NSThread mainThread] withObject:@"two" waitUntilDone:NO];
    
    NSLog(@"---哈哈");
}
//- (void)returnTest
//{
//    _textTest.text = @"123";
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // one
    PXThread *thread = [[PXThread alloc] initWithTarget:self selector:@selector(run) object:@"one"];
    thread.name = @"PX";
    [thread start];
    
    // two
//    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:@"one"];
    
    // three
//    [self performSelectorInBackground:@selector(run) withObject:@"one"];
}


#pragma mark === 互斥锁(线程同步)
- (void)sell
{
    while (1)
    {
        @synchronized (self) {
            
            NSUInteger i = _count;
            
            if (i > 0)
            {
                _count = i - 1;
                
                NSLog(@"-- %zd -- %@", _count, [NSThread currentThread].name);
            }
            else
            {
                NSLog(@"完了");
                break;
            }
        }
    }
}
- (IBAction)test:(id)sender
{
    _thread = [[PXThread alloc] initWithTarget:self selector:@selector(sell) object:@"one"];
    _thread1 = [[PXThread alloc] initWithTarget:self selector:@selector(sell) object:@"one"];
    _thread2 = [[PXThread alloc] initWithTarget:self selector:@selector(sell) object:@"one"];
    _thread.name = @"one";
    _thread1.name = @"two";
    _thread2.name = @"three";

    [_thread start];
    [_thread1 start];
    [_thread2 start];
}


#pragma mark === GCD  充分利用CPU的多核




@end



