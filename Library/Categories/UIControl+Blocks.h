//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BlockInvoke.h"

@interface UIControl (Blocks)

-(void)LT_addHandlerForControlEvents:(UIControlEvents)events usingBlock:(NSObjectVoidBlock)block;

@end
