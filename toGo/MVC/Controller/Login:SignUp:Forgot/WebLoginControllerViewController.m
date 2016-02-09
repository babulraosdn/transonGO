//
//  WebLoginControllerViewController.m
//  toGo
//
//  Created by Anil Upadhyay on 16/12/15.
//  Copyright (c) 2015 toGo. All rights reserved.
//

#import "WebLoginControllerViewController.h"
#import <GooglePlus/GooglePlus.h>

@interface WebLoginControllerViewController (){
    NSURL *_loadURL;
}

@end

@implementation WebLoginControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate =  self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:_loadURL]];
}

-(void)loadURL:(NSURL *)loadURL{
    if (self.webView) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:loadURL]];
    }
    _loadURL = loadURL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] absoluteString] hasPrefix:@"com.smartdata.interpreter:/oauth2callback"]) {
       // [GPPURLHandler handleURL:url sourceApplication:@"com.google.chrome.ios"n annotation:nil];
        [GPPURLHandler handleURL:[request URL]
               sourceApplication:@"com.apple.mobilesafari"
                      annotation:nil];
        // Looks like we did log in (onhand of the url), we are logged in, the Google APi handles the rest
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    [[[UIAlertView alloc]initWithTitle:@"" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)actionForTopBar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
