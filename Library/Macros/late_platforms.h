//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#ifdef TARGET_OS_IPHONE
    #include <UIKit/UIKit.h>
#endif

#import <objc/runtime.h>

static float IPHONE5_HEIGHT = 568.0f;
static int _iosVersionCache = -1;

static BOOL isRunningOnPad()
{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
    #else
    return NO;
    #endif
}

static BOOL isRunningOnPhone()
{
    return !isRunningOnPad();
}

static BOOL isRunningOnPhone5()
{
    if ( isRunningOnPad() )
    {
        return NO;
    }
    
    return [[UIScreen mainScreen] bounds].size.height == IPHONE5_HEIGHT;
}

static void LT_SwizzleMethod(Class c, SEL orig, SEL modified)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, modified);
    if ( class_addMethod( c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod) ) )
    {
        class_replaceMethod( c, modified, method_getImplementation(origMethod), method_getTypeEncoding(origMethod) );
    }
    else
    {
        method_exchangeImplementations( origMethod, newMethod );
    }
}

static BOOL isIOSVersionLowerThan( float version)
{
    if( [[[ UIDevice currentDevice ] systemVersion ] floatValue ] >= version )
        return NO;
    else
        return YES;
}

static int iosVersion()
{
    if ( _iosVersionCache == -1 )
    {
        int index = 0;
        NSInteger version = 0;
        NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        NSEnumerator* enumer = [digits objectEnumerator];
        NSString* number;
        while (number = [enumer nextObject])
        {
            if ( index > 2 )
            {
                break;
            }
            NSInteger multipler = powf( 100, 2 - index );
            version += [number intValue] * multipler;
            index++;
        }        
        _iosVersionCache = version;
    }
    return _iosVersionCache;
}

