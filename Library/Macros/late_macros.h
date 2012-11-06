//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#if ! NS_BLOCKS_AVAILABLE
#error This library needs objective-c / core foundation block support
#endif

#import "late_debug.h"

/* Abstract base classes */

#define LT_PURE_VIRTUAL { assert_not_reached(); }

/* Convert between radians and degrees */
 
#define LT_DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define LT_RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

/* GCD-based Singleton */

#define LT_SINGLETON_INTERFACE_FOR_CLASS( classname, accessorname )      \
+ (classname *)accessorname;

#define LT_SINGLETON_IMPLEMENTATION_FOR_CLASS( classname, accessorname ) \
+ (classname *)accessorname                                              \
{                                                                        \
static classname *accessorname = nil;                                    \
static dispatch_once_t onceToken;                                        \
dispatch_once(&onceToken, ^{                                             \
accessorname = [[classname alloc] init];                                 \
});                                                                      \
return accessorname;                                                     \
}

/* Localization & Strings */

#define _(String) NSLocalizedString( @"" String, nil )
#define LT_NSSTRING_IS_EMPTY( String ) ( String == nil || [String isEqualToString:@""] )
#define LT_NSSTRING_OR_PLACEHOLDER( String, Placeholder ) ( ( String == nil || [String isEqualToString:@""] ) ? Placeholder : String )

/* Arrays */
#define LT_NSARRAY_IS_EMPTY( Array ) ( Array == nil || [Array count] == 0 )

/* Async dispatching */

#define LT_DISPATCH_IN_MAIN_QUEUE( Block ) \
({ \
__weak __typeof__(self) myself = self; \
_Pragma( "unused(myself)" ) \
dispatch_async( dispatch_get_main_queue(), (Block) ); \
})

#define LT_DISPATCH_IN_LOW_QUEUE( Block ) \
({ \
__weak __typeof__(self) myself = self; \
_Pragma( "unused(myself)" ) \
dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), (Block) ); \
})

#define LT_DISPATCH_IN_DEFAULT_QUEUE( Block ) \
({ \
__weak __typeof__(self) myself = self; \
_Pragma( "unused(myself)" ) \
dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (Block) ); \
})

#define LT_DISPATCH_IN_HIGH_QUEUE( Block ) \
({ \
__weak __typeof__(self) myself = self; \
_Pragma( "unused(myself)" ) \
dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), (Block) ); \
})

/* OSStatus */

#define LT_CHECK_OSSTATUS( Variable, Message ) \
if ( Variable ) LOG( @"ERROR while" Message )

#define LT_CHECK_OSSTATUS_RETURN( Variable, Message ) \
if ( Variable ) { \
    LOG( @"ERROR while" Message ); \
    return; \
}

/* Random numbers */

#define LT_RANDOM_NUMBER_WITHIN( Low, High ) ( (int)Low + arc4random() % (High - Low + 1) )

/* Presentation of non-NSObject datatypes */

#define LT_CGRECT_TO_NSSTRING( Rect ) [NSString stringWithFormat:@"<CGRect: %.2f, %.2f * %.2f, %.2f>", Rect.origin.x, Rect.origin.y, Rect.size.width, Rect.size.height]
#define LT_CGPOINT_TO_NSSTRING( Point ) [NSString stringWithFormat:@"<CGPoint: %.2f, %.2f>", Point.x, Point.y]
#define LT_CGSIZE_TO_NSSTRING( Size ) [NSString stringWithFormat:@"<CGSize: %.2f, %.2f>", Size.width, Size.height]
#define LT_NSSTRING_TO_NSARRAY( List ) [List componentsSeparatedByString:@" "]

/* UIView Autoresizing */
#define LT_UIVIEW_AUTORESIZING_ALL \
    UIViewAutoresizingFlexibleLeftMargin | \
    UIViewAutoresizingFlexibleWidth | \
    UIViewAutoresizingFlexibleRightMargin | \
    UIViewAutoresizingFlexibleTopMargin | \
    UIViewAutoresizingFlexibleHeight | \
    UIViewAutoresizingFlexibleBottomMargin

/* ARC */
#define LT_ARC_FORCE_RETAIN( object ) CFBridgingRetain(object)
#define LT_ARC_FORCE_RELEASE( object ) CFRelease((__bridge CFTypeRef)object)
