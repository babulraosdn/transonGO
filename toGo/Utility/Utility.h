//
//  Utility.h
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Reachability.h"

@protocol UtilityProtocol <NSObject>
typedef void (^getImageData)(NSData *data);
typedef void (^getImage)(UIImage *image);
@optional
- (void)getImageFromSource:(UIImage *)image;
@end

@interface Utility : NSObject{
    Reachability *serverReachability;
    Reachability* hostReach;
    Reachability* wifiReach;
}

+(Utility *)sharedInstance;

- (BOOL)validateEmailWithString:(NSString*)emailAddress;

-(NSString*)preparePayloadForDictionary:(NSDictionary*)dictionary;

-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message inView:(UIViewController *)viewController withStyle:(UIAlertControllerStyle)alertStyle;
-(UIViewController *)getControllerForIdentifier:(NSString *)controllerIdentifier;

-(void)getImageFromCameraOrGallery:(UIButton*)button delegate:(id)delegateObject;

-(NSString *)checkForNullString:(id)string;

#pragma mark Date Format Methods
- (NSString *)stringFromDateWithFormat :(NSString *)formatString date:(NSDate *)date;
- (NSDate *)changeDateFormatWithFormatterString:(NSString *)formatterString date:(NSString *)dateString;
- (NSDate *)changeDateFormatFromDate:(NSString *)formatterString date:(NSDate *)date;

#pragma Mark Padding Methods
-(UIView *)leftPaddingView;
-(UIView *)setImageViewPadding:(NSString *)imageName frame:(CGRect)requiredImageViewFrame;


#pragma mark UserDefaults Saving
-(void) writeStringUserPreference:(NSString *) key value:(NSString *) value;
-(void) clearStringFromUserPreference:(NSString *) key;
-(NSString *) readStringUserPreference:(NSString *) key;
-(void)removeUserDefaults;
@end