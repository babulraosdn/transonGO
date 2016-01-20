//
//  CountryObject.m
//  toGo
//
//  Created by Babul Rao on 20/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "CountryObject.h"

@implementation CountryObject
- (id)initWithStoreDictionary:(NSDictionary *)dictionary
{
    if (self == [super init]) {
        @try {
            _countryCode = [NSString stringWithString:[dictionary objectForKey:KCOUNTRY_CODE_W]];
            _countryName = [NSString stringWithString:[dictionary objectForKey:KCOUNTRY_NAME_W]];
            _createdAt = [NSString stringWithString:[dictionary objectForKey:KCREATED_AT_W]];
        }
        @catch (NSException *exception) {
            NSLog(@"EXCEPTION raised, reason was: %@", [exception reason]);
        }
    }
    return self;
}

@end
