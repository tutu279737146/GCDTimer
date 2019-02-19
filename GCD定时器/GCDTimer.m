//
//  GCDTimer.m
//  GCD定时器
//
//  Created by A on 2019/2/19.
//  Copyright © 2019年 A. All rights reserved.
//

#import "GCDTimer.h"

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;

@implementation GCDTimer

+ (void)initialize{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void (^)(void))task
                 start: (NSTimeInterval)start
              interval: (NSTimeInterval)interval
               repeats: (BOOL)repeats
                 async: (BOOL)async{
    
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    //创建队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    //创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //加锁
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    //设置定时器的唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd",timers_.count];
    //存放到字典
    timers_[name] = timer;
    //解锁
    dispatch_semaphore_signal(semaphore_);
    
    //设置时间
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0);
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {//不重复
            //            [self cancelTask:];
        }
    });
    //启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (void)cancelTask:(NSString *)name{
    
    if (!(name.length <= 0)) {
        dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
        dispatch_source_t timer = timers_[name];
        if (timer) {
            dispatch_source_cancel(timer);
            [timers_ removeObjectForKey:timer];
        }
        dispatch_semaphore_signal(semaphore_);
    }
}
@end
