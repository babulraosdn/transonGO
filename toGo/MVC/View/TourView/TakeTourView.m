//
//  TakeTourView.m
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "TakeTourView.h"

#define NUM_IMAGES 5
#define DEVICEFRAME [[UIScreen mainScreen] bounds]


@implementation TakeTourView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor blueColor]];
       
       
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 65, self.frame.size.height - 30, self.frame.size.width/2, 20)];
        
       [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];

        self.scrollImages = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollImages setPagingEnabled:YES];
        [self.scrollImages setDelegate:self];
        [self addSubview:self.scrollImages];
        [self addSubview:self.pageControl];
        

        [self AddButtonsOnTour];
    }
    return self;
}

+ (void)launchTakeTourViewWithNewVersion:(BOOL)isNewVersion{
    if (isNewVersion) {
        [TakeTourView startTakeTourForExistUser];
    }else{
        [TakeTourView startTakeTourForFreshUser];
    }
}

+ (void)startTakeTourForExistUser{
    
    CGRect frame = DEVICEFRAME;
    frame.origin.y = frame.origin.y + 16;
    frame.size.height = frame.size.height - 16;
    TakeTourView *viewTakeTour = [[TakeTourView alloc] initWithFrame:frame];
 
    [viewTakeTour welcomeImages];
    [App_Delegate.window addSubview:viewTakeTour];
    
}



+ (void)startTakeTourForFreshUser{
    
    
    CGRect frame = DEVICEFRAME;
    frame.origin.y = frame.origin.y + 16;
    frame.size.height = frame.size.height - 16;
    TakeTourView *viewTakeTour = [[TakeTourView alloc] initWithFrame:frame];
    [viewTakeTour welcomeImages];
    [App_Delegate.window addSubview:viewTakeTour];
    
}
//#pragma mark----
//#pragma mark SCROLLVIEW DELEGATE METHODS

- (void)welcomeImages{
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = NUM_IMAGES;


    for (int i = 1; i <= NUM_IMAGES; i++)
    {

    @autoreleasepool {
        CGRect frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height-44);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.tag = i;
        UIImage *image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"T%d",i] ofType:@"png"]];
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
        [imageView2 setFrame:view.bounds];
        imageView2.tag = i; // tag our images for later use when we place them in serial fashion
        imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView2];
        [self.scrollImages addSubview:view];
        
      }
    }
        [self layoutScrollImages];
        
}

- (void)layoutScrollImages
{
    UIView *imageView = nil;
    NSArray *subviews = [self.scrollImages subviews];
    
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (imageView in subviews)
    {
        if ([imageView isKindOfClass:[UIView class]] && imageView.tag > 0)
        {
            CGRect frame = imageView.frame;
            frame.origin = CGPointMake(curXLoc, 0);
            imageView.frame = frame;
            
            curXLoc += (DEVICEFRAME.size.width);
        }
    }
    
    // set the content size so it can be scrollable
    if (IS_IPHONE_5) {
        [self.scrollImages setContentSize:CGSizeMake((NUM_IMAGES * DEVICEFRAME.size.width), 400)];
    }else{
        [self.scrollImages setContentSize:CGSizeMake((NUM_IMAGES * DEVICEFRAME.size.width), 354)];
    }
    
}


/*
 *  Scrollview delegate method
 */

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollImages.frame.size.width;
    int page = floor((self.scrollImages.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    if (page == 0) {
        
        UIButton *buttonNext = (UIButton*)[self viewWithTag:888];
        [buttonNext setTitle:@"Start tour" forState:UIControlStateNormal];
        [buttonNext setImage:nil forState:UIControlStateNormal];
        
        UIButton *buttonPrevious = (UIButton*)[self viewWithTag:999];
        [buttonPrevious setTitle:@"Skip" forState:UIControlStateNormal];
        [buttonPrevious setImage:nil forState:UIControlStateNormal];
        return;
    }
    
    
    if (NUM_IMAGES == page + 1) {
        UIButton *button = (UIButton*)[self viewWithTag:888];
        [button setTitle:@"Got it" forState:UIControlStateNormal];
        [button setImage:nil forState:UIControlStateNormal];
        
        UIButton *buttonPrevious = (UIButton*)[self viewWithTag:999];
        [buttonPrevious setTitle:@"<--" forState:UIControlStateNormal];


    }else{
        UIButton *buttonNext = (UIButton*)[self viewWithTag:888];
        [buttonNext setTitle:@"-->" forState:UIControlStateNormal];
        
        UIButton *buttonPrevious = (UIButton*)[self viewWithTag:999];
        [buttonPrevious setTitle:@"<--" forState:UIControlStateNormal];
    }
    
   
}

- (void)AddButtonsOnTour{
    
    UIView *viewBottonControls = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44)];
    [viewBottonControls setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *previous = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewBottonControls addSubview:previous];
    [previous setFrame:CGRectMake(5, 6, 100, 32)];
    [previous.layer setCornerRadius:2.0];

    previous.tag = 999;
    
    [previous setBackgroundColor:UIColorFromRGB(0xc92017)];
    [previous setTitle:@"Skip" forState:UIControlStateNormal];

    [previous addTarget:self action:@selector(handlePreviousAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.tag = 888;
    [next setBackgroundColor:[UIColor colorWithRed:43.0f/255 green:69.0f/255 blue:82.0f/255 alpha:1.0]];
    [next.layer setCornerRadius:2.0];
    [next setFrame:CGRectMake(viewBottonControls.frame.size.width - 105, 6, 100, 32)];
    [next setTitle:@"Start tour" forState:UIControlStateNormal];

    [viewBottonControls addSubview:next];
    [next addTarget:self action:@selector(handleNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewBottonControls];

    self.pageControl.frame = CGRectMake(self.frame.size.width/2 - 50, self.frame.size.height - 30, previous.frame.size.width, 20);

    self.pageControl.userInteractionEnabled = NO;
    [self bringSubviewToFront:self.pageControl];
}

- (void)handleNextAction:(UIButton*)sender{
    if ([sender.titleLabel.text isEqualToString:@"Got it"]||[sender.titleLabel.text isEqualToString:@"Skip"]) {
        [self hiddenView];
    }else{
        
        [self.scrollImages setContentOffset:CGPointMake(self.scrollImages.frame.size.width * (self.pageControl.currentPage + 1), 0.0f) animated:YES];
    }
}


- (void)handlePreviousAction:(UIButton*)sender{
    if ([sender.titleLabel.text isEqualToString:@"Got it"]||[sender.titleLabel.text isEqualToString:@"Skip"]) {
        [self hiddenView];
    }else{
        
        [self.scrollImages setContentOffset:CGPointMake(self.scrollImages.frame.size.width * (self.pageControl.currentPage - 1), 0.0f) animated:YES];

    }
}

-(void)hiddenView
{
    [self setHidden:YES];
    [self performSelector:@selector(removeTourView) withObject:nil afterDelay:10.0];
}
- (void)removeTourView{
    [self removeFromSuperview];
}
@end
