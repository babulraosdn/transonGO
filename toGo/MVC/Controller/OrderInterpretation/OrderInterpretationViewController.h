//
//  OrderInterpretationViewController.h
//  toGo
//
//  Created by Babul Rao on 25/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headers.h"
#import <ooVooSDK/ooVooSDK.h>

@interface OrderInterpretationViewController : BaseViewController<MyLanguagesDelegate,ooVooAccount>
@property (retain, nonatomic) ooVooClient *sdk;

@end
