//
//  MyLanguagesView.m
//  toGo
//
//  Created by Babul Rao on 06/01/16.
//  Copyright © 2016 smartData. All rights reserved.
//

#import "MyLanguagesView.h"
#import "Headers.h"
@implementation MyLanguagesView


-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self) {
        self = [super initWithFrame:frame];
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        [self configureUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)configureUI {
    
    if (!self.isCountry&&!self.isState)
        self.languagesDictionary = [self getLanguagesDictionary];
    
    /*
    NSMutableArray *dictAllKeys=[NSMutableArray arrayWithArray:[self.languagesDictionary allKeys]];
    NSMutableArray *dictAllValues=[NSMutableArray arrayWithArray:[self.languagesDictionary allValues]];
    NSMutableArray *keysAndValues=[NSMutableArray arrayWithArray:[dictAllKeys arrayByAddingObjectsFromArray:dictAllValues]];
    NSMutableArray *test = self.languagesDictionary.copy;
    */
    [self addTableView];
    
}

-(void)addTableView {
    
    int alertViewHeight = self.frame.size.height-30;
    int alertViewWidth = self.frame.size.width-30;
    
    UIView *mainView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    //mainView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:0.8];
    self.tblView = [[UITableView alloc]initWithFrame:CGRectMake(self.center.x-(alertViewWidth/2), 30, alertViewWidth, alertViewHeight-30)];
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    //tableView.backgroundColor = [UIColor redColor];
    [self addSubview:self.tblView];
    
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 10 , 40, 40)];
    //closeBtn.backgroundColor = [UIColor blackColor];
    [closeBtn setBackgroundImage:[UIImage closeLanguagesImage] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    mainView.tag = 999;
    [self addSubview:closeBtn];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isCountry || self.isState) {
        return self.countriesStatesArray.count;
    }
    return [self.languagesDictionary allValues].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.isCountry || self.isState) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"countryState"];
        cell.textLabel.text = [self.countriesStatesArray objectAtIndex:indexPath.row];
        if ([self.selectedCountriesStatesArray containsObject:[self.countriesStatesArray objectAtIndex: indexPath.row]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"languages"];
    cell.textLabel.text = [[self.languagesDictionary allKeys] objectAtIndex:indexPath.row];
    if ([self.selectedLanguagesDict objectForKey:[[self.languagesDictionary allValues] objectAtIndex:indexPath.row]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isCountry || self.isState) {
        [self.selectedCountriesStatesArray removeAllObjects];
        [self.selectedCountriesStatesArray addObject:[self.countriesStatesArray objectAtIndex: indexPath.row]];
    }
    
    if ([self.selectedLanguagesDict objectForKey:[[self.languagesDictionary allValues] objectAtIndex:indexPath.row]]) {
        [self.selectedLanguagesDict removeObjectForKey:[[self.languagesDictionary allValues] objectAtIndex:indexPath.row]];
    }
    else{
        [self.selectedLanguagesDict setObject:[[self.languagesDictionary allValues] objectAtIndex:indexPath.row] forKey:[[self.languagesDictionary allValues] objectAtIndex:indexPath.row]];
    }
    [self.tblView reloadData];
}


-(void)closeButtonPressed{
    
    if (self.isCountry) {
        [self.delegate finishCountrySelection:self.selectedCountriesStatesArray];
    }
    if (self.isState) {
        [self.delegate finishStateSelection:self.selectedCountriesStatesArray];
    }
    [self removeFromSuperview];
    [self.delegate finishLanguagesSelection:self.selectedLanguagesDict];
    //sss
}

-(NSMutableDictionary *)getLanguagesDictionary{
    
    self.languagesDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                @"Afrikaans",@"AF",
                                @"Albanian",@"SQ",
                                @"Arabic",@"AR",
                                @"Armenian",@"HY",
                                @"Basque",@"EU",
                                @"Bengali",@"BN",
                                @"Bulgarian",@"BG",
                                @"Catalan",@"CA",
                                @"Cambodian",@"KM",
                                @"Chinese (Mandarin)",@"ZH",
                                @"Croatian",@"HR",
                                @"Czech",@"CS",
                                @"Danish",@"DA",
                                @"Dutch",@"NL",
                                @"English",@"EN",
                                @"Estonian",@"ET",
                                @"Fiji",@"FJ",
                                @"Finnish",@"FI",
                                @"French",@"FR",
                                @"Georgian",@"KA",
                                @"German",@"DE",
                                @"Greek",@"EL",
                                @"Gujarati",@"GU",
                                @"Hebrew",@"HE",
                                @"Hindi",@"HI",
                                @"Hungarian",@"HU",
                                @"Icelandic",@"IS",
                                @"Indonesian",@"ID",
                                @"Irish",@"GA",
                                @"Italian",@"IT",
                                @"Japanese",@"JA",
                                @"Javanese",@"JW",
                                @"Korean",@"KO",
                                @"Latin",@"LA",
                                @"Latvian",@"LV",
                                @"Lithuanian",@"LT",
                                @"Macedonian",@"MK",
                                @"Malay",@"MS",
                                @"Malayalam",@"ML",
                                @"Maltese",@"MT",
                                @"Maori",@"MI",
                                @"Marathi",@"MR",
                                @"Mongolian",@"MN",
                                @"Nepali",@"NE",
                                @"Norwegian",@"NO",
                                @"Persian",@"FA",
                                @"Polish",@"PL",
                                @"Portuguese",@"PT",
                                @"Punjabi",@"PA",
                                @"Quechua",@"QU",
                                @"Romanian",@"RO",
                                @"Russian",@"RU",
                                @"Samoan",@"SM",
                                @"Serbian",@"SR",
                                @"Slovak",@"SK",
                                @"Slovenian",@"SL",
                                @"Spanish",@"ES",
                                @"Swahili",@"SW",
                                @"Swedish",@"SV",
                                @"Tamil",@"TA",
                                @"Tatar",@"TT",
                                @"Telugu",@"TE",
                                @"Thai",@"TH",
                                @"Tibetan",@"BO",
                                @"Tonga",@"TO",
                                @"Turkish",@"TR",
                                @"Ukrainian",@"UK",
                                @"Urdu",@"UR",
                                @"Uzbek",@"UZ",
                                @"Vietnamese",@"VI",
                                @"Welsh",@"CY",
                                @"Xhosa",@"XH",nil];
    
    return self.languagesDictionary;
}
/*
{
    
    self.languagesDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                @"AF",@"Afrikaans",
                                @"SQ",@"Albanian",
                                @"AR",@"Arabic",
                                @"HY",@"Armenian",
                                @"EU",@"Basque",
                                @"BN",@"Bengali",
                                @"BG",@"Bulgarian",
                                @"CA",@"Catalan",
                                @"KM",@"Cambodian",
                                @"ZH",@"Chinese (Mandarin)",
                                @"HR",@"Croatian",
                                @"CS",@"Czech",
                                @"DA",@"Danish",
                                @"NL",@"Dutch",
                                @"EN",@"English",
                                @"ET",@"Estonian",
                                @"FJ",@"Fiji",
                                @"FI",@"Finnish",
                                @"FR",@"French",
                                @"KA",@"Georgian",
                                @"DE",@"German",
                                @"EL",@"Greek",
                                @"GU",@"Gujarati",
                                @"HE",@"Hebrew",
                                @"HI",@"Hindi",
                                @"HU",@"Hungarian",
                                @"IS",@"Icelandic",
                                @"ID",@"Indonesian",
                                @"GA",@"Irish",
                                @"IT",@"Italian",
                                @"JA",@"Japanese",
                                @"JW",@"Javanese",
                                @"KO",@"Korean",
                                @"LA",@"Latin",
                                @"LV",@"Latvian",
                                @"LT",@"Lithuanian",
                                @"MK",@"Macedonian",
                                @"MS",@"Malay",
                                @"ML",@"Malayalam",
                                @"MT",@"Maltese",
                                @"MI",@"Maori",
                                @"MR",@"Marathi",
                                @"MN",@"Mongolian",
                                @"NE",@"Nepali",
                                @"NO",@"Norwegian",
                                @"FA",@"Persian",
                                @"PL",@"Polish",
                                @"PT",@"Portuguese",
                                @"PA",@"Punjabi",
                                @"QU",@"Quechua",
                                @"RO",@"Romanian",
                                @"RU",@"Russian",
                                @"SM",@"Samoan",
                                @"SR",@"Serbian",
                                @"SK",@"Slovak",
                                @"SL",@"Slovenian",
                                @"ES",@"Spanish",
                                @"SW",@"Swahili",
                                @"SV",@"Swedish",
                                @"TA",@"Tamil",
                                @"TT",@"Tatar",
                                @"TE",@"Telugu",
                                @"TH",@"Thai",
                                @"BO",@"Tibetan",
                                @"TO",@"Tonga",
                                @"TR",@"Turkish",
                                @"UK",@"Ukrainian",
                                @"UR",@"Urdu",
                                @"UZ",@"Uzbek",
                                @"VI",@"Vietnamese",
                                @"CY",@"Welsh",
                                @"XH",@"Xhosa",nil];
    
    return self.languagesDictionary;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
