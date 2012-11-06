//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTAlertView;
typedef void (^LTAlertViewBlock)();

@interface LTAlertView : NSObject <UIAlertViewDelegate>

@property(nonatomic,retain) NSString* input;
@property(nonatomic,retain) NSString* login;
@property(nonatomic,retain) NSString* password;
@property(nonatomic,retain) NSString* loginPlaceholder;
@property(nonatomic,retain) NSString* passwordPlaceholder;
@property(nonatomic,assign) BOOL hidePassword;

+(id)alertWithTitle:(NSString*)atitle message:(NSString*)amessage;
-(id)initWithTitle:(NSString*)atitle message:(NSString*)amessage;
-(void)addButtonWithTitle:(NSString *)atitle usingBlock:(LTAlertViewBlock)block;
-(void)show;
-(void)showWithAutoDismiss:(NSTimeInterval)interval;

+(id)alertWithTitle:(NSString*)atitle loginPlaceholder:(NSString*)aloginPlaceholder passwordPlaceholder:(NSString*)apasswordPlaceholder;
-(id)initWithTitle:(NSString*)atitle loginPlaceholder:(NSString*)aloginPlaceholder passwordPlaceholder:(NSString*)apasswordPlaceholder;

+(id)alertWithTitle:(NSString*)atitle inputPlaceholder:(NSString*)inputPlaceholder;
-(id)initWithTitle:(NSString *)atitle inputPlaceholder:(NSString*)inputPlaceholder;

+(void)showInformativeMessage:(NSString*)message title:(NSString*)title fromView:(UIView*)view withAutoDismiss:(NSTimeInterval)timeInterval;

@end
