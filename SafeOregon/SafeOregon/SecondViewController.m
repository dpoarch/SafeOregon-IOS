//
//  SecondViewController.m
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FourthViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if(DEVICE_IOS7 && DEVICE_HEIGHT==568) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [scrollView setFrame:CGRectMake(0,45,320,DEVICE_HEIGHT-45)];
        [scrollView setContentSize:CGSizeMake(320,400)];
    }
    else if (DEVICE_IOS7 &&  DEVICE_HEIGHT==480){
        self.automaticallyAdjustsScrollViewInsets = NO;
        [scrollView setFrame:CGRectMake(0,45,320,DEVICE_HEIGHT-45)];
        [scrollView setContentSize:CGSizeMake(320,400)];
    }
        else if (!DEVICE_IOS7 && DEVICE_HEIGHT==480){
        [scrollView setContentSize:CGSizeMake(320,400)];
    }
    
    [scrollView setBackgroundColor:[UIColor clearColor]];
  //  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg3.png"]]];
    self.view.backgroundColor = FORM2_BACKGROUD_COLOR;
    lblCulprit.text = [appDelegate getValueForLabelWithId:@"LBL_BULLY"];
    lblVictim.text = [appDelegate getValueForLabelWithId:@"LBL_BULLY_PERSON"];
    lblDescription.text = [appDelegate getValueForLabelWithId:@"LBL_WHAT_HAPPEN"];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NextButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(nextClicked)];
    self.navigationItem.rightBarButtonItem = nextButton;
    self.title = [appDelegate getValueForLabelWithId:@"TITLE_FORM2"];
    
    [[txtDescription layer] setCornerRadius:5.0];
    [[txtDescription layer] setBorderColor:[UIColor colorWithRed:0.388 green:0.388 blue:0.388 alpha:1.0].CGColor];
    [[txtDescription layer] setBorderWidth:2.0];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
}
- (IBAction)hideKeyboard:(id)sender {
    [txtCulprit resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtVictim resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(blnIsSubmit)
    {
        txtCulprit.text = @"";
        txtDescription.text = @"";
        txtVictim.text = @"";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
        FourthViewController *viewController =[[FourthViewController alloc] initWithNibName:@"FourthViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (BOOL)validate
{

    // Need Validation Here
    if(txtDescription.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_DESC"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else {
        [dictWholeData setValue:txtVictim.text forKey:@"victim"];
        [dictWholeData setValue:txtCulprit.text forKey:@"culprit"];
        [dictWholeData setValue:txtDescription.text forKey:@"description"];
        return YES;
    }
    
    /*
    NSMutableArray *aryValidInput = [[NSMutableArray alloc] init];
    ValidationRequestVO *valReq;
    
    valReq = [[ValidationRequestVO alloc] initWithValidationType:kNullValidator
                                                    srcParamName:@"Description" srcParamValue:txtDescription.text validationFailMsg:[appDelegate getValueForLabelWithId:@"ALT_DESC"]];
    
    [aryValidInput addObject:valReq];
    
    ValidationResponseVO *responseVO = [ValidationUtility validateFields:aryValidInput];
    if(responseVO.IsValidationSuccessful)
    {
        [dictWholeData setValue:txtVictim.text forKey:@"victim"];
        [dictWholeData setValue:txtCulprit.text forKey:@"culprit"];
        [dictWholeData setValue:txtDescription.text forKey:@"description"];
        return YES;
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"%@", responseVO.CustomValidationMsg];
        [appDelegate showAlertWithMessage:msg andTitle:appDelegate.strApplicationName];
        return NO;
    }
    */
}


#pragma UITEXTFIELD delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    sender.delegate = self;
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [scrollView adjustOffsetToIdealIfNeeded];
//}

#pragma UITEXTVIEW delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}
@end
