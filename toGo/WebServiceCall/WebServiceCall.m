//
//  WebServiceCall.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "WebServiceCall.h"
#import "Headers.h"
@implementation WebServiceCall

+(WebServiceCall *)sharedInstance{
    
    static WebServiceCall *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance=[WebServiceCall new];
    });
    return sharedInstance;
}

-(void)serviceCall:(NSMutableDictionary*)payload webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,webServicename]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json; charset=UTF-8"  forHTTPHeaderField:@"Content-Type"];
    
    NSError *err = nil;
   
    NSData *body = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    
   NSLog(@"\n=====================Request=================================\nURL String : %@\nParameters :\n%@\n=========================End Request=============================",request.URL.absoluteString,[payload description]);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          NSError *errorNIl = nil;
          if (!error)
          {
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@" %@ Response dict--> %@",webServicename,dictResponse);
              successBlock([@"200" intValue],dictResponse);
          }
          else{
              NSLog(@" %@ FAILURE Description--> %@",webServicename,error.description);
              failureBlock(nil,[@"404" intValue],error);
          }
      }] resume];
}


-(void)getProfileInfoServiceCall:(NSString*)headerString webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,webServicename]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json; charset=UTF-8"  forHTTPHeaderField:@"Content-Type"];
    [request addValue:headerString  forHTTPHeaderField:KAUTHORIZATION_W];

    NSLog(@"\n=====================Request=================================\nURL String : %@\nParameters :\n%@\n=========================End Request=============================",request.URL.absoluteString,headerString);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          NSError *errorNIl = nil;
          if (!error)
          {
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@" %@ Response dict--> %@",webServicename,dictResponse);
              successBlock([@"200" intValue],dictResponse);
          }
          else{
              NSLog(@" %@ FAILURE Description--> %@",webServicename,error.description);
              failureBlock(nil,[@"404" intValue],error);
          }
      }] resume];
}




-(void)serviceCallWithRequestType:(NSMutableDictionary*)payload requestType:(NSString*)rquestTypeString includeHeader:(BOOL)isIncludeHeader includeBody:(BOOL)isIncludeBody webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,webServicename]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:rquestTypeString];
    [request addValue:@"application/json; charset=UTF-8"  forHTTPHeaderField:@"Content-Type"];
    if (isIncludeHeader) {
        [request addValue:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]  forHTTPHeaderField:KAUTHORIZATION_W];
    }
    if (isIncludeBody) {
        NSError *err = nil;
        NSData *body = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
        [request setHTTPBody:body];
        [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    }
    
    NSLog(@"\n=====================Request=================================\nURL String : %@\nParameters :\n%@\n=========================End Request=============================",request.URL.absoluteString,[payload description]);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          NSError *errorNIl = nil;
          if (!error)
          {
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@" %@ Response dict--> %@",webServicename,dictResponse);
              successBlock([@"200" intValue],dictResponse);
          }
          else{
              NSLog(@" %@ FAILURE Description--> %@",webServicename,error.description);
              failureBlock(nil,[@"404" intValue],error);
          }
      }] resume];
}

-(void)profileImageUpload_FormData:(NSMutableDictionary*)payload requestType:(NSString*)rquestTypeString includeHeader:(BOOL)isIncludeHeader includeBody:(BOOL)isIncludeBody webServicename:(NSString *)webServicename SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://54.153.22.179/api/upload"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:rquestTypeString];
    //[request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];//1
    //[request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];//2
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;"];//3
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];//3
    
    //[request addValue:@"application/json; charset=UTF-8"  forHTTPHeaderField:@"Content-Type"];
    if (isIncludeHeader) {
        [request addValue:[NSString stringWithFormat:@"%@%@",@"Bearer ",[Utility_Shared_Instance readStringUserPreference:USER_TOKEN]]  forHTTPHeaderField:KAUTHORIZATION_W];
    }
    if (isIncludeBody) {
        NSError *err = nil;
        NSData *body = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
        [request setHTTPBody:body];
        //[request setValue:[NSString stringWithFormat:@"%d", body.length] forHTTPHeaderField:@"Content-Length"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    }
    
    
    
    
    NSLog(@"\n=====================Request=================================\nURL String : %@\nParameters :\n%@\n=========================End Request=============================",request.URL.absoluteString,[payload description]);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          NSError *errorNIl = nil;
          if (!error)
          {
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@" %@ Response dict-profileImageUpload_FormData-> %@",webServicename,dictResponse);
              successBlock([@"200" intValue],dictResponse);
          }
          else{
              NSLog(@" %@ FAILURE Description-profileImageUpload_FormData-> %@",webServicename,error.description);
              failureBlock(nil,[@"404" intValue],error);
          }
      }] resume];
    
}


@end
