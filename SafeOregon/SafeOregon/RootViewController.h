//
//  RootViewController.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendar.h"

@class TPKeyboardAvoidingScrollView;

@interface RootViewController : UIViewController<PMCalendarControllerDelegate,JSONResponseDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITextField *txtState;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtSchoolName;
    IBOutlet UITextField *txtIncident;
    IBOutlet UITextField *txtTime;
    IBOutlet UITextField *txtVictim;
    IBOutlet UITextField *txtCulprit;
    IBOutlet UITextView *txtDescription;
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    IBOutlet UITextField *txtReporterType;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtPhoneNumber;
    
    IBOutlet UILabel *lblState;
    IBOutlet UILabel *lblSchool;
    IBOutlet UILabel *lblIncident;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblVictim;
    IBOutlet UILabel *lblCulprit;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblReporterType;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblPhoneNumber;
    IBOutlet UIButton *btnSubmit;
    
    NSString *strStateID;
    NSString *strSchoolID;
    NSString *strTimeValue;
    UITableView *tbView;
    bool IsTableViewAdded;
    etmResponse *responseObj;
    UITextField *currentTextField;
    NSString *strIncedentID;
}

@property (nonatomic, strong) PMCalendarController *calendarDatePicker;

- (IBAction)showCalendar:(id)sender;
-(IBAction)showTime:(id)sender;
- (BOOL)validate;
-(IBAction)showReporterType:(id)sender;
-(IBAction)submitClicked:(id)sender;
-(IBAction)showIncidents:(id)sender;
-(IBAction)showStates:(id)sender;
-(IBAction)showSchoolList:(id)sender;
-(void)sendRequest:(NSString*)strSchoolName;
-(void)dateSelected:(NSDate*)selectedDate;

@end
