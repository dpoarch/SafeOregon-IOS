//
//  TipDetailViewController.h
//  Sprigeo
//
//  Created by eTech Developer on 09/02/16.
//
//

#import <UIKit/UIKit.h>

@interface TipDetailViewController : UIViewController
{
    
    IBOutlet UITextView *txvTipDetail;
    IBOutlet UILabel *lblTipId;
    IBOutlet UILabel *lblTipDate;
}
@property (nonatomic,strong) NSDictionary *tipDetail;
@end
