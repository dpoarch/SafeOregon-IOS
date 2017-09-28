		//
//  ThirdViewController.m
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"
#import "ASIFormDataRequest.h"
#include <MobileCoreServices/UTCoreTypes.h>
#include <MobileCoreServices/UTType.h>
#import "ThankyouViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    if (DEVICE_IOS7 && DEVICE_HEIGHT == 568) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [scrollView setFrame:CGRectMake(0,50, 320, DEVICE_HEIGHT-50)];
//        [scrollView setContentSize:CGSizeMake(320,420)];
//    }
//    else if (DEVICE_IOS7 &&  DEVICE_HEIGHT==480){
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [scrollView setFrame:CGRectMake(0,50,320, DEVICE_HEIGHT-50)];
//        [scrollView setContentSize:CGSizeMake(320, 420)];
//    }
//    else if (!DEVICE_IOS7 && DEVICE_HEIGHT==480){
//        [scrollView setContentSize:CGSizeMake(320,400)];
//    }
    
    [scrollView setBackgroundColor:[UIColor clearColor]];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2.png"]]];
    self.view.backgroundColor = FORM4_BACKGROUD_COLOR;
    [btnSubmit setTitle:[appDelegate getValueForLabelWithId:@"BTN_SUBMIT"] forState:UIControlStateNormal];
    lblReporterType.text = [appDelegate getValueForLabelWithId:@"LBL_WHO"];
    lblName.text = [appDelegate getValueForLabelWithId:@"LBL_NAME"];
    lblPhoneNumber.text = [appDelegate getValueForLabelWithId:@"LBL_PHONE"];
    
    self.title = [appDelegate getValueForLabelWithId:@"TITLE_FORM4"];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    btnUpload.hidden = YES;
    uploadedImage.hidden = YES;
    
    CGFloat y = 20;
    
    for (int i =0; i < [scrollView.subviews count]; i ++) {
        CGFloat height = 0;
        UIView * view1 = [scrollView viewWithTag:i];
        
        if ([view1 class] == [UILabel class]) {
            
            UILabel * viewLabel = (UILabel *)view1;
            
            height =  [appDelegate webViewHeight:viewLabel.text withFont:[UIFont systemFontOfSize:15] webViewWidth:250];
            
            viewLabel.frame = CGRectMake(viewLabel.frame.origin.x,y, viewLabel.frame.size.width, height);
            
            y = y+ height +10;
            
        }else if ([view1 class] == [UITextField class]){
            
            UITextField * viewText =(UITextField *)view1;
            
            viewText.frame = CGRectMake(viewText.frame.origin.x,y, viewText.frame.size.width, viewText.frame.size.height);
            y = 40+y;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)showReporterType:(id)sender
{
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        txtReporterType.text = [[aryReporterType objectAtIndex:selectedIndex]valueForKey:@"Reporter"];
        [dictWholeData setValue:[[aryIncidents objectAtIndex:selectedIndex]valueForKey:@"ID"] forKey:@"reportertype"];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"ReporterType Picker Canceled");
    };
    
    NSMutableArray *tempReporterArray = [[NSMutableArray alloc] init];
    NSInteger selectedIndex= 0;
    
    for(int i=0;i<[aryReporterType count];i++)
    {
        [tempReporterArray addObject:[[aryReporterType objectAtIndex:i] valueForKey:@"Reporter"]];
        
        if (txtReporterType.text && [txtReporterType.text length] > 0) {
            if ([txtReporterType.text isEqualToString:[[aryReporterType objectAtIndex:i] valueForKey:@"Reporter"]]) {
                selectedIndex = i;
            }
        }
    }
    
    [ActionSheetStringPicker showPickerWithTitle:[appDelegate getValueForLabelWithId:@"LBL_TYPE"] rows:(NSArray *)tempReporterArray initialSelection:selectedIndex doneBlock:done cancelBlock:cancel origin:sender];
    [tempReporterArray release];
}

- (BOOL)validate
{
    // Need Validation Here
    if(txtReporterType.text.length <= 0) {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_REPORTER"] andTitle:appDelegate.strApplicationName];
        return NO;
    }
    else {
        return YES;
    }
}

-(void)sendRequest
{
    
    if([appDelegate isInternetConnection]) {
        [progressView show:YES];
        [dictWholeData setValue:txtName.text forKey:@"name"];
      //  [dictWholeData setValue:txtPhoneNumber.text forKey:@"phonenumber"];
        
        NSURL *url = [NSURL URLWithString:submitIncidentURL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setDidFinishSelector:@selector(requestFetchCompleted:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request addPostValue:urltoken forKey:@"token"];
        [request addPostValue:[dictWholeData objectForKey:@"state"] forKey:@"stateId"];
        [request addPostValue:[dictWholeData objectForKey:@"schoolname"] forKey:@"school"];
        [request addPostValue:[dictWholeData objectForKey:@"schoolid"] forKey:@"schoolId"];
        [request addPostValue:[dictWholeData objectForKey:@"incident"] forKey:@"incidentLocation"];
        [request addPostValue:[dictWholeData objectForKey:@"description"] forKey:@"incidentDescription"];
        [request addPostValue:[dictWholeData objectForKey:@"date"] forKey:@"incidentDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *datetoday = [dateFormatter stringFromDate:[NSDate date]];
        NSString *newImageName = @"image";
        newImageName = [newImageName stringByAppendingString:datetoday];
        newImageName = [newImageName stringByAppendingString:@".jpg"];
        
        if(uploadedImage.image != NULL){
            NSData *inputCGImage = UIImageJPEGRepresentation(uploadedImage.image, 0.5);
        
            NSURL *imageUpload = [NSURL URLWithString:@"http://safeoregon.com/test.php"];
            ASIFormDataRequest *uploadRequest = [ASIFormDataRequest requestWithURL:imageUpload];
            
            NSString *base64raw = [inputCGImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+=\n"] invertedSet];
            
            NSString *base64encoded = [base64raw stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
            
            [uploadRequest addPostValue:newImageName forKey:@"name"];
            [uploadRequest addPostValue:base64encoded forKey:@"image"];
            [uploadRequest startAsynchronous];
            [uploadRequest setCompletionBlock:^{
            [progressView hide:YES];
                [appDelegate showAlertWithMessage:@"Image Upload Success" andTitle:AppName];
            }];
            [uploadRequest setFailedBlock:^{
                [progressView hide:YES];
                [appDelegate showAlertWithMessage:@"Image Upload Success" andTitle:AppName];
            }];
            [request addPostValue:newImageName forKey:@"imagename"];
        }else{
            [request addPostValue:NULL forKey:@"imagename"];
        }
        
        
        
        
        if ([dictWholeData objectForKey:@"time"] && [[dictWholeData objectForKey:@"time"] length] > 0)
            [request addPostValue:[dictWholeData objectForKey:@"time"] forKey:@"incidentTime"];
        else
            [request addPostValue:@"0001" forKey:@"incidentTime"];
        
        [request addPostValue:[dictWholeData objectForKey:@"howManyTimes"] forKey:@"howManyTimes"];
        [request addPostValue:[dictWholeData objectForKey:@"reportedToAdult"] forKey:@"reportedToAdult"];
        
        if([[dictWholeData objectForKey:@"reportedToAdult"] isEqualToString:@"Yes"])
            [request addPostValue:[dictWholeData objectForKey:@"reportedToAdultName"] forKey:@"reportedToAdultName"];
        else
            [request addPostValue:NULL forKey:@"reportedToAdultName"];
        
        [request addPostValue:@"1" forKey:@"SentFromMobile"];
        [request addPostValue:[dictWholeData objectForKey:@"culprit"] forKey:@"bullyName"];
        [request addPostValue:[dictWholeData objectForKey:@"victim"] forKey:@"victimName"];
        [request addPostValue:[dictWholeData objectForKey:@"reportertype"] forKey:@"postedBy"];
        [request addPostValue:[dictWholeData objectForKey:@"name"] forKey:@"postedByName"];
        [request addPostValue:[dictWholeData objectForKey:@"phonenumber"] forKey:@"postedByContactInfo"];
        
        [request startAsynchronous];
        
        [request setCompletionBlock:^{
            [progressView hide:YES];
            
            NSData* jsonData = [request.responseString dataUsingEncoding: [NSString defaultCStringEncoding] ];
            
            NSError *error = nil;
            NSArray *objResponse = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
            
            if ([objResponse count] == 0) {
                NSLog(@"Error parsing JSON: %@", error);
                [appDelegate showAlertWithMessage:@"Error ocuured during uploading your incident , please try again." andTitle:AppName];
            }
            else {
                ZDebug(@"JSONresponse > Response: %@", objResponse);
                
                if ([objResponse count] > 0 && [[objResponse objectAtIndex:0] valueForKey:@"success"] && [[[objResponse objectAtIndex:0] valueForKey:@"success"] boolValue]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appDelegate.strApplicationName message:[appDelegate getValueForLabelWithId:@"ALT_REPORT_SUBMT"] delegate:self cancelButtonTitle:[appDelegate getValueForLabelWithId:@"BTN_OK"] otherButtonTitles:nil];
//                    [alert show];
                    
                    blnIsSubmit = YES;
                }
                else if ([objResponse count] > 0 && [[objResponse objectAtIndex:0] valueForKey:@"message"]) {
                    [appDelegate showAlertWithMessage:[[objResponse objectAtIndex:0] valueForKey:@"message"] andTitle:AppName];
                }
                else {
                    [appDelegate showAlertWithMessage:@"Error ocuured during uploading your incident , please try again." andTitle:AppName];
                }
            }
        }];
        
        [request setFailedBlock:^{
            [progressView hide:YES];
            [appDelegate showAlertWithMessage:@"Error ocuured during uploading your incident , please try again." andTitle:AppName];
        }];
    }
    else {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_NETWORK"] andTitle:AppName];
    }
}


-(void)JSONresponse:(NSArray *)aryResponse {
}

-(IBAction)submitClicked:(id)sender
{
    [self.view endEditing:YES];
    //BOOL validate = [self validate];
    //if(validate) {
       // [self sendRequest];
    //}
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [[self navigationItem] setBackBarButtonItem:backButton];
//    [backButton release];
    [self sendRequest];
    ThankyouViewController *viewController = [[ThankyouViewController alloc] initWithNibName:@"ThankyouViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController autorelease];
}

- (IBAction)btnUploadPress:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:AppName
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take view or photo",@"Choose view or photo", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Choose view or photo"]) {
        
        
        ipc=[[UIImagePickerController alloc] init];
        ipc.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,kUTTypeMovie, nil];
        ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        ipc.delegate=self;
        ipc.allowsEditing = YES;
        [ipc setVideoMaximumDuration:180];
        [self presentViewController:ipc animated:YES completion:nil];
    }
    
    if([buttonTitle isEqualToString:@"Take view or photo"]) {
        
        
        ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie,kUTTypeImage, nil];
        ipc.delegate=self;
        ipc.allowsEditing = YES;
        [self presentViewController:ipc animated:YES completion:nil];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
        [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma UITEXTFIELD delegate methods

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        uploadedImage.image  = image;
        uploadedImage.hidden = NO;
        
        btnUpload1.hidden = YES;
        btnUpload.hidden = NO;
        
       // image = [AppUtility compressImage:image];
        
        NSData *imgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)];
        
       // int imageSize = imgData.length;
        
      //  NSString *fileSize = [AppUtility getFileSize:imageSize FileType:ATTACH_TYPE_IMAGE];
        
      //  if([fileSize length] > 0) {
          //  [self btnSendMultiMediaMessage:image MediaType:ATTACH_TYPE_IMAGE FileSize:fileSize];
      //  }
    }
    else if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        
//        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
//        NSLog(@"%@",imageURL);
//        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
//        {
//            CGImageRef iref = [myasset thumbnail];
//            if (iref) {
//                UIImage *theThumbnail = [UIImage imageWithCGImage:iref];
//                [[self photo] setImage:theThumbnail];
//                
//            }
//        };
//        
//        
//        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
//        {
//            NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
//        };
//        
//        if(imageURL)
//        {
//            ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
//            [assetslibrary assetForURL:imageURL
//                           resultBlock:resultblock
//                          failureBlock:failureblock];
//        }
        
        
        NSURL *videoUrl = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [videoUrl path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            
            NSString *url = [info objectForKey:UIImagePickerControllerMediaURL];
            
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;
            
            CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
            uploadedImage.image = thumb;
            CGImageRelease(image);
            [gen release];
            
            uploadedImage.hidden = NO;
            
            btnUpload1.hidden = YES;
            btnUpload.hidden = NO;
            
           // [self btnSendMultiMediaMessage:url MediaType:ATTACH_TYPE_VIDEO FileSize:@"10"]; // size is passed 10
            
        }
        else {
           // [AppUtility showAlertWithMsg:[AppUtility getLocalizedText:@"ALERT_MSG_ERROR_VIDEO_SELECT"]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField == txtReporterType) {
        [self showReporterType:textField];
        return NO;
    }
    else
        return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    sender.delegate = self;
}

- (void)dealloc {
    [btnUpload release];
    [uploadedImage release];
    [btnUpload1 release];
    [super dealloc];
}
@end
