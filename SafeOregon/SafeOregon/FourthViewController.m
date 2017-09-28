//
//  FourthViewController.m
//  Sprigeo
//
//  Created by eTech Developer on 09/02/16.
//
//

#import "FourthViewController.h"
#import "ThirdViewController.h"

@interface FourthViewController ()
{
    NSMutableArray *arySituation;
    NSMutableArray *aryAdult;
}
@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView.backgroundColor = FORM3_BACKGROUD_COLOR;
    
    self.title = [appDelegate getValueForLabelWithId:@"TITLE_FORM3"];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NextButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(nextClicked)];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    mainView.backgroundColor = [UIColor clearColor];
    txtHaveYouAdult.delegate = self;
    txtHoeManyTime.delegate = self;
    txtOtherValue.delegate = self;
    
    arySituation = [[NSMutableArray alloc] init];
    aryAdult = [[NSMutableArray alloc] init];
    
   
    NSArray  *arrTemp1 = [NSArray arrayWithObjects:@"Yes",@"No", nil];
    NSArray  *arrTemp = [NSArray arrayWithObjects:@"This is the first time",@"One other time",@"Once a month",@"Once a week",@"Every day", nil];
    
    for (NSString *ivalue in arrTemp) {
        [arySituation addObject:ivalue];
    }
    
    for (NSString *ivalue in arrTemp1) {
        [aryAdult addObject:ivalue];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)nextClicked
{
    [self.view endEditing:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    BOOL validate = [self validate];
    //BOOL validate = true;
    if(validate)
    {
        blnIsSubmit = NO;
        ThirdViewController *viewController = [[ThirdViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (BOOL)validate
{
    txtHaveYouAdult.delegate = self;
    txtHoeManyTime.delegate = self;
    txtOtherValue.delegate = self;
    // Need Validation Here
    if(txtHaveYouAdult.text.length <= 0) {
        [appDelegate showAlertWithMessage:@"Report incident is Required" andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else if(txtHoeManyTime.text.length <= 0) {
        [appDelegate showAlertWithMessage:@"Report to adult required" andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else {
        [dictWholeData setValue:txtHaveYouAdult.text forKey:@"reportedToAdult"];
        [dictWholeData setValue:txtHoeManyTime.text forKey:@"howManyTimes"];
        [dictWholeData setValue:txtOtherValue.text forKey:@"reportedToAdultName"];
        return YES;
    }
}

-(IBAction)showHowManyType:(id)sender
{
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        txtHoeManyTime.text = [arySituation objectAtIndex:selectedIndex];
        
       // [dictWholeData setValue:[[aryIncidents objectAtIndex:selectedIndex]valueForKey:@"ID"] forKey:@"reportertype"];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"ReporterType Picker Canceled");
    };
    
    NSMutableArray *tempReporterArray = [[NSMutableArray alloc] init];
    NSInteger selectedIndex= 0;
    
    ZDebug(@"%ld", [arySituation count]);
    
    for(int i=0;i<[arySituation count];i++)
    {
        [tempReporterArray addObject:[arySituation objectAtIndex:i]];
        
        if (txtHoeManyTime.text && [txtHoeManyTime.text length] > 0) {
            if ([txtHoeManyTime.text isEqualToString:[arySituation objectAtIndex:i]]) {
                selectedIndex = i;
            }
        }
    }
    
    ZDebug(@"%@", tempReporterArray);
    
    [ActionSheetStringPicker showPickerWithTitle:[appDelegate getValueForLabelWithId:@"LBL_SITUATON"] rows:(NSArray *)tempReporterArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
    [tempReporterArray release];
}

-(IBAction)showAdultType:(id)sender
{
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        txtHaveYouAdult.text = [aryAdult objectAtIndex:selectedIndex];
        
        if ([txtHaveYouAdult.text isEqualToString:@"Yes"]) {
            txtOtherValue.hidden = NO;
        }
        else {
            txtOtherValue.text = @"";
            txtOtherValue.hidden = YES;
        }
     //   [dictWholeData setValue:[[aryIncidents objectAtIndex:selectedIndex]valueForKey:@"ID"] forKey:@"reportertype"];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"ReporterType Picker Canceled");
    };
    
    NSMutableArray *tempReporterArray = [[NSMutableArray alloc] init];
    NSInteger selectedIndex= 0;
    
    for(int i=0;i<[aryAdult count];i++)
    {
        [tempReporterArray addObject:[aryAdult objectAtIndex:i]];
        
        if (txtHaveYouAdult.text && [txtHaveYouAdult.text length] > 0) {
            if ([txtHaveYouAdult.text isEqualToString:[aryAdult objectAtIndex:i]]) {
                selectedIndex = i;
            }
        }
    }
    
    [ActionSheetStringPicker showPickerWithTitle:[appDelegate getValueForLabelWithId:@"LBL_WHO_IS"] rows:(NSArray *)tempReporterArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
    [tempReporterArray release];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [self showHowManyType:textField];
    }else if (textField.tag == 2) {
        [self showAdultType:textField];
    }else if(textField.tag == 0) {
        return YES;
    }
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [lblHowManyTImeSituation release];
    [lblHaveYouadult release];
    [txtHoeManyTime release];
    [txtHaveYouAdult release];
    [txtOtherValue release];
    [scrollView release];
    [mainView release];
    [super dealloc];
}
@end
