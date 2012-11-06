//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTAlertView.h"

#import "NSTimer+Blocks.h"
#import "NSObject+ObjectAssociation.h"

#import "late_macros.h"

typedef enum
{
    LTAlertViewModeSimple,
    LTAlertViewModeInput,
    LTAlertViewModeLogin,
} LTAlertViewMode;

@interface LTAlertView ()

@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* message;
@property(nonatomic,retain) NSMutableArray* titles;
@property(nonatomic,retain) NSMutableArray* blocks;

@property(nonatomic,assign) BOOL passwordMode;
@property(nonatomic,retain) UITextField* loginView;
@property(nonatomic,retain) UITextField* passwordView;

@property(nonatomic,assign) LTAlertViewMode mode;

@property(nonatomic,retain) NSTimer* timer;

@end

@implementation LTAlertView

@synthesize title, message, titles, blocks;
@synthesize passwordMode, loginView, passwordView;
@synthesize mode, timer;

@synthesize loginPlaceholder, passwordPlaceholder;
@synthesize login, password;
@synthesize hidePassword;

@synthesize input;

#pragma mark -
#pragma mark Life Cycle

-(void)dealloc
{
    LOGHERE();
}

+(id)alertWithTitle:(NSString*)atitle message:(NSString*)amessage
{
    return [[LTAlertView alloc] initWithTitle:atitle message:amessage];
}

+(id)alertWithTitle:(NSString *)atitle loginPlaceholder:(NSString*)aloginPlaceholder passwordPlaceholder:(NSString*)apasswordPlaceholder
{
    return [[LTAlertView alloc] initWithTitle:atitle loginPlaceholder:aloginPlaceholder passwordPlaceholder:apasswordPlaceholder];
}

+(id)alertWithTitle:(NSString*)atitle inputPlaceholder:(NSString*)inputPlaceholder
{
    return [[LTAlertView alloc] initWithTitle:atitle inputPlaceholder:inputPlaceholder];
}

-(id)initWithTitle:(NSString*)atitle message:(NSString*)amessage
{
    if ( ! ( self = [super init] ) )
    {
        return nil;
    }
    
    self.title = atitle;
    self.message = amessage;
    
    LT_ARC_FORCE_RETAIN(self);
    LT_ARC_FORCE_RETAIN(self);

    return self;
}

-(id)initWithTitle:(NSString *)atitle loginPlaceholder:(NSString*)aloginPlaceholder passwordPlaceholder:(NSString*)apasswordPlaceholder
{
    if ( ! ( self = [super init] ) )
    {
        return nil;
    }
    
    self.title = atitle;
    self.message = @"\n\n\n";
    self.loginPlaceholder = aloginPlaceholder;
    self.passwordPlaceholder = apasswordPlaceholder;
    self.hidePassword = YES;
    self.mode = LTAlertViewModeLogin;

    LT_ARC_FORCE_RETAIN(self);
    LT_ARC_FORCE_RETAIN(self);

    return self;
}

-(id)initWithTitle:(NSString *)atitle inputPlaceholder:(NSString*)inputPlaceholder
{
    if ( ! ( self = [super init] ) )
    {
        return nil;
    }
    self.title = atitle;
    self.message = @"\n";
    self.loginPlaceholder = inputPlaceholder;
    self.mode = LTAlertViewModeInput;

    LT_ARC_FORCE_RETAIN(self);
    LT_ARC_FORCE_RETAIN(self);

    return self;
}

#pragma mark -
#pragma mark Configuration

-(void)addButtonWithTitle:(NSString *)atitle usingBlock:(LTAlertViewBlock)block
{
    if ( !self.titles )
    {
        self.titles = [NSMutableArray arrayWithCapacity:2];
    }
    if ( !self.blocks )
    {
        self.blocks = [NSMutableArray arrayWithCapacity:2];
    }
    
    [self.titles addObject:atitle];
    [self.blocks addObject:block != nil ? block : ^{}];
}

#pragma mark -
#pragma mark Presentation

-(UIAlertView*)_show
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.title
                                                    message:self.message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    
    for ( NSString* t in self.titles )
    {
        [alert addButtonWithTitle:t];
    }
    
    if ( self.mode == LTAlertViewModeLogin )
    {
    	self.loginView = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
        //[textField setBackgroundColor:[UIColor whiteColor]];
        self.loginView.placeholder = self.loginPlaceholder;
        self.loginView.text = self.login;
        self.loginView.borderStyle = UITextBorderStyleRoundedRect;
        self.loginView.autocorrectionType = UITextAutocorrectionTypeNo;
        [alert addSubview:self.loginView];
        
        self.passwordView = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
        //[textField2 setBackgroundColor:[UIColor whiteColor]];
        self.passwordView.placeholder = self.passwordPlaceholder;
        self.passwordView.text = self.password;
        [self.passwordView setSecureTextEntry:self.hidePassword];
        self.passwordView.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordView.autocorrectionType = UITextAutocorrectionTypeNo;
        [alert addSubview:self.passwordView];
        
        // set cursor and show keyboard
        [self.loginView becomeFirstResponder];
    }
    else if ( self.mode == LTAlertViewModeInput )
    {
    	self.loginView = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        //[textField setBackgroundColor:[UIColor whiteColor]];
        self.loginView.placeholder = self.loginPlaceholder;
        self.loginView.text = self.input;
        self.loginView.borderStyle = UITextBorderStyleRoundedRect;
        self.loginView.autocorrectionType = UITextAutocorrectionTypeNo;
        [alert addSubview:self.loginView];

        // set cursor and show keyboard
        [self.loginView becomeFirstResponder];
    }

    [alert show];
    return alert;
}

-(void)show
{
    [self _show];
}

-(void)showWithAutoDismiss:(NSTimeInterval)interval
{
    UIAlertView* sheet = [self _show];
    self.timer = [NSTimer LT_scheduledTimerWithTimeInterval:interval repeats:NO usingBlock:^{
        [sheet dismissWithClickedButtonIndex:sheet.cancelButtonIndex animated:YES];
    }];
}

#pragma mark -
#pragma mark Convenience

+(void)showInformativeMessage:(NSString*)message title:(NSString*)title fromView:(UIView*)view withAutoDismiss:(NSTimeInterval)timeInterval
{
    LTAlertView* alert = [LTAlertView alertWithTitle:title message:message];
    [alert addButtonWithTitle:_("OK") usingBlock:nil];
    if ( timeInterval > 0.0 )
    {
        [alert showWithAutoDismiss:timeInterval];
    }
    else
    {
        [alert show];
    }
}

#pragma mark -
#pragma mark Internal (UIAlertViewDelegate)

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( self.mode == LTAlertViewModeLogin )
    {
        self.login = self.loginView.text;
        self.password = self.passwordView.text;
    }
    else if ( self.mode == LTAlertViewModeInput )
    {
        self.input = self.loginView.text;
    }
    LTAlertViewBlock block = [self.blocks objectAtIndex:buttonIndex];
    block();

    LT_ARC_FORCE_RELEASE(self);
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.timer invalidate], self.timer = nil;

    LT_ARC_FORCE_RELEASE(self);
}

@end
