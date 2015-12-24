//
//  WebServiceCall.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "WebServiceCall.h"

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
    
    //NSMutableDictionary *dict = payload;// [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"ios",@"UserName",@"123456",@"Password",@"(null)",@"regid", nil];
    //http://localhost:3000/api/signup
    //http://app.plugdapp.com/PluggedApp.svc/Login
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"http://172.10.55.110:3000/signup"]];
    NSLog(@"Request URL %@",[NSString stringWithFormat:@"%@",url]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:120.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json; charset=UTF-8"  forHTTPHeaderField:@"Content-Type"];
    
    NSError *err = nil;
    //NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithDictionary:payload];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&err];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField: @"Content-Length"];
    //NSLog(@"Paramater %@",dict);
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          [SVProgressHUD dismiss];
          NSError *errorNIl = nil;
          if (!error)
          {
              NSDictionary *dictResponse =[NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorNIl]];
              NSLog(@"Response dict : %@",dictResponse);
              //Delegate Calling
              successBlock([@"200" intValue],dictResponse);
              //failureBlock(responseDictionary,[operation.response statusCode],error);
          }
          else{
              failureBlock(nil,[@"404" intValue],error);
          }
      }] resume];
    
    /*
//    /http://redrocksonline.com/api/events
    NSString *URL = @"http://app.plugdapp.com/PluggedApp.svc/Login";// [NSString stringWithFormat:@"%@%@",BASE_URL,webServicename];
    NSArray *keys = [NSArray arrayWithObjects:@"UserName",@"Password",@"regid", nil];
    
    NSArray *objects = [NSArray arrayWithObjects:@"chris",@"123456",@"<null>", nil];
    
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];

    NSError *error = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSURL *appService = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
    // Set method, body & content-type
    request.HTTPMethod = @"POST";
    request.HTTPBody = [payload dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[[jsonString dataUsingEncoding:NSUTF8StringEncoding] length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           id responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                           if(error == nil)
                                                           {
                                                               
                                                           }
                                                       }];
    [dataTask resume];
    
    */
    
    /*
    // Initialize Session Configuration
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Initialize Session Manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    // Configure Manager
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    // Send Qυеѕtіοn fοr
    //NSURLRequest *еѕtіοnfοr = [NSURLRequest requestWithURL:URL];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        id responseIs =[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"---respo--%@",responseIs);
        // Process Response Object
    }] resume];*/
    
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,webServicename];
//    NSMutableURLRequest *request = [self initalizeRequest:urlString forPayload:payload];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    //NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
//    //NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        return successBlock(response,responseDictionary);
//           //NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        //return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    [downloadTask resume];
    
    /*
    NSMutableURLRequest *request = [self initalizeRequest:urlString forPayload:payload];
   
    [[AFURLSessionManager alloc]dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    
        NSLog(@"---response Object is = %@",responseObject);
        NSLog(@"---response is = %@",response);
        
    }];
    */
    
    /*
    NSURL *url = [NSURL URLWithString:@"http://www.hfrmovies.com/TheHobbitDesolationOfSmaug48fps.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request progress:&progress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"ss");
        successBlock(res,response);

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        failureBlock(response,response,error);
    }];
    */
    
    /*
     [session downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
     // …
     NSLog(@"222");
     } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
     NSLog(@"222");
     [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
     // …
     
     }];
     */
    
    
    /*
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        ////NSLog(@"operationSuccess:%@",responseObject);
        id responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        successBlock([operation.response statusCode],responseDictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"error:%@",[error localizedDescription]);
        if (operation.responseObject == nil)
        {
            failureBlock(nil,0,error);
            return;
        }
        id responseDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:0 error:nil];
        failureBlock(responseDictionary,[operation.response statusCode],error);
    }];
    [operation start];
    */
}

#pragma mark NSMutableURLRequest
-(NSMutableURLRequest*)initalizeRequest:(NSString*)urlString forPayload:(NSString*)payload{
    
    NSURL *appService = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
    // Set method, body & content-type
    request.HTTPMethod = @"POST";
    request.HTTPBody = [payload dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[[payload dataUsingEncoding:NSUTF8StringEncoding] length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

@end
