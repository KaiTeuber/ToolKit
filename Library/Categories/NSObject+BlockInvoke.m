//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "NSObject+BlockInvoke.h"

#import <objc/runtime.h>

static char* BLOCK_KEY = "Block";

@implementation NSObject (BlockInvoke_private)

-(void)LT_executeVoidBlock:(NSObjectVoidBlock)block
{
    block();
}

-(void)LT_invokeVoidBlock:(id)sender
{
    NSObjectVoidBlock block = (NSObjectVoidBlock) objc_getAssociatedObject(self, BLOCK_KEY);
    block();
}

-(void)LT_registerVoidBlock:(NSObjectVoidBlock)block
{
    objc_setAssociatedObject(self, BLOCK_KEY, block, OBJC_ASSOCIATION_COPY);
}

@end
