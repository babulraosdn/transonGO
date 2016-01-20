//
//  StateObject.h
//  toGo
//
//  Created by Babul Rao on 20/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateObject : NSObject
@property(nonatomic,strong) NSString *countryId;
@property(nonatomic,strong) NSString *countryName;
@property(nonatomic,strong) NSString *stateName;
@property(nonatomic,strong) NSString *createdAt;
//@property(nonatomic,strong) NSString *id;
@end
