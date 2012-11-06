//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSTimerInvocationBlock)();

@interface NSTimer (Blocks)

+(NSTimer*)LT_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats usingBlock:(NSTimerInvocationBlock)fireBlock;
+(NSTimer*)LT_timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats usingBlock:(NSTimerInvocationBlock)fireBlock;

@end
