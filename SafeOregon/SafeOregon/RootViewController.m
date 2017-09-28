//
//  RootViewController.m
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ListViewController.h"
#import "ASIFormDataRequest.h"

@implementation RootViewController
@synthesize calendarDatePicker;

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
    self.title = appDelegate.strApplicationName;
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    
    if(DEVICE_IOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [scrollView setFrame:CGRectMake(0,50,768,DEVICE_HEIGHT-50)];
        [scrollView setContentSize:CGSizeMake(768,DEVICE_HEIGHT)];
    }
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"appbackground.png"]]];
    
    [[txtDescription layer] setCornerRadius:5.0];
    [[txtDescription layer] setBorderColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.0].CGColor];
    [[txtDescription layer] setBorderWidth:2.0];
    
    tbView = [[UITableView alloc] init];
    tbView.dataSource = self;
    tbView.delegate = self;
    
    [[tbView layer] setCornerRadius:5.0];
    [[tbView layer] setBorderColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.0].CGColor];
    [[tbView layer] setBorderWidth:2.0];
    
    responseObj = [[etmResponse alloc] init];
    responseObj._delegate = self;
    doesnothidecalendar = -1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [btnSubmit setTitle:[appDelegate getValueForLabelWithId:@"BTN_SUBMIT"] forState:UIControlStateNormal];
    
    lblReporterType.text = [appDelegate getValueForLabelWithId:@"LBL_WHO"];
    lblName.text = [appDelegate getValueForLabelWithId:@"LBL_NAME"];
    lblPhoneNumber.text = [appDelegate getValueForLabelWithId:@"LBL_PHONE"];
    
    lblCulprit.text = [appDelegate getValueForLabelWithId:@"LBL_BULLY"];
    lblVictim.text = [appDelegate getValueForLabelWithId:@"LBL_BULLY_PERSON"];
    lblDescription.text = [appDelegate getValueForLabelWithId:@"LBL_WHAT_HAPPEN"];
    
    lblState.text = [appDelegate getValueForLabelWithId:@"LBL_LIVE"];
    lblSchool.text = [appDelegate getValueForLabelWithId:@"LBL_SEL_SCHOOL"];
    lblIncident.text = [appDelegate getValueForLabelWithId:@"LBL_WHERE_INCIDENT"];
    lblDate.text = [appDelegate  getValueForLabelWithId:@"LBL_WHEN_HAPPEN"];
    lblTime.text = [appDelegate getValueForLabelWithId:@"LBL_TIME"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    txtDate.text = [newPeriod.startDate dateStringWithFormat:@"MM/dd/yyyy"];
    if(doesnothidecalendar == 0) {
        doesnothidecalendar = 1;
    }
    if (doesnothidecalendar == 1) {
        [self.calendarDatePicker dismissCalendarAnimated:YES];
        doesnothidecalendar = -1;
    }
}

-(IBAction)showIncidents:(id)sender
{
    @try {
        [self.view endEditing:YES];
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            txtIncident.text = [[aryIncidents objectAtIndex:selectedIndex]valueForKey:@"Incedent"];
            strIncedentID=[[aryIncidents objectAtIndex:selectedIndex]valueForKey:@"Value"];
            [strIncedentID retain];
        };
        
        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
            NSLog(@"State Picker Canceled");
        };
        
        NSMutableArray *tempIncidentArray = [[NSMutableArray alloc] init];
        NSInteger selectedIndex= 0;
        
        for(int i=0;i<[aryIncidents count];i++)
        {
            [tempIncidentArray addObject:[[aryIncidents objectAtIndex:i] valueForKey:@"Incedent"]];
            
            if (strIncedentID && [strIncedentID length] > 0) {
                
                if ([strIncedentID isEqualToString:[[aryIncidents objectAtIndex:i] valueForKey:@"Value"]]) {
                    selectedIndex = i;
                }
            }
        }
        
        [ActionSheetStringPicker showPickerWithTitle:appDelegate.strIncedentPickerTitle rows:(NSArray *)tempIncidentArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
        [tempIncidentArray release];
    }
    @catch (NSException *exception) {
        ZDebug(@"showIncidents  exception==%@",exception);
    }
}

-(IBAction)showStates:(id)sender
{
    @try {
        [self.view endEditing:YES];
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            txtState.text = [[aryStates objectAtIndex:selectedIndex] valueForKey:@"State"];
            strStateID = [[aryStates objectAtIndex:selectedIndex] valueForKey:@"ID"];
            
            [strStateID retain];
            txtSchoolName.text = @"";
        };
        
        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
            NSLog(@"State Picker Canceled");
        };
        
        NSMutableArray *tempStateArray = [[NSMutableArray alloc] init];
        NSInteger selectedIndex= 0;
        
        for(int i=0;i<[aryStates count];i++)
        {
            [tempStateArray addObject:[[aryStates objectAtIndex:i] valueForKey:@"State"]];
            
            if (strStateID && [strStateID length] > 0) {
                if ([strStateID isEqualToString:[[aryStates objectAtIndex:i] valueForKey:@"ID"]]) {
                    selectedIndex = i;
                }
            }
        }
        
        [ActionSheetStringPicker showPickerWithTitle:appDelegate.strStatePickerTitle rows:(NSArray *)tempStateArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
        [tempStateArray release];
    }
    @catch (NSException *exception) {
        ZDebug(@"showStates  exception==%@",exception);
    }
}

-(IBAction)showReporterType:(id)sender
{
    [self.view endEditing:YES];
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        txtReporterType.text = [[aryReporterType objectAtIndex:selectedIndex]valueForKey:@"Reporter"];
        //[dictWholeData setValue:[[aryIncidents objectAtIndex:selectedIndex]valueForKey:@"ID"] forKey:@"reportertype"];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"ReporterType Picker Canceled");
    };
    
    NSMutableArray *tempReporterArray = [[NSMutableArray alloc] init];
    NSInteger selectedIndex= 0;
    
    for(int i=0;i<[aryReporterType count];i++)
    {
        [tempReporterArray addObject:[[aryReporterType objectAtIndex:i] valueForKey:@"Reporter"]];
        
        if (txtReporterType.text && [txtReporterType.text length] > 0) {
            if ([txtReporterType.text isEqualToString:[[aryReporterType objectAtIndex:i] valueForKey:@"Reporter"]]) {
                selectedIndex = i;
            }
        }
    }
    
    [ActionSheetStringPicker showPickerWithTitle:[appDelegate getValueForLabelWithId:@"LBL_TYPE"] rows:(NSArray *)tempReporterArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
    [tempReporterArray release];
}

-(IBAction)showSchoolList:(id)sender
{
    [self.view endEditing:YES];
    
    ListViewController *viewController = [[ListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)showCalendar:(id)sender
{
    [self.view endEditing:YES];
    
    ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(doneActionDatePicker:) origin:sender];
    actionSheetPicker.maximumDate = [NSDate date];
    [actionSheetPicker showActionSheetPicker];
    
    //    self.calendarDatePicker = [[PMCalendarController alloc] initWithThemeName:@"default"];
    //    calendarDatePicker.delegate = self;
    //    calendarDatePicker.mondayFirstDayOfWeek = NO;
    //    [calendarDatePicker presentCalendarFromView:sender
    //                       permittedArrowDirections:PMCalendarArrowDirectionAny
    //                                       animated:YES];
    //
    //    self.calendarDatePicker.allowedPeriod = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingYears:-50]
    //                                                                  endDate:[[NSDate date]dateByAddingDays:0]];
    //    if(doesnothidecalendar == -1)
    //        doesnothidecalendar = 0;
}

- (void)doneActionDatePicker:(id)sender
{
    if (sender) {
        
        //        txtDate.text = [newPeriod.startDate dateStringWithFormat:@"MM/dd/yyyy"];
        //        if(doesnothidecalendar == 0) {
        //            doesnothidecalendar = 1;
        //        }
        //        if (doesnothidecalendar == 1) {
        //            [self.calendarDatePicker dismissCalendarAnimated:YES];
        //            doesnothidecalendar = -1;
        //        }
        
        
        NSDate * date=(NSDate *)sender;
        NSDateFormatter * formate=[[NSDateFormatter alloc]init];
        [formate setDateFormat:@"MM/dd/yyyy"];
        
        if(date && formate)
        {
            txtDate.text=[formate stringFromDate:date];
        }
    }
}

-(void)dateSelected:(NSDate*)selectedDate
{
    txtDate.text = [selectedDate dateStringWithFormat:@"MM/dd/yyyy"];
}

-(IBAction)showTime:(id)sender
{
    @try {
        [self.view endEditing:YES];
        
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            txtTime.text = [[aryTime objectAtIndex:selectedIndex] valueForKey:@"Time"];
            strTimeValue = [[aryTime objectAtIndex:selectedIndex] valueForKey:@"Value"];
            [strTimeValue retain];
        };
        
        ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
            NSLog(@"Time Picker Canceled");
        };
        
        NSMutableArray *tempTimeArray = [[NSMutableArray alloc] init];
        NSInteger selectedIndex= 0;
        
        for(int i=0;i<[aryTime count];i++)
        {
            [tempTimeArray addObject:[[aryTime objectAtIndex:i] valueForKey:@"Time"]];
            
            if (strTimeValue && [strTimeValue length] > 0) {
                
                if ([strTimeValue isEqualToString:[[aryTime objectAtIndex:i] valueForKey:@"Value"]]) {
                    selectedIndex = i;
                }
            }
        }
        
        [ActionSheetStringPicker showPickerWithTitle:appDelegate.strTimePickerTitle rows:(NSArray *)tempTimeArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
    }
    
    @catch (NSException *exception) {
        ZDebug(@"exception==%@",exception);
    }
}

- (BOOL)validate
{
    [self.view endEditing:YES];
    
    // Need Validation Here
    if(txtSchoolName.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_SCHOOL"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else if(txtIncident.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_INCIDENT"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
    if(txtDescription.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_DESC"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
//    if(txtReporterType.text.length <= 0) {
//        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_REPORTER"] andTitle:appDelegate.strApplicationName];
//        return NO;
//    }
    else {
        [dictWholeData setValue:strStateID forKey:@"state"];
        [dictWholeData setValue:txtSchoolName.text forKey:@"schoolname"];
        [dictWholeData setValue:strSchoolID forKey:@"schoolid"];
        [dictWholeData setValue:txtDate.text forKey:@"date"];
        [dictWholeData setValue:txtIncident.text forKey:@"incident"];
        [dictWholeData setValue:strTimeValue forKey:@"time"];
        [dictWholeData setValue:txtVictim.text forKey:@"victim"];
        [dictWholeData setValue:txtCulprit.text forKey:@"culprit"];
        [dictWholeData setValue:txtDescription.text forKey:@"description"];
        [dictWholeData setValue:txtName.text forKey:@"name"];
        [dictWholeData setValue:txtPhoneNumber.text forKey:@"phonenumber"];
        [dictWholeData setValue:txtReporterType.text forKey:@"reportertype"];
        return YES;
    }
    
    /*
    NSMutableArray *aryValidInput = [[NSMutableArray alloc] init];
    ValidationRequestVO *valReq;
    
    
    valReq = [[ValidationRequestVO alloc] initWithValidationType:kNullValidator
                                                    srcParamName:@"School Name" srcParamValue:txtSchoolName.text validationFailMsg:[appDelegate getValueForLabelWithId:@"ALT_SCHOOL"]];
    
    [aryValidInput addObject:valReq];
    
    valReq = [[ValidationRequestVO alloc] initWithValidationType:kNullValidator
                                                    srcParamName:@"Incident" srcParamValue:txtIncident.text validationFailMsg:[appDelegate getValueForLabelWithId:@"ALT_INCIDENT"]];
    
    [aryValidInput addObject:valReq];
    
    
    
    valReq = [[ValidationRequestVO alloc] initWithValidationType:kNullValidator
                                                    srcParamName:@"Description" srcParamValue:txtDescription.text validationFailMsg:[appDelegate getValueForLabelWithId:@"ALT_DESC"]];
    
    [aryValidInput addObject:valReq];
    
    
    ValidationResponseVO *responseVO = [ValidationUtility validateFields:aryValidInput];
    if(responseVO.IsValidationSuccessful)
    {
        [dictWholeData setValue:strStateID forKey:@"state"];
        [dictWholeData setValue:txtSchoolName.text forKey:@"schoolname"];
        [dictWholeData setValue:strSchoolID forKey:@"schoolid"];
        [dictWholeData setValue:txtDate.text forKey:@"date"];
        [dictWholeData setValue:txtIncident.text forKey:@"incident"];
        [dictWholeData setValue:strTimeValue forKey:@"time"];
        [dictWholeData setValue:txtVictim.text forKey:@"victim"];
        [dictWholeData setValue:txtCulprit.text forKey:@"culprit"];
        [dictWholeData setValue:txtDescription.text forKey:@"description"];
        [dictWholeData setValue:txtName.text forKey:@"name"];
        [dictWholeData setValue:txtPhoneNumber.text forKey:@"phonenumber"];
        [dictWholeData setValue:txtReporterType.text forKey:@"reportertype"];
        
        return YES;
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"%@",responseVO.CustomValidationMsg];
        [appDelegate showAlertWithMessage:msg andTitle:appDelegate.strApplicationName];
        return NO;
    }
    */
}

-(void)sendRequest:(NSString*)strSchoolName
{
    @try {
        
        NSUserDefaults *selectedLang = [NSUserDefaults standardUserDefaults];
        
        NSString *strURL = [NSString stringWithFormat:@"%@?stateid=%@&q=%@&lan=%@", schoolLookupURL,strStateID,strSchoolName,[selectedLang valueForKey:KEY_LANG]];
        
        NSString *strRequestData = [NSString stringWithFormat:@"token=%@",urltoken];
        [responseObj sendRequest:strURL withPostData:strRequestData];
    }
    
    @catch (NSException *exception) {
        ZDebug(@"sendRequest  exception == %@",exception);
    }
}

-(void)JSONresponse:(NSArray *)aryResponse
{
    if([arySchoolList count])
    {
        [arySchoolList removeAllObjects];
        arySchoolList = nil;
        [arySchoolList release];
        IsTableViewAdded = FALSE;
    }
    
    arySchoolList = [[NSMutableArray alloc] initWithArray:aryResponse];
    
    //2411
    if ([arySchoolList count]==0) {
        [arySchoolList removeAllObjects];
        arySchoolList = nil;
        [arySchoolList release];
        [tbView removeFromSuperview];
    }
    else {
        if(!IsTableViewAdded && txtSchoolName.text.length > 1)
        {
            if (DEVICE_IOS7) {
                tbView.frame = CGRectMake(394, 165, 304, 140);
            }
            else
            {
                tbView.frame = CGRectMake(394, 110, 304, 140);
            }
            
            [self.view addSubview:tbView];
            IsTableViewAdded = YES;
            [scrollView setScrollEnabled:NO];
        }
        [tbView reloadData];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arySchoolList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0f]];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ in %@",[[arySchoolList objectAtIndex:indexPath.row] valueForKey:@"school"],[[arySchoolList objectAtIndex:indexPath.row] valueForKey:@"city"]];
    CGRect labelsize = cell.textLabel.frame;
    CGSize textSize = [AppDelegate getTextHeight:cell.textLabel.text fontName:@"Helvetica" fontSize:17.0f width:281];
    labelsize.size.height = textSize.height;
    cell.textLabel.frame = labelsize;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strCellText = [NSString stringWithFormat:@"%@ in %@",[[arySchoolList objectAtIndex:indexPath.row] valueForKey:@"school"],[[arySchoolList objectAtIndex:indexPath.row] valueForKey:@"city"]];
    
    CGSize size = [AppDelegate getTextHeight:strCellText fontName:@"Helvetica" fontSize:17.0f width:281];
    if(size.height < 44)
        return 44;
    else
        return size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtSchoolName.text = [[arySchoolList objectAtIndex:indexPath.row] valueForKey:@"school"];
    strSchoolID = [[arySchoolList objectAtIndex:indexPath.row] valueForKey:@"id"];
    [strSchoolID retain];
    [tbView removeFromSuperview];
    IsTableViewAdded = NO;
    [scrollView setScrollEnabled:YES];
    [txtSchoolName resignFirstResponder];
}

-(IBAction)submitClicked:(id)sender
{
    [self.view endEditing:YES];
    
    BOOL validate = [self validate];
    if(validate)
    {
        
        [progressView show:YES];
        NSURL *url = [NSURL URLWithString:submitIncidentURL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request setDidFinishSelector:@selector(requestFetchCompleted:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request addPostValue:urltoken forKey:@"token"];
        [request addPostValue:[dictWholeData objectForKey:@"state"] forKey:@"stateId"];
        [request addPostValue:[dictWholeData objectForKey:@"schoolname"] forKey:@"school"];
        [request addPostValue:[dictWholeData objectForKey:@"schoolid"] forKey:@"schoolId"];
        [request addPostValue:[dictWholeData objectForKey:@"incident"] forKey:@"incidentLocation"];
        [request addPostValue:[dictWholeData objectForKey:@"description"] forKey:@"incidentDescription"];
        [request addPostValue:[dictWholeData objectForKey:@"date"] forKey:@"incidentDate"];
        
        if ([dictWholeData objectForKey:@"time"] && [[dictWholeData objectForKey:@"time"] length] > 0)
            [request addPostValue:[dictWholeData objectForKey:@"time"] forKey:@"incidentTime"];
        else
            [request addPostValue:@"0001" forKey:@"incidentTime"];
        
        [request addPostValue:[dictWholeData objectForKey:@"culprit"] forKey:@"bullyName"];
        [request addPostValue:[dictWholeData objectForKey:@"victim"] forKey:@"victimName"];
        [request addPostValue:[dictWholeData objectForKey:@"reportertype"] forKey:@"postedBy"];
        [request addPostValue:[dictWholeData objectForKey:@"name"] forKey:@"postedByName"];
        [request addPostValue:[dictWholeData objectForKey:@"phonenumber"] forKey:@"postedByContactInfo"];
        
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
        
        [request setCompletionBlock:^{
            
            [progressView hide:YES];
            
//            JSONDecoder *jsonDecoder = [[JSONDecoder alloc]initWithParseOptions:JKParseOptionNone];
//            NSString* myString= request.responseString;
//            NSData* data=[myString dataUsingEncoding: [NSString defaultCStringEncoding] ];
//            NSArray *aryResponse = [jsonDecoder objectWithData:data];
            
            
            NSData* jsonData = [request.responseString dataUsingEncoding: [NSString defaultCStringEncoding] ];
            
            NSError *error = nil;
            NSArray *objResponse = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
            
            if (!objResponse) {
                NSLog(@"Error parsing JSON: %@", error);
            }
            else {
                ZDebug(@"JSONresponse > Response: %@", objResponse);
                
                if ([objResponse count] > 0 && [[objResponse objectAtIndex:0] valueForKey:@"success"] && [[[objResponse objectAtIndex:0] valueForKey:@"success"] boolValue]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appDelegate.strApplicationName message:[appDelegate getValueForLabelWithId:@"ALT_REPORT_SUBMT"] delegate:self cancelButtonTitle:[appDelegate getValueForLabelWithId:@"BTN_OK"] otherButtonTitles:nil];
                    [alert show];
                    blnIsSubmit = YES;
                }
                else if ([objResponse count] > 0 && [[objResponse objectAtIndex:0] valueForKey:@"message"]) {
                    [appDelegate showAlertWithMessage:[[objResponse objectAtIndex:0] valueForKey:@"message"] andTitle:AppName];
                }
                else {
                    [appDelegate showAlertWithMessage:@"Error ocuured during uploading your incident , please try again." andTitle:AppName];
                }
                
//                if ([objResponse count] > 0 || [[objResponse objectAtIndex:0] valueForKey:@"success"]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appDelegate.strApplicationName message:[appDelegate getValueForLabelWithId:@"ALT_REPORT_SUBMT"] delegate:self cancelButtonTitle:[appDelegate getValueForLabelWithId:@"BTN_OK"] otherButtonTitles:nil];
//                    [alert show];
//                    blnIsSubmit = YES;
//                }else{
//                    [appDelegate showAlertWithMessage:@"Error ocuured during uploading your incident , please try again." andTitle:AppName];
//                }
            }
        }];
        
        [request setFailedBlock:^{
            [progressView hide:YES];
            [appDelegate showAlertWithMessage:@"Error ocuured during uploading your incident , please try again." andTitle:AppName];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        txtDate.text = @"";
        txtIncident.text = @"";
        txtSchoolName.text = @"";
        txtState.text = @"";
        txtTime.text = @"";
        txtCulprit.text = @"";
        txtDescription.text = @"";
        txtVictim.text = @"";
        txtName.text = @"";
        txtReporterType.text = @"";
        txtPhoneNumber.text = @"";
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma UITEXTFIELD delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == txtState || textField == txtIncident || textField == txtDate || textField == txtTime || textField == txtReporterType)
    {
        [currentTextField resignFirstResponder];
        return NO;
    }
    else
    {
        currentTextField = textField;
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtSchoolName)
    {
        [scrollView setScrollEnabled:NO];
        
        if(string.length == 0)
        {
            if(txtSchoolName.text.length - 1 < 2)
            {
                [tbView removeFromSuperview];
                IsTableViewAdded = NO;
                return YES;
            }
            else
            {
                if([appDelegate isInternetConnection]) {
                    
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    
                    NSString *strSchoolName = txtSchoolName.text;
                    
                    if ([strSchoolName length] > 0) {
                        strSchoolName = [strSchoolName substringToIndex:[strSchoolName length] - 1];
                    }
                    //[self sendRequest:[strSchoolName stringByAppendingString:string]];
                    
                    [self performSelector:@selector(sendRequest:) withObject:[strSchoolName stringByAppendingString:string] afterDelay:1];
                    
                    
                }
                else {
                    txtSchoolName.text = @"";
                    [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_NETWORK"] andTitle:AppName];
                }
                
                return YES;
                
            }
        }
        else if(txtSchoolName.text.length + 1 > 1)
        {
            if(txtState.text.length > 0)
            {
                if([appDelegate isInternetConnection]) {
                    
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    
                    [self performSelector:@selector(sendRequest:) withObject:[txtSchoolName.text stringByAppendingString:string] afterDelay:1];
                    
                    // [self sendRequest:[txtSchoolName.text stringByAppendingString:string]];
                }
                else {
                    txtSchoolName.text = @"";
                    [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_NETWORK"] andTitle:AppName];
                }
                
                return YES;
            }
            else
            {
                [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_STATE"] andTitle:appDelegate.strApplicationName];
                [textField resignFirstResponder];
                textField.text = @"";
                return NO;
            }
        }
        else
            return YES;
    }
    else
    {
        if(textField.text.length > 100)
            return NO;
        else
        {
            [scrollView setScrollEnabled:YES];
            return YES;
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == txtSchoolName)
    {
        [tbView removeFromSuperview];
        IsTableViewAdded = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == txtSchoolName)
    {
        [tbView removeFromSuperview];
        IsTableViewAdded = NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView adjustOffsetToIdealIfNeeded];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [textView resignFirstResponder];
    }
}

-(void)dismissKeyboard {
    [tbView removeFromSuperview];
    IsTableViewAdded = NO;
}

@end
