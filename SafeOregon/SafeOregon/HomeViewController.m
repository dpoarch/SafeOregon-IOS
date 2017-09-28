//
//  HomeViewController.m
//  Sprigeo
//
//  Created by Krunal Doshi on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "FirstViewController.h"
#import "RootViewController.h"
#import "SVWebViewController.h"
#import "SettingViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "TipListViewController.h"

@implementation HomeViewController
{
    NSUserDefaults *userDefault;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [progressView show:YES];
    
    [btnCallHelpLine setTitle:[appDelegate getValueForLabelWithId:@"BTN_CALL_HELPLINE"] forState:UIControlStateNormal];
    [btnMyTip setTitle:[appDelegate getValueForLabelWithId:@"BTN_MY_TIP"] forState:UIControlStateNormal];
    [btnReport setTitle:[appDelegate getValueForLabelWithId:@"BTN_SUBMIT_TIP"] forState:UIControlStateNormal];
    [btnHeroicsProject setTitle:[appDelegate getValueForLabelWithId:@"BTN_RESOURCES"] forState:UIControlStateNormal];
    
    lblWlcome.text = [appDelegate getValueForLabelWithId:@"LBL_WELCOME"];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.32 green:0.75 blue:0.84 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear123:) name:@"responceGet" object:nil];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    
    
 /*   if (![userDefault boolForKey:@"SettingFirstTime"]) {
        
        SettingViewController *settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        
        UINavigationController *settingNavigation = [[UINavigationController alloc] initWithRootViewController:settingViewController] ;
        
        [self.navigationController presentModalViewController:settingNavigation animated:YES];
        
        [userDefault setBool:true forKey:@"SettingFirstTime"];
        
        [settingViewController release];
        [settingNavigation release];
    }
    else if ([[userDefault valueForKey:KEY_LANG] isEqualToString:@"en"] && [[appDelegate getValueForLabelWithId:@"BTN_REPORT"] isEqualToString:@""]){
        
        NSMutableDictionary *dictLang = [[NSUserDefaults standardUserDefaults] valueForKey:@"DictLang"];
        
        if ([dictLang count]== 0) {
            dictLang = [[NSMutableDictionary alloc]init];
            [dictLang setObject:@"en" forKey:@"English"];
            [[NSUserDefaults standardUserDefaults] setValue:dictLang forKey:@"DictLang"];
        }
//        else {
//             [dictLang setObject:@"en" forKey:@"English"];
//        }

//        [self ShowPicker:NO];
//        NSMutableDictionary *dictLang = [[NSMutableDictionary alloc]init];
        

    } */
    
    
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogout setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [btnLogout setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateHighlighted];
    [btnLogout addTarget:self action:@selector(btnSettingClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnLogout setFrame:CGRectMake(0, 0, 31, 31)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:btnLogout];
 //   self.navigationItem.rightBarButtonItem = shareButton;
    
    [shareButton release];
    
    
    NSString *version=@"Version : ";
    
    lblVerson.text=[version stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    NSLog(@"%@",lblVerson.text);
}

-(void)viewWillAppear:(BOOL)animated{
    [progressView hide:YES];
    self.title = [appDelegate getValueForLabelWithId:@"APP_TITLE"];
}

-(void)viewWillAppear123:(NSNotification *)notification {
    
    @try {
        [btnReport setTitle:[appDelegate getValueForLabelWithId:@"BTN_REPORT"] forState:UIControlStateNormal];
        [btnHeroicsProject setTitle:[appDelegate getValueForLabelWithId:@"BTN_HEROES"] forState:UIControlStateNormal];
        
        lblWlcome.text = [appDelegate getValueForLabelWithId:@"LBL_WELCOME"];
        
        [btnHeroicsProject setTitle:[appDelegate getValueForLabelWithId:@"BTN_HEROES"] forState:UIControlStateNormal];
        
    }
    @catch (NSException *exception) {
        ZDebug(@"viewWillAppear123exception==%@",exception);
    }
}

-(void)setDefaultEnglish {
    
    [userDefault setObject:@"en" forKey:KEY_LANG];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
    NSString *strTemp = [NSString stringWithFormat:@"%@/sprigeo_en.json",path];
    NSString *tempString = [NSString stringWithContentsOfFile:strTemp encoding:NSUTF8StringEncoding error:nil];
    
    //SBJsonParser *jsonDecoder = [[SBJsonParser alloc]init];
    //id aryResponse = [jsonDecoder objectWithString:tempString];
    //[appDelegate JSONresponse1:aryResponse];
    
    NSData *jsonData = [tempString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSError *error = nil;
    id objResponse = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
    
    if (!objResponse) {
        NSLog(@"setDefaultEnglish > Error parsing JSON: %@", error);
    }
    else {
        ZDebug(@"setDefaultEnglish > Response: %@", objResponse);
        
        [appDelegate JSONresponse1:objResponse];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)btnSettingClicked
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    
    SettingViewController *settingViewController = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:settingViewController animated:YES];
}

-(IBAction)btnReportClicked:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        RootViewController *viewController = [[RootViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else{
        FirstViewController *viewController = [[FirstViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

-(IBAction)btnHeroicsProject:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    
    SVWebViewController *viewController = [[SVWebViewController alloc] initWithAddress:wordpressURL];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)btnCallHeplLinePress:(id)sender {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AppName
                                                    message:@"Call the Help Line? If this is an emergency situation, call 911."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Call", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == [alertView cancelButtonIndex]){
        
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
            // Check if iOS Device supports phone calls
            CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = [netInfo subscriberCellularProvider];
            NSString *mnc = [carrier mobileNetworkCode];
            // User will get an alert error when they will try to make a phone call in airplane mode.
            if (([mnc length] == 0)) {
                [appDelegate showAlertWithMessage:@"Please this feature not Use." andTitle:AppName];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:8444723367"]];
            }
        } else {
            [appDelegate showAlertWithMessage:@"Please this feature not Use." andTitle:AppName];
        }
    }
}

- (IBAction)btnMyTipPress:(id)sender {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    
    TipListViewController *viewController = [[TipListViewController alloc] initWithNibName:@"TipListViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController autorelease];
}

- (NSString *)adWhirlApplicationKey {
    
    return MY_AD_WHIRL_APPLICATION_KEY;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)dealloc {
    [btnCallHelpLine release];
    [btnMyTip release];
    [lblVerson release];
    [super dealloc];
}

@end
