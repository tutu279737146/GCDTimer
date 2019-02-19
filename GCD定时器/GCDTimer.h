//
//  GCDTimer.h
//  GCD定时器
//
//  Created by A on 2019/2/19.
//  Copyright © 2019年 A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

+ (NSString *)execTask: (void(^)(void))task
                 start: (NSTimeInterval)start
              interval: (NSTimeInterval)interval
               repeats: (BOOL)repeats
                 async: (BOOL)async;

+ (void)cancelTask: (NSString *)name;

@end
