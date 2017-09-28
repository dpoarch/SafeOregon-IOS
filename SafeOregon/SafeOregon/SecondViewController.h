//
//  SecondViewController.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface SecondViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *txtVictim;
    IBOutlet UITextField *txtCulprit;
    IBOutlet UITextView *txtDescription;
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    IBOutlet UILabel *lblVictim;
    IBOutlet UILabel *lblCulprit;
    IBOutlet UILabel *lblDescription;
}

- (BOOL)validate;
- (IBAction)hideKeyboard:(id)sender;
@end


