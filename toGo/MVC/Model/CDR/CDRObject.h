//
//  CDRObject.h
//  toGO
//
//  Created by Babul Rao on 09/02/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterpreterListObject.h"
@interface CDRObject : NSObject
////These fields added to save the call details to  Object to send when the call ends in AppDelegate 
@property(nonatomic,strong) NSString *startTimeString;
@property(nonatomic,strong) NSString *endTimeString;
@property(nonatomic,strong) NSString *fromLanguageString;
@property(nonatomic,strong) NSString *toLanguageString;
@property(nonatomic,strong) NSString *fromLanguageIDString;
@property(nonatomic,strong) NSString *toLanguageIDString;
@property(nonatomic,strong) NSString *costString;
@property(nonatomic,strong) NSString *callReceivedUserIDString;
@property(nonatomic,strong) NSMutableArray *callingUsers;
@property(nonatomic,strong) InterpreterListObject *receivedInterpreter;
@property(nonatomic,strong) NSString *conferenceIDString;

////////Additional Fields to show in CallHistory
@property(nonatomic,strong) NSString *imageURLString;
@property(nonatomic,strong) NSString *nickNameString;
@property(nonatomic,strong) NSString *durationString;
@end
