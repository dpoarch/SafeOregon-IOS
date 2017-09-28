//
//  FirstViewController.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendar.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface FirstViewController : UIViewController<PMCalendarControllerDelegate,JSONResponseDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *txtState;
    IBOutlet UIButton *btnHide;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtSchoolName;
    IBOutlet UITextField *txtIncident;
    IBOutlet UITextField *txtTime;
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    
    IBOutlet UILabel *lblState;
    IBOutlet UILabel *lblSchool;
    IBOutlet UILabel *lblIncident;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblTime;
    
    NSString *strStateID;
    NSString *strIncedentID;
    NSString *strSchoolID;
    NSString *strTimeValue;
    UITableView *tbView;
    bool IsTableViewAdded;
    etmResponse *responseObj;
    UITextField *currentTextField;
}

@property (nonatomic, strong) PMCalendarController *calendarDatePicker;

-(IBAction)showStates:(id)sender;
- (IBAction)btnHideTableClicked:(id)sender;
- (IBAction)showCalendar:(id)sender;
-(IBAction)showTime:(id)sender;
- (BOOL)validate;
-(IBAction)showSchoolList:(id)sender;
- (void)animateView:(NSUInteger)tag;
-(void)sendRequest:(NSString*)strSchoolName;
- (IBAction)hideKeyboard:(id)sender;
@end
