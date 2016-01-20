//
//  WebServiceCall.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking.h>
#import "Constants.h"
#import "Headers.h"

typedef void(^tFailureBlock)(NSInteger responseCode,NSError *error);
typedef void (^tResponseBlock)(NSInteger responseCode,id responseObject);
typedef void (^tFailureResponse)(id responseObject,NSInteger responseCode,NSError *error);

@interface WebServiceCall : NSObject

+(WebServiceCall *)sharedInstance;
-(void)serviceCall:(NSMutableDictionary*)payload webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock;

-(void)getProfileInfoServiceCall:(NSString*)headerString webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock;

-(void)serviceCallWithRequestType:(NSMutableDictionary*)payload requestType:(NSString*)rquestTypeString includeHeader:(BOOL)isIncludeHeader includeBody:(BOOL)isIncludeBody webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock;

-(void)profileImageUpload_FormData:(NSMutableDictionary*)payload requestType:(NSString*)rquestTypeString includeHeader:(BOOL)isIncludeHeader includeBody:(BOOL)isIncludeBody webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock;
@end
