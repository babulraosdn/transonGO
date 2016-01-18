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
@property(nonatomic,strong) NSString *firstNameString;
@property(nonatomic,strong) NSString *lastNameString;
@property(nonatomic,strong) NSString *nickNameString;
@property(nonatomic,strong) NSString *addressString;
@property(nonatomic,strong) NSString *genderString;
@property(nonatomic,strong) NSString *dobString;
@property(nonatomic,strong) NSString *descriptionString;

@property(nonatomic,strong) NSString *phoneNumberString;
@property(nonatomic,strong) NSString *bankAccountInfoString;
@property(nonatomic,strong) NSString *myLanguagesString;
@property(nonatomic,strong) NSString *certificatesString;
@property(nonatomic,strong) NSString *imageURLString;

@property(nonatomic,strong) NSString *cardNumberString;
@property(nonatomic,strong) NSString *cardTypeString;
@property(nonatomic,strong) NSString *expMonthString;
@property(nonatomic,strong) NSString *expYearString;
@property(nonatomic,strong) NSString *CVVString;

@property(nonatomic,strong) NSString *countryString;
@property(nonatomic,strong) NSString *stateString;
@property(nonatomic,strong) NSString *cityString;
@property(nonatomic,strong) NSString *postalCodeString;
@property(nonatomic,strong) NSString *eINtaxIDString;

@property(nonatomic,readwrite) BOOL isPhoneNumberEdit;
@property(nonatomic,readwrite) BOOL isAddressEdit;
@property(nonatomic,readwrite) BOOL isDescriptionEdit;
@property(nonatomic,readwrite) BOOL isNickNameEdit;
@property(nonatomic,readwrite) BOOL isCityEdit;
@property(nonatomic,readwrite) BOOL isPostalCodeEdit;
@property(nonatomic,readwrite) BOOL isGenderEdit;
@property(nonatomic,readwrite) BOOL isCertificatesEdit;
@property(nonatomic,readwrite) BOOL isEinTaxEdit;

@property(nonatomic,readwrite) BOOL isCardNumberEdit;
@property(nonatomic,readwrite) BOOL isCardTypeEdit;
@property(nonatomic,readwrite) BOOL isExpMonthEdit;
@property(nonatomic,readwrite) BOOL isExpYearEdit;
@property(nonatomic,readwrite) BOOL isCVVEdit;

@property(nonatomic,readwrite) BOOL isFirstNameEdit;
@property(nonatomic,readwrite) BOOL isLastNameEdit;

@end
