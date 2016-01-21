//
//  MyLanguagesView.h
//  toGo
//
//  Created by Babul Rao on 06/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol MyLanguagesDelegate <NSObject>
-(void)finishLanguagesSelection:(NSMutableDictionary *)selectedDataArray;
-(void)finishCountrySelection:(NSMutableArray *)selectedDataArray;
-(void)finishStateSelection:(NSMutableArray *)selectedLanguagesDict;
@end

@interface MyLanguagesView : UIView <UITableViewDataSource,UITableViewDelegate>{
    
    
}
@property(nonatomic,strong) UITableView *tblView;
@property(nonatomic,strong) NSMutableDictionary *languagesDictionary;
@property(nonatomic,strong) NSMutableDictionary *selectedLanguagesDict;
@property(nonatomic,strong) NSMutableArray *selectedCountriesStatesArray;
@property(nonatomic,strong) NSMutableArray *countriesStatesArray;
@property(nonatomic,readwrite) BOOL isCountry;
@property(nonatomic,readwrite) BOOL isState;
@property(nonatomic,readwrite) BOOL isCustomer;
-(NSMutableDictionary *)getLanguagesDictionary;

@property(nonatomic,weak)id <MyLanguagesDelegate> delegate;

@end
