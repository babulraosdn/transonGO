//
//  Utility.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "Utility.h"
@interface Utility ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    id delegate;
}
@end

@implementation Utility

+(Utility *)sharedInstance{
    static Utility *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance=[Utility new];
    });
    return sharedInstance;
}

- (BOOL)validateEmailWithString:(NSString*)emailAddress{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailAddress];
}

-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message inView:(UIViewController *)viewController withStyle:(UIAlertControllerStyle)alertStyle{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:alertStyle];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [App_Delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(UIViewController *)getControllerForIdentifier:(NSString *)controllerIdentifier {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:controllerIdentifier];
}


-(void)getImageFromCameraOrGallery:(UIButton*)button delegate:(id)delegateObject{
    delegate=delegateObject;
    if (button.tag==0) {
        [self openDeviceCamera:delegate];
    }
    else if (button.tag==1) {
        [self openDevicePhotoGallery:delegate];
        
    }
}
#pragma mark -
#pragma mark - ImagePicker Methods
- (void)openDeviceCamera:(id)delegateObject{
    delegate = delegateObject;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing=YES;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        [imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
        [delegate presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)openDevicePhotoGallery:(id)delegateObject{
    delegate = delegateObject;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing=YES;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        [delegate presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - ImagePickerController Delegate.
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [delegate getImageFromSource:(UIImage *)[info objectForKey:
                                             UIImagePickerControllerOriginalImage]];
    [delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [delegate dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)checkForNullString:(id)string
{
    if ([string isKindOfClass:[NSNull class]] || string==nil)
    {
        return @"";
    }
    else
    {
        if (![string isKindOfClass:[NSString class]])
        {
            NSString *str= [string stringValue];
            
            return str;
        }
        else
        {
            return string;
        }
    }
    
}

#pragma mark Date Format Methods

- (NSString *)stringFromDateWithFormat :(NSString *)formatString date:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    //Optionally for time zone conversions
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    return  [formatter stringFromDate:date];
}

- (NSDate *)changeDateFormatWithFormatterString:(NSString *)formatterString date:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    return [formatter dateFromString:dateString];
}

- (NSDate *)changeDateFormatFromDate:(NSString *)formatterString date:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSString *dateString = [formatter stringFromDate:date];
    return [formatter dateFromString:dateString];
}


#pragma Mark Padding Methods
-(UIView *)leftPaddingView{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    return paddingView;
}

-(UIView *)setImageViewPadding:(NSString *)imageName frame:(CGRect)requiredImageViewFrame{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
    UIImageView *paddingImageView = [[UIImageView alloc] initWithFrame:requiredImageViewFrame];
    paddingImageView.image=[UIImage imageNamed:imageName];
    [paddingView addSubview:paddingImageView];
    return paddingView;
}



#pragma mark UserDefaults Saving
-(void) writeStringUserPreference:(NSString *) key value:(NSString *) value {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

-(void) clearStringFromUserPreference:(NSString *) key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

-(NSString *) readStringUserPreference:(NSString *) key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSString *) [userDefaults objectForKey:key];
}

-(void)removeUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for (NSString *key in [dictionary allKeys])
    {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}


@end
