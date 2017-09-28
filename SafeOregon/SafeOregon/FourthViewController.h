//
//  FourthViewController.h
//  Sprigeo
//
//  Created by eTech Developer on 09/02/16.
//
//

#import <UIKit/UIKit.h>

@interface FourthViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *mainView;
    IBOutlet UILabel *lblHowManyTImeSituation;
    IBOutlet UILabel *lblHaveYouadult;
    IBOutlet UITextField *txtHoeManyTime;
    IBOutlet UITextField *txtHaveYouAdult;
    IBOutlet UITextField *txtOtherValue;
}
@end
