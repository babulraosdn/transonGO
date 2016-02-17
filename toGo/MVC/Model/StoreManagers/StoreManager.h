//
//  StoreManagerr.h
//  toGo

//  Created by Babul Rao on 20/01/16.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryObject.h"


@interface StoreManager : NSObject
+ (StoreManager *)sharedManager;

//- (BOOL)addCountryObject:(CountryObject*)countryObject;
- (NSMutableArray*)getCountryObject;
- (void)removeCountryObjects;

@end
