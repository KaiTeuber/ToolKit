//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTActionSheet.h"

#import "NSTimer+Blocks.h"

#import "late_macros.h"
#import "late_platforms.h"

@interface LTActionSheet ()

@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* cancelTitle;
@property(nonatomic,copy) LTActionSheetBlock cancelBlock;
@property(nonatomic,retain) NSString* destructiveTitle;
@property(nonatomic,copy) LTActionSheetBlock destructiveBlock;
@property(nonatomic,retain) NSMutableArray* otherTitles;
@property(nonatomic,retain) NSMutableArray* otherBlocks;

@property(nonatomic,retain) NSTimer* timer;

@end

@implementation LTActionSheet

@synthesize title, cancelTitle, cancelBlock, destructiveTitle, destructiveBlock, otherTitles, otherBlocks;
@synthesize timer;

-(void)dealloc
{
    LOGHERE();
}

#pragma mark -
#pragma mark Helpers

-(void)dismiss:(NSTimer*)t
{
    UIActionSheet* sheet = [t userInfo];
    [sheet dismissWithClickedButtonIndex:sheet.cancelButtonIndex animated:YES];
    LT_ARC_FORCE_RELEASE(self);
}

#pragma mark -
#pragma mark Memory Management

+(id)actionSheetWithTitle:(NSString*)atitle
{
    return [[LTActionSheet alloc] initWithTitle:atitle];
}

-(id)initWithTitle:(NSString*)atitle
{
    if ( ! ( self = [super init] ) )
    {
        return nil;
    }
    
    self.title = atitle;
    LT_ARC_FORCE_RETAIN(self);
    LT_ARC_FORCE_RETAIN(self);    
    return self;
}

#pragma mark -
#pragma mark Configuration

-(void)addButtonWithTitle:(NSString *)atitle usingBlock:(LTActionSheetBlock)block
{
    if ( !otherTitles )
    {
        self.otherTitles = [NSMutableArray arrayWithCapacity:2];
    }
    if ( !otherBlocks )
    {
        self.otherBlocks = [NSMutableArray arrayWithCapacity:2];
    }
    [self.otherTitles addObject:atitle];    
    [self.otherBlocks addObject:block != nil ? block : ^{}];
}

-(void)setDestructiveButtonWithTitle:(NSString *)atitle usingBlock:(LTActionSheetBlock)block
{
    self.destructiveTitle = atitle;
    self.destructiveBlock = block;
}

-(void)setCancelButtonWithTitle:(NSString *)atitle usingBlock:(LTActionSheetBlock)block
{
    self.cancelTitle = atitle;
    self.cancelBlock = block;
}

#pragma mark -
#pragma mark Presentation

-(UIActionSheet*)configure
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];

    if ( self.destructiveTitle )
    {
        sheet.destructiveButtonIndex = [sheet addButtonWithTitle:self.destructiveTitle];
    }

    for ( NSString* t in self.otherTitles )
    {
        [sheet addButtonWithTitle:t];
    }
        
    if ( self.cancelTitle )
    {
        if ( isRunningOnPad() )
        {
            sheet.cancelButtonIndex = -1;
        }
        else
        {
            sheet.cancelButtonIndex = [sheet addButtonWithTitle:self.cancelTitle];
        }
    }

    return sheet;
}

-(UIActionSheet*)_showFromView:(UIView*)view
{
    UIActionSheet* sheet = [self configure];
    
    if ( [view isKindOfClass:[UITabBar class]] )
    {
        [sheet showFromTabBar:(UITabBar*)view];
    }
    else if ( [view isKindOfClass:[UIToolbar class]] )
    {
        [sheet showFromToolbar:(UIToolbar*)view];
    }
    else
    {
        [sheet showInView:view];
    }
    return sheet;
}

-(void)showFromView:(UIView *)view
{
    [self _showFromView:view];
}

-(void)showFromBarButtonItem:(UIBarButtonItem*)item animated:(BOOL)animated
{
    UIActionSheet* sheet = [self configure];
    [sheet showFromBarButtonItem:item animated:animated];
}

-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    UIActionSheet* sheet = [self configure];
    [sheet showFromRect:rect inView:view animated:animated];
}

-(void)showFromView:(UIView*)view withAutoDimiss:(NSTimeInterval)interval
{
    id sheet = [self _showFromView:view];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(dismiss:) userInfo:sheet repeats:NO];
}

#pragma mark -
#pragma mark Convenience API

+(void)showInformativeMessage:(NSString*)message fromView:(UIView*)view withAutoDismiss:(NSTimeInterval)timeInterval
{
    LTActionSheet* sheet = [LTActionSheet actionSheetWithTitle:message];
    [sheet showFromView:view withAutoDimiss:timeInterval];
}

#pragma mark -
#pragma mark Internal (UIActionSheetDelegate)

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == actionSheet.cancelButtonIndex )
    {
        if ( self.cancelBlock != nil )
        {
            self.cancelBlock();
        }
    }
    else if ( self.destructiveTitle && buttonIndex == actionSheet.destructiveButtonIndex )
    {
        if ( self.destructiveBlock != nil )
        {
            self.destructiveBlock();
        }
    }
    else
    {
        if ( self.destructiveBlock ) buttonIndex--;
        LTActionSheetBlock block = [self.otherBlocks objectAtIndex:buttonIndex];
        if ( block != nil )
        {
            block();
        }
    }
    LT_ARC_FORCE_RELEASE(self);
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.timer invalidate], self.timer = nil;
    LT_ARC_FORCE_RELEASE(self);
}

@end
