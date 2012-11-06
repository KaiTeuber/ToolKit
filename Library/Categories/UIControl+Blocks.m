//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "UIControl+Blocks.h"

@implementation UIControl (Blocks)

#pragma mark -
#pragma mark Control event handling

-(void)LT_addHandlerForControlEvents:(UIControlEvents)events usingBlock:(NSObjectVoidBlock)block
{
    [self LT_registerVoidBlock:block];
    [self addTarget:self action:@selector(LT_invokeVoidBlock:) forControlEvents:events];
}

@end
