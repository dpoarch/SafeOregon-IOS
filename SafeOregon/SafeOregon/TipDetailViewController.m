//
//  TipDetailViewController.m
//  Sprigeo
//
//  Created by eTech Developer on 09/02/16.
//
//

#import "TipDetailViewController.h"

@interface TipDetailViewController ()

@end

@implementation TipDetailViewController
@synthesize tipDetail;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZDebug(@"%@", tipDetail);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    [backButton release];
    
    self.title = [appDelegate getValueForLabelWithId:@"TITLE_MY_TIP_DETAIL"];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    lblTipId.text = [NSString stringWithFormat:@"Tip Id : %@",[tipDetail valueForKey:@"TipId"]];
    lblTipDate.text = [NSString stringWithFormat:@"Date : %@",[tipDetail valueForKey:@"Date"]];
    txvTipDetail.text = [NSString stringWithFormat:@"TipDetail :\n %@",[tipDetail valueForKey:@"Detaile"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [lblTipId release];
    [lblTipDate release];
    [txvTipDetail release];
    [super dealloc];
}
@end
