//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LTActionSheetBlock)();

@interface LTActionSheet : NSObject <UIActionSheetDelegate>

+(id)actionSheetWithTitle:(NSString*)atitle;
-(id)initWithTitle:(NSString*)atitle;
-(void)addButtonWithTitle:(NSString *)atitle usingBlock:(LTActionSheetBlock)block;
-(void)setDestructiveButtonWithTitle:(NSString *)atitle usingBlock:(LTActionSheetBlock)block;
-(void)setCancelButtonWithTitle:(NSString *)atitle usingBlock:(LTActionSheetBlock)block;
-(void)showFromView:(UIView*)view;
-(void)showFromView:(UIView*)view withAutoDimiss:(NSTimeInterval)interval;
-(void)showFromBarButtonItem:(UIBarButtonItem*)item animated:(BOOL)animated;
-(void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;

+(void)showInformativeMessage:(NSString*)message fromView:(UIView*)view withAutoDismiss:(NSTimeInterval)timeInterval;

@end
