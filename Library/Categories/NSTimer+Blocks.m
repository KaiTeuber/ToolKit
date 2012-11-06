//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "NSTimer+Blocks.h"

@interface NSTimer (Blocks_private)
+(void)LT_executeBlockWithTimer:(NSTimer *)timer;
@end

@implementation NSTimer (Blocks)

+(NSTimer*)LT_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats usingBlock:(NSTimerInvocationBlock)fireBlock
{
    return [self scheduledTimerWithTimeInterval:seconds target:self selector:@selector(LT_executeBlockWithTimer:) userInfo:fireBlock repeats:repeats];
}

+(NSTimer*)LT_timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats usingBlock:(NSTimerInvocationBlock)fireBlock
{
    return [self timerWithTimeInterval:seconds target:self selector:@selector(LT_executeBlockWithTimer:) userInfo:fireBlock repeats:repeats];
}

@end

@implementation NSTimer (Block_private)

+ (void)LT_executeBlockWithTimer:(NSTimer*)timer
{
    NSTimerInvocationBlock block = [timer userInfo];
    block(timer);
}

@end
