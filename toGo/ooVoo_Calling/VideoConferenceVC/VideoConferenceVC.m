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
    if ([UserDefaults getBoolForToKey:@"APP_VIDEO_RENDER"]) // if true we want the custom
    {
        self.videoPanelViewRender.delegate=self;
    [self.sdk.AVChat.VideoController bindVideoRender:[ActiveUserManager activeUser].userId render:self.videoPanelViewRender];
       
        [self.videoPanelView removeFromSuperview];
        self.videoPanelView = nil ;
    }
    else
    {

        self.videoPanelView.delegate=self;
        [self.sdk.AVChat.VideoController bindVideoRender:[ActiveUserManager activeUser].userId render:self.videoPanelView];
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
    int widht = 125;
    int height = 125;
    int trailingSpace = 0;
    _videoPanelView.frame = CGRectMake(self.view.frame.size.width - height - trailingSpace, self.view.frame.size.height - 167, widht, height);
    currentFullScreenPanel = panel;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    

}
@end









