//
//  CNMessage.m
//  ooVooSample
//
//  Created by Noam Segal on 7/26/15.
//  Copyright (c) 2015 ooVoo LLC. All rights reserved.
//

#import "CNMessage.h"
#import "NSData+Base64.h"

#import "MessageManager.h"
#import "ActiveUserManager.h"

NSString * const MESSAGE_TYPE = @"type";
NSString * const CONFERENCE_ID     = @"conference id";
NSString * const DISPLAY_NAME      = @"display name";
NSString * const EXTRA_MESSAGE     = @"extra message";
NSString * const UNIQUE_ID         = @"unique id";

NSString * const TYPE_CALLING      = @"calling";
NSString * const TYPE_ANS_ACCEPT   = @"accept";
NSString * const TYPE_ANS_DECLINE  = @"decline";
NSString * const TYPE_CANCEL       = @"cancel";
NSString * const TYPE_BUSY         = @"busy";
NSString * const TYPE_END_CALL     = @"end_call";


@implementation CNMessage

+(NSString*) cnMessageTypeToString:(CNMessageType) type{
    switch(type){
        case Calling:
            return TYPE_CALLING;
        case AnswerAccept:
            return TYPE_ANS_ACCEPT;
        case AnswerDecline:
            return TYPE_ANS_DECLINE;
        case Cancel:
            return TYPE_CANCEL;
        case Busy:
            return TYPE_BUSY;
        case EndCall:
            return TYPE_END_CALL;
        default:
            return nil;
    }
}

+(CNMessageType) cnMessageStringToType:(NSString *) typeStr{
    
    if([typeStr isEqualToString:TYPE_CALLING])
        return Calling;
    else if([typeStr isEqualToString:TYPE_ANS_ACCEPT])
        return AnswerAccept;
    else if([typeStr isEqualToString:TYPE_ANS_DECLINE])
        return AnswerDecline;
    else if([typeStr isEqualToString:TYPE_CANCEL])
        return Cancel;
    else if([typeStr isEqualToString:TYPE_BUSY])
        return Busy;
    else if([typeStr isEqualToString:TYPE_END_CALL])
        return EndCall;
    else
        return Unknown;
}

+(NSString *) buildMessage:(CNMessageType) type confId:(NSString *) confId to:(NSArray *) to name:(NSString *) name userData:(NSString*) extra{
    
    NSMutableDictionary * dictionary  = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[CNMessage cnMessageTypeToString:type] forKey:MESSAGE_TYPE];
    [dictionary setValue:confId forKey:CONFERENCE_ID];
    [dictionary setValue:name forKey:DISPLAY_NAME];
  
    if(extra)
        [dictionary setValue:extra forKey:EXTRA_MESSAGE];
    else
        [dictionary setValue:@"" forKey:EXTRA_MESSAGE];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString* aStr;
    aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", aStr);
    
    // *base64Encoded = [jsonData base64EncodedStringWithOptions:0];
    
    return aStr;
}

-(void) decodeMessage:(NSString *)base64Encoded{
    
   NSData* data = [base64Encoded dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError * error;
    NSDictionary * dictionary =[NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
    self.type = [CNMessage cnMessageStringToType:[dictionary valueForKey:MESSAGE_TYPE]];
    self.confId = [dictionary valueForKey:CONFERENCE_ID];
    self.displayName = [dictionary valueForKey:DISPLAY_NAME];
    
    self.userData = [dictionary valueForKey:EXTRA_MESSAGE];
    self.uniqueId = [dictionary valueForKey:UNIQUE_ID];
}

- (instancetype) initMessageWithParams:(CNMessageType) type confId:(NSString *) confId to:(NSArray*)arrTo name:(NSString *) name userData:(NSString*) extra{
    
    if (type == AnswerDecline) {
        App_Delegate.isCallDisconnectOrCallEndDefault = YES;
        [App_Delegate updateInterpreterCallStatus];
    }
    self = [super initMessageWithArrayUsers:arrTo message:[CNMessage buildMessage:type confId:confId to:arrTo name:name userData:extra]];

    if(self){
       
    }
    return self;
}

/*
Recognizes when any user accepts the call.
Disconencting the Remainig Calls.
Updating Disconnected users status in DB.
*/

- (instancetype) initMessageWithResponse:(ooVooMessage *) response{

    self = [super initMessage:response.to[0] message:response.body];
    if(self){
        [self decodeMessage:response.body];
        self.fromUseriD=response.from;
    }
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.callerIDString = response.from;
    NSString * string = response.body;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"uidString beginswith[c] %@",[dict objectForKey:@"display name"]];
    NSArray *sortedArray = [App_Delegate.interpreterListArray filteredArrayUsingPredicate:predicate];
    
    InterpreterListObject *iObj;
    if (sortedArray.count) {
        iObj = [sortedArray lastObject];
        App_Delegate.cdrObject.receivedInterpreter = iObj;
    }
    
    NSDictionary *dictIs = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([[dictIs objectForKey:@"type"] isEqualToString:@"accept"]) {
        
        App_Delegate.cdrObject.startTimeString = [Utility_Shared_Instance GetCurrentTimeStamp];
        App_Delegate.isCallDisconnectOrCallEndDefault = NO;
        
        NSMutableArray *tempArray = [NSMutableArray new];
        [tempArray addObjectsFromArray:appDelegate.callingUsers];
        
        [tempArray removeObject:iObj.uidString];
        
        App_Delegate.isConnected = YES;
        
        ////////This will change the remainig users status in Database to "0". "0" Indicates release this user from the pool.
        [appDelegate saveDisconnectedCallDetailsinServer:iObj isNoOnePicksCallorEndedByCustomer:NO];
        
        //If any one receives the call. We are disonccecting the rest of the calls disconnect
        for (NSString *remainigUser in tempArray) {
            [[MessageManager sharedMessage]messageOtherUsers:[NSArray arrayWithObject:remainigUser] WithMessageType:Cancel WithConfID:App_Delegate.conferenceIDString Compelition:^(BOOL CallSuccess) {
                
            }];
        }
        ////////////////////
    }
    
    return self;
}

@end
