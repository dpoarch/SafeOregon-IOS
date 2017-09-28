//
//  ThirdViewController.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface ThirdViewController : UIViewController <UIAlertViewDelegate,JSONResponseDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *txtReporterType;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtPhoneNumber;
    IBOutlet UIButton *btnSubmit;
    IBOutlet UILabel *lblReporterType;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblPhoneNumber;
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    IBOutlet UIButton *btnUpload;
    
    IBOutlet UIButton *btnUpload1;
    UIImagePickerController *ipc;
    IBOutlet UIImageView *uploadedImage;
}

-(IBAction)showReporterType:(id)sender;
-(IBAction)submitClicked:(id)sender;

- (IBAction)btnUploadPress:(id)sender;

@end
