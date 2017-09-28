//
//  SettingViewController.h
//  Sprigeo
//
//  Created by iphone1 on 03/07/13.
//
//

#import "etmResponse.h"
#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UIPickerViewAccessibilityDelegate,UIPickerViewDataSource,UIPickerViewDelegate,JSONResponseDelegate>

{
    NSMutableDictionary *dictLang ;
    NSMutableArray *arrAllKeys;
    NSMutableArray *arrAllvalues;
    IBOutlet UIPickerView *picker;
    IBOutlet UILabel *lblSelect;
    NSString *selectedLanguage;
    IBOutlet UIButton *btnUpdate;
    NSUserDefaults *selectedLang;
    int selecterdIndex;
}

-(void)progressView123;
- (IBAction)btnChkForUpdateClicked:(id)sender;

@end
