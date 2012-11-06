//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#ifdef LATEDEBUG_FILE

#define LATEDEBUG_FILE_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define LATEDEBUG_FILE_NAME   @"LATE_DEBUG_LOG.txt"

//static BOOL LTFileLogHaveShownLocation = NO;

static void LTFileLog(NSString *format, ...) 
{
    /*
    if ( !LTFileLogHaveShownLocation )
    {
        LTFileLogHaveShownLocation = YES;
        NSLog( @"*** LT DEBUG FILE will be at %@/%@", LATEDEBUG_FILE_FOLDER, LATEDEBUG_FILE_NAME );
    }
    */

    va_list ap;
    NSString *print;
    va_start( ap, format );
    print = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end( ap );

    FILE* f = fopen( [[NSString stringWithFormat:@"%@/%@", LATEDEBUG_FILE_FOLDER, LATEDEBUG_FILE_NAME] UTF8String], "a" );
    fprintf( f, "%s: %s\r\n", [[[NSDate date] description] UTF8String], [print UTF8String] );
    fclose( f );

    NSLog( @"%@", print );

    [print release];
}

#endif

#ifdef LATEDEBUG_FILE
#   define LOG(fmt, ...) LTFileLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define LOGHERE() LTFileLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
#   define assert_not_reached() LTFileLog((@"WARNING! %s %d should never be reached in production code!"), __PRETTY_FUNCTION__, __LINE__);
#else

#ifdef LATEDEBUG
#   define LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define LOGHERE() NSLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
#   define assert_not_reached() assert(false);
#else
#   define LOG(...)
#   define LOGHERE()
#   define assert_not_reached() NSLog((@"WARNING! %s %d should never be reached in production code!"), __PRETTY_FUNCTION__, __LINE__);
#endif

#endif

#ifdef EXTRADEBUG
#   define XLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define XLOGHERE() NSLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
#else
#   define XLOG(...)
#   define XLOGHERE()
#endif
