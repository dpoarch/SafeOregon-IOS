//
//  Global.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication]delegate])
#define AppName [((AppDelegate *)[[UIApplication sharedApplication]delegate]) getValueForLabelWithId:@"APP_TITLE"]
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define ISiOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))

#define DEVICE_IOS7 (ISiOS7 ? 1 : 0) //    1 YES _____ 0 NO

#define DEVICE_HEIGHT ((int)[UIScreen mainScreen].bounds.size.height)
#define DEVICE_WIDTH    320

#define APP_BACKGROUD_COLOR     [UIColor lightGrayColor]

#define FORM1_BACKGROUD_COLOR           [UIColor colorWithRed:0.32 green:0.75 blue:0.84 alpha:1.0]
#define FORM2_BACKGROUD_COLOR           [UIColor colorWithRed:0.50 green:0.73 blue:0.29 alpha:1.0]
#define FORM3_BACKGROUD_COLOR           [UIColor colorWithRed:0.50 green:0.73 blue:0.29 alpha:1.0]
#define FORM4_BACKGROUD_COLOR           [UIColor colorWithRed:0.0 green:0.65 blue:0.32 alpha:1.0]
#define THANKS_BACKGROUD_COLOR          [UIColor colorWithRed:0.0 green:0.65 blue:0.32 alpha:1.0]

///*
//#define NOTIFICATION_BASEURL    @"etechmavens.com/etechphp3/sprigeo"
#define baseurl @"http://safeoregon.com/"
#define getLanguagesURL     @"http://sprigeo.com/admin/manage.php?p=download&a=lang"
#define getZipFileLanguagesURL   @"http://sprigeo.com/admin/manage.php?p=download&a=file"
#define submitIncidentURL @"http://safeoregon.com/submitIncident.asp"
#define schoolLookupURL @"http://safeoregon.com/schoolLookup.asp"
#define getIncidentLocationListURL @"http://safeoregon.com/incidentLocations.asp"
#define wordpressURL @"https://www.google.co.in/webhp?hl=en"
#define AppURL @"http://safeoregon.com/"
//*/

/*
#define baseurl                     @"http://sprigeo.etechmavens.com"
#define getLanguagesURL             @"http://sprigeo.etechmavens.com/manage.php?p=download&a=lang"
#define getZipFileLanguagesURL      @"http://sprigeo.etechmavens.com/manage.php?p=download&a=file"
#define submitIncidentURL           @"http://report.sprigeo.com/submitIncident"
#define schoolLookupURL             @"http://report.sprigeo.com/schoolLookup"
#define getIncidentLocationListURL  @"http://report.sprigeo.com/incidentLocations"
#define wordpressURL                @"http://sprigeoheroes.wordpress.com/"
#define AppURL                      @"http://report.sprigeo.com/"
*/

#define BackButtonTitle   [appDelegate getValueForLabelWithId:@"BTN_BACK"]
#define NextButtonTitle   [appDelegate getValueForLabelWithId:@"BTN_NEXT"]

#define urltoken @"qIAGAreFfSMviInoC55Y"

//#define MY_AD_WHIRL_APPLICATION_KEY @"79575e922fdf4cd9a11711ea4dde08e0"
#define MY_AD_WHIRL_APPLICATION_KEY @"3142e1045215472e8a838b87fd8ecc70"
#define ADMOB_IDENTIFIER @"ca-app-pub-2750664858150981/5715370551"
#define KEY_LANG   @"Language"

#define KEY_ISSELECTED  @"isSelectedLang"
NSMutableArray *aryStates;
//NSMutableArray *aryIncidents;
NSMutableArray *aryIncidents;

NSMutableArray *aryTime;
NSMutableArray *aryReporterType;
NSMutableArray *arySchoolList;
NSMutableArray *aryLabelTitle;

NSMutableDictionary *dictWholeData;

bool blnIsSubmit;

MBProgressHUD *progressView;
bool showHUD;
bool blnIsRequesting;
int doesnothidecalendar;

#define eTechLog(fmt, args...)  NSLog(@"eTechLog: [%d] %@\n", __LINE__, [NSString stringWithFormat:fmt, ##args])

#if DEBUG
#include <libgen.h>
#define ZDebug(fmt, args...)  NSLog(@"[%s:%d] %@\n", basename(__FILE__), __LINE__, [NSString stringWithFormat:fmt, ##args])
#else
#define ZDebug(fmt, args...)  ((void)0)
#endif