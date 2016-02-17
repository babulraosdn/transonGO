//
//  CountryStore.h
//  toGo

//  Created by Babul Rao on 20/01/16.
//  Copyright © 2015 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountryObject.h"
@interface CountryStore : NSObject

//@property (nonatomic, strong) CountryObject *countryObject;
- (id)initWithJsonDictionary:(NSDictionary *)json;
@end
