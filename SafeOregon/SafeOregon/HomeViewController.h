//
//  HomeViewController.h
//  Sprigeo
//
//  Created by Krunal Doshi on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdWhirlView.h"
//#import "AdWhirlDelegateProtocol.h"

//@interface HomeViewController : UIViewController<AdWhirlDelegate>
@interface HomeViewController : UIViewController{
    IBOutlet UIButton *btnReport;
    IBOutlet UIButton *btnHeroicsProject;
    IBOutlet UILabel *lblWlcome;
    IBOutlet UIButton *btnCallHelpLine;
    IBOutlet UIButton *btnMyTip;
    IBOutlet UILabel *lblVerson;
}
-(IBAction)btnReportClicked:(id)sender;
-(IBAction)btnHeroicsProject:(id)sender;
- (IBAction)btnCallHeplLinePress:(id)sender;
- (IBAction)btnMyTipPress:(id)sender;

@end
