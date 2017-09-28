//
//  FirstViewController.m
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ListViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FirstViewController
@synthesize calendarDatePicker;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (IBAction)hideKeyboard:(id)sender {
    [txtSchoolName resignFirstResponder];
}
#pragma mark - View lifecycle

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(DEVICE_IOS7 && DEVICE_HEIGHT==568) {
        [scrollView setFrame:CGRectMake(0, 0,320,DEVICE_HEIGHT)];
        [scrollView setContentSize:CGSizeMake(320,400)];
    }
    else if (DEVICE_IOS7 &&  DEVICE_HEIGHT==480)
    {
        [scrollView setFrame:CGRectMake(0,0,320,460)];
        [scrollView setContentSize:CGSizeMake(320,400)];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    self.view.backgroundColor = FORM1_BACKGROUD_COLOR;
    
    btnHide.hidden = YES;
    
    @try {
        [scrollView setBackgroundColor:[UIColor clearColor]];
        lblState.text = [appDelegate getValueForLabelWithId:@"LBL_LIVE"];
        lblSchool.text = [appDelegate getValueForLabelWithId:@"LBL_SEL_SCHOOL"];
        lblIncident.text = [appDelegate getValueForLabelWithId:@"LBL_WHERE_INCIDENT"];
        lblDate.text = [appDelegate  getValueForLabelWithId:@"LBL_WHEN_HAPPEN"];
        lblTime.text = [appDelegate getValueForLabelWithId:@"LBL_TIME"];
        
        self.title = [appDelegate getValueForLabelWithId:@"TITLE_FORM1"];
        
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Custom Title"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NextButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(nextClicked)];
        self.navigationItem.rightBarButtonItem = nextButton;
        
        tbView = [[UITableView alloc] init];
        tbView.dataSource = self;
        tbView.delegate = self;
        
        [[tbView layer] setCornerRadius:5.0];
        [[tbView layer] setBorderColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.0].CGColor];
        [[tbView layer] setBorderWidth:2.0];
        
        responseObj = [[etmResponse alloc] init];
        responseObj._delegate = self;
        
        CGFloat y = 20;
        
        for (int i =0; i < [scrollView.subviews count]; i ++) {
            CGFloat height = 0;
            UIView * view1 = [scrollView viewWithTag:i];
            
            if ([view1 class] == [UILabel class]) {
                
                UILabel * viewLabel = (UILabel *)view1;
                
                height =  [appDelegate webViewHeight:viewLabel.text withFont:[UIFont systemFontOfSize:15] webViewWidth:300];
                
                viewLabel.frame = CGRectMake(viewLabel.frame.origin.x,y, viewLabel.frame.size.width, height);
                
                y = y+ height +10;
            }else if ([view1 class] == [UITextField class]){
                
                UITextField * viewText =(UITextField *)view1;
                
                viewText.frame = CGRectMake(viewText.frame.origin.x,y, viewText.frame.size.width, viewText.frame.size.height);
                y = 40+y;
            }
            
        }
        //susheel
    }
    @catch (NSException *exception) {
        ZDebug(@"first viewDidLoad exception = %@",exception);
    }
    
    
}

-(void)dismissKeyboard {
    [tbView removeFromSuperview];
    btnHide.hidden = YES;
    
    IsTableViewAdded = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    doesnothidecalendar = -1;
    if(blnIsSubmit)
    {
        txtDate.text = @"";
        txtIncident.text = @"";
        txtSchoolName.text = @"";
        txtState.text = @"";
        txtTime.text = @"";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)nextClicked
{
    [self.view endEditing:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    BOOL validate = [self validate];
    if(validate)
    {
        blnIsSubmit = NO;
        SecondViewController *viewController = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}
-(IBAction)showIncidents:(id)sender
{
    @try {
        [self.view endEditing:YES];
        
        if(DEVICE_IOS7 && DEVICE_HEIGHT==568) {
            [scrollView setFrame:CGRectMake(0,0, 320,DEVICE_HEIGHT)];
            [scrollView setContentSize:CGSizeMake(320,410)];
        }
        else if (DEVICE_IOS7 &&  DEVICE_HEIGHT==480)
        {
            [scrollView setFrame:CGRectMake(0,0,320,DEVICE_HEIGHT)];
            [scrollView setContentSize:CGSizeMake(320,410)];
        }
        
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

- (IBAction)btnHideTableClicked:(id)sender {
    [tbView removeFromSuperview];
    btnHide.hidden = YES;
    
}
- (IBAction)showCalendar:(id)sender
{
    ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(doneActionDatePicker:) origin:sender];
    actionSheetPicker.maximumDate = [NSDate date];
    [actionSheetPicker showActionSheetPicker];

//    @try {
//        self.calendarDatePicker = [[PMCalendarController alloc] initWithThemeName:@"default"];
//        calendarDatePicker.delegate = self;
//        calendarDatePicker.mondayFirstDayOfWeek = NO;
//        [calendarDatePicker presentCalendarFromView:sender
//                           permittedArrowDirections:PMCalendarArrowDirectionAny
//                                           animated:YES];
//        
//        self.calendarDatePicker.allowedPeriod = [PMPeriod periodWithStartDate:[[NSDate date] dateByAddingYears:-50]
//                                                                      endDate:[[NSDate date]dateByAddingDays:0]];
//        if(doesnothidecalendar == -1)
//            doesnothidecalendar = 0;
//    }
//    @catch (NSException *exception) {
//        ZDebug(@"showCalendar  exception==%@",exception);
//        
//    }
    
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

-(IBAction)showSchoolList:(id)sender
{
    ListViewController *viewController = [[ListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(IBAction)showTime:(id)sender
{
    
    @try {
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
        ZDebug(@"showTime  exception==%@",exception);
    }
}

- (BOOL)validate
{
    
    // Need Validation Here
    if(txtSchoolName.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_SCHOOL"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else if(txtIncident.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_INCIDENT"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else {
        [dictWholeData setValue:strStateID forKey:@"state"];
        [dictWholeData setValue:txtSchoolName.text forKey:@"schoolname"];
        [dictWholeData setValue:strSchoolID forKey:@"schoolid"];
        [dictWholeData setValue:txtDate.text forKey:@"date"];
        [dictWholeData setValue:strIncedentID forKey:@"incident"];
        [dictWholeData setValue:strTimeValue forKey:@"time"];
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
    
    
    ValidationResponseVO *responseVO = [ValidationUtility validateFields:aryValidInput];
    if(responseVO.IsValidationSuccessful)
    {
        [dictWholeData setValue:strStateID forKey:@"state"];
        [dictWholeData setValue:txtSchoolName.text forKey:@"schoolname"];
        [dictWholeData setValue:strSchoolID forKey:@"schoolid"];
        [dictWholeData setValue:txtDate.text forKey:@"date"];
        [dictWholeData setValue:strIncedentID forKey:@"incident"];
        [dictWholeData setValue:strTimeValue forKey:@"time"];
        return YES;
    }
    else{
        NSString *msg = [NSString stringWithFormat:@"%@", responseVO.CustomValidationMsg];
        [appDelegate showAlertWithMessage:msg andTitle:appDelegate.strApplicationName];
        return NO;
    }
    */
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if(tag == 6)
    {
        rect.origin.y = -44.0f * 2;
    }
    else
    {
        rect.origin.y = 0;
    }
    //ss
    if(DEVICE_IOS7 && DEVICE_HEIGHT==568) {
        [scrollView setFrame:CGRectMake(0, 50, 320,DEVICE_HEIGHT-50)];
        [scrollView setContentSize:CGSizeMake(320,410)];
    }
    else if (DEVICE_IOS7 &&  DEVICE_HEIGHT==480)
    {
        [scrollView setFrame:CGRectMake(0,50,320,DEVICE_HEIGHT-50)];
        [scrollView setContentSize:CGSizeMake(320,410)];
    }
    //ss
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)sendRequest:(NSString*)strSchoolName
{
    @try {
        NSUserDefaults *selectedLang = [NSUserDefaults standardUserDefaults];
        
        NSString *strURL = [NSString stringWithFormat:@"%@?stateid=Oregon&q=%@&lan=%@", schoolLookupURL,strSchoolName,[selectedLang valueForKey:KEY_LANG]];
        
        //        ZDebug(@"strURL==%@",strURL);
        
        NSString *strRequestData = [NSString stringWithFormat:@"token=%@",urltoken];
        [responseObj sendRequest:strURL withPostData:strRequestData];
    }
    @catch (NSException *exception) {
        ZDebug(@"sendRequest  exception == %@",exception);
    }
}

-(void)JSONresponse:(NSArray *)aryResponse
{
    @try {
        
        //ZDebug(@"response array - %@",aryResponse);
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
                //ss
                if (DEVICE_IOS7 && DEVICE_HEIGHT==568) {
                    tbView.frame = CGRectMake(19,txtSchoolName.frame.origin.y + 80, 281, 140);
                }
                else if (DEVICE_IOS7 && DEVICE_HEIGHT==480)
                {
                    tbView.frame = CGRectMake(19,txtSchoolName.frame.origin.y + 80, 281, 140);
                }
                //ss
                else{
                    tbView.frame = CGRectMake(19,txtSchoolName.frame.origin.y + 30, 281, 140);
                }
                
                [txtSchoolName resignFirstResponder];
                
                [self.view addSubview:tbView];
                btnHide.hidden = NO;
                
                IsTableViewAdded = YES;
            }
            [tbView reloadData];
        }
        
    }
    @catch (NSException *exception) {
        ZDebug(@"JSONresponse  exception == %@",exception);
        
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    btnHide.hidden = YES;
    [tbView removeFromSuperview];
    UITouch *touch = [touches anyObject];
    
    CGPoint firstTouch = [touch locationInView:self.view];
    [tbView removeFromSuperview];
}

- (void)oneTap:(UITapGestureRecognizer *)tapRecognizer
{
    
    CGPoint point = [tapRecognizer locationInView:tapRecognizer.view];
    UIView *viewTouched = [tapRecognizer.view hitTest:point withEvent:nil];
    //    ZDebug(@"tapRecognizer class == %@",[viewTouched class]);
    
    if ([viewTouched isDescendantOfView:tbView]) {
        
    } else {
        //        ZDebug(@"tapRecognizer");
    }
    if (![tapRecognizer.view isDescendantOfView:tbView]) {
        [tbView removeFromSuperview];
        btnHide.hidden = YES;
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
    
    // Configure the cell...
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
    btnHide.hidden = YES;
    
    IsTableViewAdded = NO;
    [txtSchoolName resignFirstResponder];
    [self animateView:0];
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
#pragma UITEXTFIELD delegate methods
//ss
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    sender.delegate = self;
}
//ss
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == txtSchoolName)
    {
        currentTextField = textField;
        return YES;
    }
    else
    {
        [currentTextField resignFirstResponder];
        return NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == txtSchoolName)
    {
        if(string.length == 0)
        {
            if(txtSchoolName.text.length - 1 < 2)
            {
                [tbView removeFromSuperview];
                btnHide.hidden = YES;
                IsTableViewAdded = NO;
                return YES;
            }
            else {
                if([appDelegate isInternetConnection]) {
                    
                    NSString *strSchoolName = txtSchoolName.text;
                    
                    if ([strSchoolName length] > 0) {
                        strSchoolName = [strSchoolName substringToIndex:[strSchoolName length] - 1];
                    }
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    [self performSelector:@selector(sendRequest:) withObject:[txtSchoolName.text  stringByAppendingString:string] afterDelay:1];
                    //[self sendRequest:[strSchoolName stringByAppendingString:string]];
                    
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
          //  if(txtState.text.length > 0)
          //  {
                if([appDelegate isInternetConnection]) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                     [self performSelector:@selector(sendRequest:) withObject:[txtSchoolName.text  stringByAppendingString:string] afterDelay:1];
                   // [self sendRequest:[txtSchoolName.text stringByAppendingString:string]];
                }else {
                    txtSchoolName.text = @"";
                    [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_NETWORK"] andTitle:AppName];
                }
                
                return YES;
//            }
//            else
//            {
//                [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_STATE"] andTitle:appDelegate.strApplicationName];
//                [textField resignFirstResponder];
//                textField.text = @"";
//                return NO;
//            }
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
            return YES;
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == txtSchoolName)
    {
        [tbView removeFromSuperview];
        btnHide.hidden = YES;
        
        IsTableViewAdded = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  //  [scrollView setContentOffset:CGPointZero];
        if(textField == txtSchoolName)
    {
//        //ss
//        if(DEVICE_IOS7 && DEVICE_HEIGHT==568) {
//            [scrollView setFrame:CGRectMake(0, 50, 320,DEVICE_HEIGHT-50)];
//            [scrollView setContentSize:CGSizeMake(320,410)];
//        }
//        else if (DEVICE_IOS7 &&  DEVICE_HEIGHT==480)
//        {
//            [scrollView setFrame:CGRectMake(0,50,320,DEVICE_HEIGHT-50)];
//            [scrollView setContentSize:CGSizeMake(320,410)];
//        }
        //ss
        IsTableViewAdded = NO;
    }
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (tbView) {
        //        [tbView removeFromSuperview];
    }
    [textField resignFirstResponder];
  //  [scrollView setContentOffset:CGPointZero];
    return YES;
}

- (void)dealloc {
    [scrollView release];
    [btnHide release];
    [super dealloc];
}
- (void)viewDidUnload {
    [scrollView release];
    scrollView = nil;
    [btnHide release];
    btnHide = nil;
    [super viewDidUnload];
}
@end
