//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSObjectVoidBlock)();

@interface NSObject (BlockInvoke_private)

-(void)LT_executeVoidBlock:(NSObjectVoidBlock)block;

-(void)LT_registerVoidBlock:(NSObjectVoidBlock)block;
-(void)LT_invokeVoidBlock:(id)sender;

@end
