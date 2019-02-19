//
//  ViewController.m
//  GCD定时器
//
//  Created by A on 2019/2/19.
//  Copyright © 2019年 A. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"

@interface ViewController ()

//定义一个记录任务的字符串
@property (nonatomic, copy) NSString *task;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     调用者直接调用方法,用完即走,不用关心内存泄漏的问题:
     
     */
    //1.封装为block型
    self.task =  [GCDTimer execTask:^{
        NSLog(@"%@",[NSThread currentThread]);
    } start:1.0 interval:1.0 repeats:YES async:YES];
    
}

//模拟手动取消
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [GCDTimer cancelTask:self.task];
    
}
@end
