//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "NSObject+ObjectAssociation.h"

#import <objc/runtime.h>

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

@implementation NSObject (ObjectAssociation)

-(void)LT_setAssociateObject:(id)object forKey:(NSString*)key
{
    objc_setAssociatedObject(self, [key cString], object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)LT_setAssociateBlock:(id)object forKey:(NSString*)key
{
    objc_setAssociatedObject(self, [key cString], object, OBJC_ASSOCIATION_COPY_NONATOMIC);    
}

-(id)LT_associatedObjectForKey:(NSString*)key
{
    return objc_getAssociatedObject(self, [key cString]);
}

@end
