//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTWebViewController : UIViewController <UIWebViewDelegate>

@property(nonatomic,retain) UIWebView* webView;
@property(nonatomic,retain) NSURL* url;
@property(nonatomic,retain) NSString* html;
@property(nonatomic,assign) BOOL linksOpenExtern;

+(id)webViewControllerWithURL:(NSURL*)url;
+(id)webViewControllerWithURL:(NSURL*)url openLinksExtern:(BOOL)yesno;
+(id)webViewControllerWithURLByCopyingContent:(NSURL*)url fromStartTag:(NSString*)start toEndTag:(NSString*)end andInsertInto:(NSString*)body openLinksExtern:(BOOL)yesno;

+(id)webViewControllerWithHTML:(NSString*)html;
+(id)webViewControllerWithHTML:(NSString*)html openLinksExtern:(BOOL)yesno;

@end
