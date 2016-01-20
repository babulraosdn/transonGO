//
//  NSString+Extensions.m
//  toGo

//  Created by Babul Rao on 21/12/15.
//  Copyright © 2015 smartData. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+(NSString *)messageWithString:(NSString *)messsage{
 
    return [NSString stringWithFormat:@"%@ %@",NSLOCALIZEDSTRING(@"PLEASE_ENTER"),messsage];
}

+(NSString *)messageWithSAVEString:(NSString *)messsage{
    
    return [NSString stringWithFormat:@"%@ %@",NSLOCALIZEDSTRING(@"PLEASE_SAVE"),messsage];
}

+(NSString *)navigationBarTitle{
    return [NSString stringWithFormat:@"%@",NSLOCALIZEDSTRING(@"TOGO")];
}

@end
