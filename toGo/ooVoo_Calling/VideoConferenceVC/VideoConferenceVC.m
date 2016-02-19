//
//  VideoConferenceVC.m
//  ooVooSample
//
//  Created by Udi on 8/2/15.
//  Copyright (c) 2015 ooVoo LLC. All rights reserved.
//

#import "ActiveUserManager.h"

#import "VideoConferenceVC.h"

#import "UserDefaults.h"

#import "AppDelegate.h"
#import "MessageManager.h"
#import "InterpreterListObject.h"

@interface VideoConferenceVC ()

@end

@implementation VideoConferenceVC

#pragma  mark - VIEW CYCLE

- (void)dealloc {
    
    [_videoPanelView removeFromSuperview];
  
    
    _videoPanelView=nil;
   
    
    [_videoPanelViewRender removeFromSuperview];
    _videoPanelViewRender=nil;

}

-(NSString*)stringFromSelectedClass{
    if ([UserDefaults getBoolForToKey:@"APP_VIDEO_RENDER"]) {
        return @"UserVideoPanelRender";
    }
return @"UserVideoPanel";
}

-(void)removeDelegates{
     self.videoPanelView.delegate=nil;
    self.videoPanelViewRender.delegate=nil;
    
    [super removeDelegates];
  }

-(void)setVideoPanel{
    // the panel render is on top than remove it
    NSLog(@"setVideoPanel--->%d",[UserDefaults getBoolForToKey:@"APP_VIDEO_RENDER"]);
    if ([UserDefaults getBoolForToKey:@"APP_VIDEO_RENDER"]) // if true we want the custom
    {
        NSLog(@"---UserId-APP_VIDEO_RENDER->%@",[ActiveUserManager activeUser].userId);
        self.videoPanelViewRender.delegate=self;
    [self.sdk.AVChat.VideoController bindVideoRender:[ActiveUserManager activeUser].userId render:self.videoPanelViewRender];
       
        [self.videoPanelView removeFromSuperview];
        self.videoPanelView = nil ;
    }
    else
    {
        NSLog(@"---UserId-->%@",[ActiveUserManager activeUser].userId);

        self.videoPanelView.delegate=self;
        [self.sdk.AVChat.VideoController bindVideoRender:[ActiveUserManager activeUser].userId render:self.videoPanelView];
        //[self animateVideoToFullSize];
        [self.videoPanelViewRender removeFromSuperview];
        self.videoPanelViewRender = nil ;

        //These line commented to make the "Me" video small left hand corner
        _videoPanelView.alpha = 0.0;
        [self performSelector:@selector(userVideoFrameSetting) withObject:nil afterDelay:9.0];
        ////////////////////////
        
    }
}

-(void)userVideoFrameSetting{
    [self UserMainPanel_Touched:_videoPanelView];
    _videoPanelView.alpha = 1.0;
}

-(void)checkPanelSize:(id)currentFullScreenPanel{
 
    if (_videoPanelView  && (_videoPanelView == currentFullScreenPanel)){
         //[self UserMainPanel_Touched:_videoPanelView];
    }
    
    if (_videoPanelViewRender && (_videoPanelViewRender == currentFullScreenPanel)) {
        //[self UserMainPanel_Touched:_videoPanelViewRender];

    }
}


#pragma mark - Orientation
-(id)videoPanel{
    if (self.videoPanelView)
        return self.videoPanelView;
    else
        return self.videoPanelViewRender;
    
}

-(void)setVideoPanelName{
    self.videoPanelView.strUserId = @"Me";
}

-(void)UserMainPanel_Touched:(id)panel{

    if (!isCameraStateOn && (panel == self.videoPanelViewRender || panel==self.videoPanelView))
    {
        return;
    }
    
    _videoPanelView = (UserVideoPanel *)panel;
    int widht = 150;
    int height = 150;
    int trailingSpace = 15;
    _videoPanelView.frame = CGRectMake(self.view.frame.size.width - height - trailingSpace, self.view.frame.size.height - 240, widht, height); //CGRectMake(155, 185, 150, 150);
    currentFullScreenPanel = panel;
    
    //These line commented to make the "Me" video small left hand corner
    /*
    if (panel == self.videoPanelViewRender || panel==self.videoPanelView)
    {
    
            NSLog(@"it's the big view");
            [self.viewScroll bringSubviewToFront:panel];
            
            if ( (self.constrainBottomViewVideo.constant==0 && self.videoPanelView ) || (self.constrainBottomViewVideoRender.constant==0 && self.videoPanelViewRender ) )
            {
                [super animateVideoBack];
                if ([self isIpad])
                {
                    [self setScrollViewToXPosition:scrollLastposition];
                } else {
                    [self setScrollViewToYPosition:scrollLastposition];
                }
                
                self.viewScroll.scrollEnabled=true;
                currentFullScreenPanel = NULL;
                [self refreshScrollViewContentSize];
            }
            else if ((self.constrainBottomViewVideo.constant==-44 && self.videoPanelView ) ||
                 (self.constrainBottomViewVideoRender.constant==-44 && self.videoPanelViewRender ) ) // default size before conference Dont resize
                return;
            else
            {
                [self animateVideoToFullSize];
                [self.viewScroll bringSubviewToFront:panel];
                currentFullScreenPanel = panel;
                //_pageControl.hidden=true;
                self.pageControl.hidden=true;
                
                if ([self isIpad]) {
                    scrollLastposition = self.viewScroll.contentOffset.x;
                    [self setScrollViewToXPosition:0];
                } else {
                    scrollLastposition = self.viewScroll.contentOffset.y;
                    [self setScrollViewToYPosition:0];
                }
                self.viewScroll.scrollEnabled=false;
            }
            return;
    }
    else
    {
        [super somePanelTouched:panel];
    }
    */
}

-(void)viewWillDisappear:(BOOL)animated{
    
//    [super viewWillDisappear:animated];
//    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    
//    for (InterpreterListObject *iObj in appDelegate.interpreterListArray) {
//        NSMutableArray *array = [NSMutableArray new];
//        [array addObject:iObj.uidString];
//        [[MessageManager sharedMessage]messageOtherUsers:array WithMessageType:Cancel WithConfID:[ActiveUserManager activeUser].randomConference Compelition:^(BOOL CallSuccess) {
//            
//        }];
//    }
//    
//    [self.sdk.AVChat.VideoController unbindVideoRender:nil render:[self videoPanel]];
//    [self.sdk.AVChat leave];
//    [self.sdk.AVChat.AudioController unInitAudio:^(SdkResult *result) {
//        NSLog(@"unInit Resoult %d",result.Result);
//    }];
    
    

}
@end









