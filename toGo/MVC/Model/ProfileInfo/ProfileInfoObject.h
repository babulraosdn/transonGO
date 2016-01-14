//
//  ProfileInfoObject.h
//  toGo
//
//  Created by Babul Rao on 28/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileInfoObject : NSObject
@property(nonatomic,strong) NSString *idString;
@property(nonatomic,strong) NSString *uIdString;
@property(nonatomic,strong) NSString *emailString;
@property(nonatomic,strong) NSString *passwordString;
@property(nonatomic,strong) NSString *nameString;
@property(nonatomic,strong) NSString *nickNameString;
@property(nonatomic,strong) NSString *addressString;
@property(nonatomic,strong) NSString *phoneNumberString;
@property(nonatomic,strong) NSString *bankAccountInfoString;
@property(nonatomic,strong) NSString *myLanguagesString;
@property(nonatomic,strong) NSString *certificatesString;
@property(nonatomic,strong) NSString *imageURLString;

@property(nonatomic,strong) NSString *countryString;
@property(nonatomic,strong) NSString *stateString;
@property(nonatomic,strong) NSString *cityString;
@property(nonatomic,strong) NSString *postalCodeString;
@property(nonatomic,strong) NSString *eINtaxIDString;

@property(nonatomic,readwrite) BOOL isPhoneNumberEdit;
@property(nonatomic,readwrite) BOOL isAddressEdit;
@property(nonatomic,readwrite) BOOL isNickNameEdit;
@property(nonatomic,readwrite) BOOL isCityEdit;
@property(nonatomic,readwrite) BOOL isPostalCodeEdit;

@end
