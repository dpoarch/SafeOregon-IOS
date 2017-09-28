//
//  ThankyouViewController.m
//  Sprigeo
//
//  Created by eTech Developer on 10/02/16.
//
//

#import "ThankyouViewController.h"

@interface ThankyouViewController ()

@end

@implementation ThankyouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
  //  self.view.backgroundColor = APP_BACKGROUD_COLOR;
    
    self.title = [appDelegate getValueForLabelWithId:@"TITLE_THANKU"];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    lblThankuMsg.text = @"Thank you for helping to keep our schools safe. Your tip was sent. Your tip ID number 1234. If this is an emergency situation please call 911.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [lblThankuMsg release];
    [super dealloc];
}
- (IBAction)btnSubmitNewTip:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
