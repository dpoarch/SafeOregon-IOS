//
//  AppDelegate.m
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ZipArchive.h"
#import "SettingViewController.h"
#import "HomeViewController.h"
#import "ThirdViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize strApplicationName;
@synthesize strStatePickerTitle;
@synthesize  strLanguage,strTimePickerTitle,dictLabel,strIncedentPickerTitle;

- (void)dealloc {
    [_window release];
    [_navigationController release];
    [_splitViewController release];
    [super dealloc];
}

- (NSString *) pathForFile:(NSString *) fileName {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:fileName];
}

-(BOOL)isInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable){
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(3);
    
    strApplicationName = AppName;
    aryStates = [[NSMutableArray alloc] init];
    aryTime = [[NSMutableArray alloc] init];
    arySchoolList = [[NSMutableArray alloc] init];
   // arySituation = [[NSMutableArray alloc] init];
   // aryAdult = [[NSMutableArray alloc] init];
    aryIncidents = [[NSMutableArray alloc] init];
    aryReporterType = [[NSMutableArray alloc] init];
    dictWholeData = [[NSMutableDictionary alloc] init];
    
    NSString*plistPath = [[NSBundle mainBundle] pathForResource:@"Time" ofType:@"plist"];
    NSDictionary *theDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    aryTime = [[NSMutableArray alloc] initWithArray:[theDict objectForKey:@"Time"]];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DownloadFilesFirst"];
    }
    
    fileManager = [NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:[self pathForFile:@"sprigeo_en.json"]]){
        NSString *fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sprigeo_en.json"];
        [fileManager copyItemAtPath:fromPath toPath:[self pathForFile:@"sprigeo_en.json"] error:nil];
        [self sendRequest];
    }
    else {
        NSUserDefaults *isAnyLangSelct = [NSUserDefaults standardUserDefaults];
        //if ([isAnyLangSelct valueForKey:KEY_ISSELECTED]) {
            [self sendRequest];
       // }
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    HomeViewController *viewController = [[HomeViewController alloc] init];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    
//    ThirdViewController *viewController = [[ThirdViewController alloc] init];
//    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    progressView = [[MBProgressHUD alloc] initWithWindow:self.window];
   // [self.window addSubview:progressView];
   // progressView.dimBackground = YES;
    
  //  [self.window bringSubviewToFront:progressView];
    
    
    
    // Call takeOff (which creates the UAirship singleton)
//    UAConfig *config = [UAConfig defaultConfig];
//    config.detectProvisioningMode = true;
//    [UAirship takeOff:config];
    //[UAirship takeOff];
    
    // User notifications will not be enabled until userPushNotificationsEnabled is
    // set YES on UAPush. Once enabled, the setting will be persisted and the user
    // will be prompted to allow notifications. Normally, you should wait for a more
    // appropriate time to enable push to increase the likelihood that the user will
    // accept notifications.
    //[UAirship push].userPushNotificationsEnabled = YES;
    
//    NSDictionary *pushNotificationPayload = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(pushNotificationPayload) {
//        [self application:application didReceiveRemoteNotification:pushNotificationPayload];
//    }
//    
//    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken==%@",deviceToken);
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"++++++++++++++++++++didReceiveRemoteNotification+++++++++++++++++++++++++++++");
#if !TARGET_IPHONE_SIMULATOR
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DownloadFilesFirst"];
    
    SettingViewController *settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"SettingFirstTime"];
    
    [settingViewController release];
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
#endif
}

-(void)sendRequest {
    
    @try {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
        fileManager = [[NSFileManager alloc]init];
        NSUserDefaults *selectedLang = [NSUserDefaults standardUserDefaults];
        
        if ([selectedLang valueForKey:KEY_LANG] && [[selectedLang valueForKey:KEY_LANG] length] > 0)
        {
            if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"DownloadFilesFirst"]) {
                [self zipFileRequest];
            }
            
            NSString *strTemp = [NSString stringWithFormat:@"%@/sprigeo_%@.json",path,[selectedLang valueForKey:KEY_LANG]];
            
            if([fileManager fileExistsAtPath:strTemp]) {
                
                NSString *tempString = [NSString stringWithContentsOfFile:strTemp encoding:NSUTF8StringEncoding error:nil];
                //SBJsonParser *jsonDecoder = [[SBJsonParser alloc]init];
                //id aryResponse = [jsonDecoder objectWithString:tempString];
                
                NSData *jsonData = [tempString dataUsingEncoding:NSUTF8StringEncoding];
                
                NSError *error = nil;
                id objResponse = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
                
                if (!objResponse) {
                    NSLog(@"Error parsing JSON: %@", error);
                }
                else {
                    ZDebug(@"JSONresponse > Response: %@", objResponse);
                    
                    [self JSONresponse1:objResponse];
                }
            }
            else {
                [self SelectEnglishLan];
            }
        }
        else
        {
            [self SelectEnglishLan];
        }
    }
    @catch (NSException *exception) {
        ZDebug(@"sendRequest  exception==%@",exception);
    }
}

-(void)zipFileRequest
{
    @try {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DownloadFilesFirst"];
        
        NSUserDefaults *isAnyLangSelct = [NSUserDefaults standardUserDefaults];
        [isAnyLangSelct setBool:true forKey:KEY_ISSELECTED];
        
        NSString *stringURL = getZipFileLanguagesURL;
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        //Save the data
        NSString *dataPath = [path stringByAppendingPathComponent:@"languages.zip"];
        dataPath = [dataPath stringByStandardizingPath];
        [urlData writeToFile:dataPath atomically:YES];
        
        NSString *filepath =[NSString stringWithFormat:@"%@/languages.zip",path];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
        
        if (!fileExists) {
            
            if ([appDelegate getValueForLabelWithId:@"MSG_DOWNLOADING_ERR"] && [[appDelegate getValueForLabelWithId:@"MSG_DOWNLOADING_ERR"] length] > 0) {
                
                [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"MSG_DOWNLOADING_ERR"] andTitle:AppName];
            }
            else {
                [appDelegate showAlertWithMessage:@"Error occurred while updating , please try again." andTitle:AppName];
            }
        }
        
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        [zipArchive UnzipOpenFile:filepath Password:@""];
        [zipArchive UnzipFileTo:path overWrite:YES];
        [zipArchive UnzipCloseFile];
        [zipArchive release];
    }
    @catch (NSException *exception) {
        NSLog(@"zipFileRequest  exception==%@",exception);
    }
}

-(void)SelectEnglishLan{
    
//    if ([appDelegate getValueForLabelWithId:@"MSG_ERROR_LANG"] && [[appDelegate getValueForLabelWithId:@"MSG_ERROR_LANG"] length] > 0)
//        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"MSG_ERROR_LANG"] andTitle:AppName];
//    else
//        [appDelegate showAlertWithMessage:@"Selected language not available." andTitle:AppName];
    
    NSString *strTemp = [NSString stringWithFormat:@"%@/sprigeo_en.json",path];
    
    if([fileManager fileExistsAtPath:strTemp]){
        
        NSString *tempString = [NSString stringWithContentsOfFile:strTemp encoding:NSUTF8StringEncoding error:nil];

//        SBJsonParser *jsonDecoder = [[SBJsonParser alloc]init];
//        id aryResponse = [jsonDecoder objectWithString:tempString];
//        [self JSONresponse1:aryResponse];
        
        NSData *jsonData = [tempString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        id objResponse = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
        
        if (!objResponse) {
            NSLog(@"Error parsing JSON: %@", error);
        }
        else {
            ZDebug(@"JSONresponse > Response: %@", objResponse);
            
            [self JSONresponse1:objResponse];
        }
    }
    else {
      //  [appDelegate showAlertWithMessage:@"Languages are not availabel! please try again later." andTitle:AppName];
    }
}

-(void)JSONresponse1:(NSArray *)aryResponse
{
    @try {
        
        dictLabel = [[NSMutableDictionary alloc]initWithDictionary:[aryResponse valueForKey:@"Labels"]];
        [dictLabel retain];
        
        appDelegate.strStatePickerTitle = [dictLabel valueForKey:@"LBL_SEL_STATE"];
        appDelegate.strTimePickerTitle = [dictLabel valueForKey:@"LBL_SEL_TIME"];
        appDelegate.strIncedentPickerTitle = [dictLabel valueForKey:@"MSG_SELECT_INCIDENT"];
        
        NSMutableDictionary *dictState = [[NSMutableDictionary alloc]initWithDictionary:[aryResponse valueForKey:@"CMB_STATE"]];
        
        [self getAllState:dictState];
        
        NSMutableDictionary *dictIncident = [[NSMutableDictionary alloc]initWithDictionary:[aryResponse valueForKey:@"CMB_INCIDENT"]];
        [self getAllIncident:dictIncident];
        
        NSMutableDictionary *dictReporter = [[NSMutableDictionary alloc]initWithDictionary:[aryResponse valueForKey:@"CMB_REPORTER"]];
        [self getAllReporter:dictReporter];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"responceGet" object:nil userInfo:nil];
        
    }
    @catch (NSException *exception) {
        ZDebug(@"JSONresponse1  exception==%@",exception);
    }
}

-(NSString *)getValueForLabelWithId:(NSString *) labelId
{
    if ([dictLabel valueForKey:labelId])
        return [dictLabel valueForKey:labelId];
    
    return @"";
}

-(void)getAllState:(NSMutableDictionary *)dictState
{
    @try {
        if ([aryStates count]>0) {
            [aryStates removeAllObjects];
        }
        
        NSArray *arrKeys =[dictState allKeys];
        NSMutableArray *arrValues = [[NSMutableArray alloc] init];
        
        arrKeys = [arrKeys sortedArrayUsingSelector:@selector(compare:)];
        
        for (int i=0;i < [dictState count]; i++) {
            [arrValues addObject:[dictState valueForKey:[arrKeys objectAtIndex:i]]];
        }
        
        for(int i=0;i<[arrKeys count];i++)
        {
            NSMutableDictionary *dict1 =[[NSMutableDictionary alloc]init];
            
            [dict1 setObject:[arrValues objectAtIndex:i] forKey:@"ID"];
            [dict1 setObject:[arrKeys objectAtIndex:i] forKey:@"State"];
            [aryStates addObject:dict1];
            [dict1 release];
        }
    }
    @catch (NSException *exception) {
        ZDebug(@"getAllState  exception==%@",exception);
    }
}

-(void)getAllTime:(NSMutableDictionary *)dictTime
{
    @try {
        
        NSArray *arrKeys =[dictTime allKeys];
        NSArray *arrValues =[dictTime allValues];
        
        for(int i=0;i<[arrKeys count];i++)
        {
            NSMutableDictionary *dict1 =[[NSMutableDictionary alloc]init];
            [dict1 setObject:[arrValues objectAtIndex:i] forKey:@"Value"];
            [dict1 setObject:[arrKeys objectAtIndex:i] forKey:@"Time"];
            [aryTime addObject:dict1];
            [dict1 release];
        }
    }
    @catch (NSException *exception) {
        ZDebug(@"getAllTime  exception==%@",exception);
    }
}

-(void)getAllIncident:(NSMutableDictionary *)dictIncedent

{
    @try {
        if ([aryIncidents count]>0) {
            [aryIncidents removeAllObjects];
        }
        NSArray *arrKeys =[dictIncedent allKeys];
        NSArray *arrValues =[dictIncedent allValues];
        
        for(int i=0;i<[arrKeys count];i++)
        {
            NSMutableDictionary *dict1 =[[NSMutableDictionary alloc]init];
            
            [dict1 setObject:[arrValues objectAtIndex:i] forKey:@"Value"];
            [dict1 setObject:[arrKeys objectAtIndex:i] forKey:@"Incedent"];
            [aryIncidents addObject:dict1];
            [dict1 release];
        }
    }
    @catch (NSException *exception) {
        ZDebug(@"getAllIncident  exception==%@",exception);
    }
}

-(void)getAllReporter:(NSMutableDictionary *)dictReporter
{
    @try {
        
        if ([aryReporterType count]>0) {
            [aryReporterType removeAllObjects];
        }
        
        NSArray *arrKeys =[dictReporter allKeys];
        NSArray *arrValues =[dictReporter allValues];
        
        for(int i=0;i<[arrKeys count];i++)
        {
            NSMutableDictionary *dict1 =[[NSMutableDictionary alloc]init];
            
            [dict1 setObject:[arrValues objectAtIndex:i] forKey:@"Value"];
            [dict1 setObject:[arrKeys objectAtIndex:i] forKey:@"Reporter"];
            [aryReporterType addObject:dict1];
            [dict1 release];
        }
    }
    @catch (NSException *exception) {
        ZDebug(@"getAllReporter exception==%@",exception);
    }
}

-(void) showAlertWithMessage:(NSString *)message andTitle:(NSString *) title {
    
    NSString *strBtnOk = @"";
    
    if([[appDelegate getValueForLabelWithId:@"BTN_OK"] length] == 0) {
        strBtnOk = @"Ok";
    }else {
        strBtnOk = [appDelegate getValueForLabelWithId:@"BTN_OK"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:strBtnOk otherButtonTitles:nil];
    [alert show];
}

+(CGSize)getTextHeight:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize width:(CGFloat)width {
    NSString *cellText = text;
    UIFont *cellFont = [UIFont fontWithName:fontName size:fontSize];
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize;
}

-(UIButton *)setNavigationButton:(NSString *)strTitle{
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *imgBackground;
    if([strTitle isEqualToString:@"Back"])
        imgBackground = [UIImage imageNamed:@"Back.png"];
    else
        imgBackground = [UIImage imageNamed:@"Next.png"];
    [btnNext setBackgroundImage:imgBackground forState:UIControlStateNormal];
    [btnNext setBackgroundImage:imgBackground forState:UIControlStateHighlighted];
    
    [btnNext setTitle:strTitle forState:UIControlStateNormal];
    [btnNext setFrame:CGRectMake(0, 0, 40, 31)];
    return btnNext;
}

-(CGFloat) webViewHeight:(NSString *)str withFont:(UIFont*)font webViewWidth:(float)width {
    CGFloat height;
    height = 3;
    CGSize maximumLabelSize	= CGSizeMake(width-20, MAXFLOAT);
    CGSize expectedLabelSize;
    expectedLabelSize = [str sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeCharacterWrap];
    height += expectedLabelSize.height;
    return height;
}

@end
