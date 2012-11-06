//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTWebViewController.h"

#import "late_macros.h"
#import "late_platforms.h"

#ifdef HAVE_MBPROGRESSHUD
#import "MBProgressHUD+LaTe.h"
#endif
#import "UIControl+Blocks.h"
#import "LTAlertView.h"

@interface LTWebViewController ()
{
@private
    NSString* startTag;
    NSString* endTag;
    NSString* htmlBody;
}

@property (nonatomic,retain) NSString* startTag;
@property (nonatomic,retain) NSString* endTag;
@property (nonatomic,retain) NSString* htmlBody;

@end

@implementation LTWebViewController

@synthesize startTag;
@synthesize endTag;
@synthesize htmlBody;

@synthesize webView;
@synthesize url;
@synthesize html;
@synthesize linksOpenExtern;

#pragma mark - Helpers

-(void)onDismissButtonHit:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - class methods

+(id)webViewControllerWithURL:(NSURL*)url
{
    LTWebViewController* vc = [[LTWebViewController alloc] init];
    vc.linksOpenExtern = NO;
    vc.url = url;
    return vc;
}

+(id)webViewControllerWithURL:(NSURL*)url openLinksExtern:(BOOL)yesno
{
    LTWebViewController* vc = [[LTWebViewController alloc] init];
    vc.linksOpenExtern = yesno;
    vc.url = url;
    return vc;
}

+(id)webViewControllerWithHTML:(NSString*)html
{
    LTWebViewController* vc = [[LTWebViewController alloc] init];
    vc.linksOpenExtern = NO;
    vc.html = html;
    return vc;
}

+(id)webViewControllerWithHTML:(NSString*)html openLinksExtern:(BOOL)yesno
{
    LTWebViewController* vc = [[LTWebViewController alloc] init];
    vc.linksOpenExtern = yesno;
    vc.html = html;
    return vc;
}

+(id)webViewControllerWithURLByCopyingContent:(NSURL*)url fromStartTag:(NSString*)start toEndTag:(NSString*)end andInsertInto:(NSString*)body openLinksExtern:(BOOL)yesno
{
    LTWebViewController* vc = [[LTWebViewController alloc] init];
    vc.linksOpenExtern = yesno;
    vc.startTag = start;
    vc.endTag = end;
    vc.htmlBody = body;
    vc.url = url;
    return vc;
}

#pragma mark - View lifecycle

-(void)loadView
{
    [super loadView];
    
    self.view.autoresizesSubviews = YES;
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.webView.autoresizesSubviews = YES;
    self.webView.delegate = self;
    [self.view addSubview:webView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ( self.url )
    {
#if 0
        // open from url mode
        if ( ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) )
        {
            LTAlertView* alert = [LTAlertView alertWithTitle:_("LTWEBVIEW_ALERT_TITLE") message:_("LTWEBVIEW_ALERT_MESSAGE_NOT_CONNECTED")];
            [alert addButtonWithTitle:@"Ok" usingBlock:^{[self onDismissButtonHit:nil];}];
            [alert show];
        }
        else
#endif
        {
            if ( ( self.startTag != nil ) && ( self.endTag != nil ) && ( self.htmlBody != nil ) )
            {
                // get content, reformat it and fromat it as background task
#ifdef HAVE_MBPROGRESSHUD
                [MBProgressHUD executeTaskInBackgroundWhileShowingHUDForView:self.view animated:YES usingBlock:^{
#endif
                    NSString* webcontent = [NSString stringWithContentsOfURL:self.url encoding:NSASCIIStringEncoding error:nil];
                    
                    // strip content
                    NSRange startRange =[[webcontent lowercaseString] rangeOfString:[self.startTag lowercaseString]];
                    if ( startRange.location == NSNotFound ) return; // start tag not found, nothing to show
                    
                    NSRange endRange =[[webcontent lowercaseString] rangeOfString:[self.endTag lowercaseString]];
                    if( endRange.location == NSNotFound ) return; // end tag not found, nothing to show
                    
                    NSRange contentRange = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location);
                    webcontent = [webcontent substringWithRange:contentRange];
                    
                    if ( self.htmlBody == nil) return; // no html body found to insert clipped web content
                    NSString* newContent = [NSString stringWithFormat:self.htmlBody, webcontent];
                    [webView loadHTMLString:newContent baseURL:self.url];
#ifdef HAVE_MBPROGRESSHUD
                }];
#endif
            }
            else
            {
                [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
            }
        }
    }
    else if ( self.html )
    {
        // open from string mode
        [webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@""]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
#ifdef HAVE_MBPROGRESSHUD
    [MBProgressHUD hideHUDForView:self.view animated:animated];
#endif
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( isRunningOnPhone() )
    {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
    return YES;
}

#pragma mark -
#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch ( navigationType )
    {
        case UIWebViewNavigationTypeLinkClicked:
            if ( self.linksOpenExtern == YES )
            {
                LTAlertView* alert = [LTAlertView alertWithTitle:_(@"LTWEBVIEW_ALERT_TITLE") message:_(@"LTWEBVIEW_ALERT_MESSAGE")];
                [alert addButtonWithTitle:_(@"LTWEBVIEW_ALERT_BUTTON_YES") usingBlock:^{
                    [[UIApplication sharedApplication] openURL:[request URL]];
                }];
                [alert addButtonWithTitle:_(@"LTWEBVIEW_ALERT_BUTTON_NO") usingBlock:nil];
                [alert show];
                
                return NO;
            }
            else
            {
                return YES;
            }
            break;
            
        default:
            return YES;
            break;
    }
}

#ifdef HAVE_MBPROGRESSHUD
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if ( ![MBProgressHUD HUDForView:self.view] )
    {    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        LOG( @"Ignoring already shown MBProgressHUD" );
    }
}
#endif

#ifdef HAVE_MBPROGRESSHUD
-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    if ( [MBProgressHUD HUDForView:self.view] )
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
#endif

@end
