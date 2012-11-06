//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "LTSplashScreenController.h"

#import "late_platforms.h"
#import "late_debug.h"
#import "late_macros.h"

static UIInterfaceOrientation interfaceOrientation = 666;

@interface LTSplashScreenController ()
{
    UIImageView* imageView;
}
@end

@implementation LTSplashScreenController

-(void)viewDidLoad
{
    NSAssert( [UIApplication sharedApplication].statusBarHidden, @"LTSplashScreenController requires the status bar to be initially hidden. Please fix it in your plist file." );

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor]; // for debugging
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.autoresizesSubviews = YES;
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeTop;
    imageView.autoresizingMask = LT_UIVIEW_AUTORESIZING_ALL;
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];

    [self updateViewForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Helpers

-(void)updateViewForOrientation:(UIInterfaceOrientation)io
{
    LOG( @"Updating view for orientation %u", io );
    
    UIImage* image = nil;
    CGFloat angle = 0;
    
    if ( isRunningOnPhone() )
    {
        if ( isRunningOnPhone5() )
        {
            image = [UIImage imageNamed:@"Default-568h.png"];
        }
        if ( !image )
        {
            image = [UIImage imageNamed:@"Default.png"];
        }
    }
    else
    {
        switch ( io )
        {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                image = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
                break;
            case UIInterfaceOrientationLandscapeLeft:
                //angle = M_PI_2;
            case UIInterfaceOrientationLandscapeRight:
                image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
                angle = -M_PI_2;
                break;
            default:
                LOG( @"Ignoring unknown interface orientation" );
                break;
        }
        
    }
    imageView.image = image;
    self.view.transform = CGAffineTransformMakeRotation(angle);
    self.view.frame = [[UIScreen mainScreen] bounds];
    
    LOG( @"main screen now %@, my view %@, image view %@", [UIScreen mainScreen], self.view, self->imageView );

}

#pragma mark -
#pragma mark Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ( interfaceOrientation != io )
    {
        interfaceOrientation = io;
        [self updateViewForOrientation:io];
    }
    return YES;
}

-(void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    LOGHERE();
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    LOG( @"main screen now %@, my view %@, image view %@", [UIScreen mainScreen], self.view, self->imageView );
}

@end
