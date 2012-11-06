//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjectAssociation)

-(void)LT_setAssociateObject:(id)object forKey:(NSString*)key;
-(void)LT_setAssociateBlock:(id)object forKey:(NSString*)key;
-(id)LT_associatedObjectForKey:(NSString*)key;

@end
