//
//  Application.m
//  toGo
//
//  Created by Anil Upadhyay on 16/12/15.
//  Copyright (c) 2015 toGo. All rights reserved.
//

#import "Application.h"

@implementation Application

- (BOOL)openURL:(NSURL*)url {
    //Google_Plus
    if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"]) {
        
        return NO;
        
    } else if ([[url absoluteString] hasPrefix:@"https://accounts.google.com/o/oauth2/auth"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationOpenGoogleAuthNotification object:url];
        return NO;
        
    }
    
    return [super openURL:url];
}
@end
