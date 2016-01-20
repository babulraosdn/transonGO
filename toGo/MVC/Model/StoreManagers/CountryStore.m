//
//  CountryStore.m
//  toGo

//  Created by Babul Rao on 20/01/16.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "CountryStore.h"
#import "StoreManager.h"
@interface CountryStore ()
- (void)parseStoreObjectsFromResponse:(NSDictionary *)dictionary;

@end


@implementation CountryStore

- (id)initWithJsonDictionary:(NSDictionary *)json
{
    if (self = [super init]) {
        NSLog(@"%s: %@",__FUNCTION__, json);
        [self parseStoreObjectsFromResponse:json];
    }
    return self;
}


- (void)parseStoreObjectsFromResponse:(NSDictionary *)dictionary
{
    @try {
        [[StoreManager sharedManager] removeCountryObjects];
        
        id json =dictionary;
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            
        } else if ([json isKindOfClass:[NSArray class]]) {
            for (id jsonObject in (NSArray*)json) {
                /*
                _countryObject = [[CountryObject alloc]initWithStoreDictionary:(NSDictionary *)jsonObject];
                if([[StoreManager sharedManager] addCountryObject:_countryObject])
                    NSLog(@"_countryObject  added successfully");
                else
                    NSLog(@"Failed to add _countryObject");
                */
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EXCEPTION raised, reason was: %@", [exception reason]);
    }
    
}
@end
