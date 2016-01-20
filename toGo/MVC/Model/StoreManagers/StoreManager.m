//
//  StoreManager.m
//  toGo

//  Created by Babul Rao on 20/01/16.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "StoreManager.h"

@interface StoreManager ()
@property (nonatomic, retain) NSMutableArray *countryArray;
@end


@implementation StoreManager
static StoreManager *singletonManager = nil;

+ (StoreManager *)sharedManager
{
    if (singletonManager == nil) {
        singletonManager = [[self alloc]init];
    }
    return singletonManager;
}

- (id)init {
    if ([super init]) {
        _countryArray = [[NSMutableArray alloc]init];
        }
    return self;
}

#pragma mark Country Start
- (BOOL)addCountryObject:(CountryObject*)countryObject{
    BOOL isAdded = FALSE;
    if (countryObject != nil) {
        [_countryArray addObject:countryObject];
        isAdded = TRUE;
    }
    return isAdded;
}

- (NSMutableArray*)getCountryObject{
    return [_countryArray count]?_countryArray:nil;
}

- (void)removeCountryObjects{
    [_countryArray removeAllObjects];
}


@end
