//
//  ProfileInfoObject.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileInfoObject : NSObject
@property(nonatomic,strong) NSString *emailString;
@property(nonatomic,strong) NSString *passwordString;
@property(nonatomic,strong) NSString *nameString;
@property(nonatomic,strong) NSString *nickNameString;
@property(nonatomic,strong) NSString *addressString;
@property(nonatomic,strong) NSString *phoneNumberString;
//@property(nonatomic,strong) NSString *descriptionString;
@property(nonatomic,strong) NSString *bankAccountInfoString;
@property(nonatomic,strong) NSString *myLanguagesString;
@property(nonatomic,strong) NSString *certificatesString;

@property(nonatomic,readwrite) BOOL isPhoneNumberEdit;
@property(nonatomic,readwrite) BOOL isAddressEdit;
@end
