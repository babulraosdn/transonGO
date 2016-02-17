//
//  MyLanguagesView.h
//  toGo
//
//  Created by Babul Rao on 06/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol MyLanguagesDelegate <NSObject>
-(void)finishLanguagesSelection:(NSMutableArray *)selectedDataArray;
-(void)finishCountrySelection:(NSMutableArray *)selectedDataArray;
-(void)finishStateSelection:(NSMutableArray *)selectedDataArray;
@end

@interface MyLanguagesView : UIView <UITableViewDataSource,UITableViewDelegate>{
    
    
}
@property(nonatomic,strong) UITableView *tblView;
@property(nonatomic,strong) NSMutableArray *selectedDataArray;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,readwrite) BOOL isCountry;
@property(nonatomic,readwrite) BOOL isState;
@property(nonatomic,readwrite) BOOL isCustomer;
@property(nonatomic,readwrite) BOOL isSelectInterpretationLanguage;

@property(nonatomic,weak)id <MyLanguagesDelegate> delegate;
-(void)assignData;
@end
