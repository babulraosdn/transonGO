//
//  CountryObject.h
//  toGo
//
//  Created by Babul Rao on 20/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Headers.h"
@interface CountryObject : NSObject
@property(nonatomic,strong) NSString *countryCode;
@property(nonatomic,strong) NSString *countryName;
@property(nonatomic,strong) NSString *createdAt;
//@property(nonatomic,strong) NSString *id;

- (id)initWithStoreDictionary:(NSDictionary *)json;
@end
