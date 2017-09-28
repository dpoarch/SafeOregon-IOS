//
//  SettingViewController.m
//  Sprigeo
//
//  Created by iphone1 on 03/07/13.
//
//

#import "SettingViewController.h"

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [picker setHidden:YES];
    
    selectedLang = [NSUserDefaults standardUserDefaults];
    
    dictLang = [[NSMutableDictionary alloc] init];
    
    if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"DownloadFilesFirst"]) {
        [self sendRequestForLanList];
    }else{
        dictLang = [[NSUserDefaults standardUserDefaults] valueForKey:@"DictLang"];
        [self ShowPicker:NO];
    }
    
//    if([[appDelegate getValueForLabelWithId:@"TITLE_SETTING"] length] > 0 && [appDelegate getValueForLabelWithId:@"TITLE_SETTING"])
//    {
        self.title = [appDelegate getValueForLabelWithId:@"TITLE_SETTING"];
//    }
//    else{
//        self.title = @"Settings";
        [self setDefaultEnglish];
   // }
   
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    NSString *doneButton;
  //  if ([[appDelegate getValueForLabelWithId:@"BTN_DONE"] length] > 0 && [appDelegate getValueForLabelWithId:@"BTN_DONE"]) {
        doneButton = [appDelegate getValueForLabelWithId:@"BTN_DONE"];
//    }else
//        doneButton =@"Done";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:doneButton style:UIBarButtonItemStyleBordered target:self action:@selector(btnDoneClicked)];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    NSString *lblSelectLan;
    
//    if ([[appDelegate getValueForLabelWithId:@"LBL_SELECT_LANGUAGE"] length] > 0 && [appDelegate getValueForLabelWithId:@"LBL_SELECT_LANGUAGE"]) {
        lblSelectLan = [appDelegate getValueForLabelWithId:@"LBL_SELECT_LANGUAGE"];
//    }else
//        lblSelectLan =@"Please select your prefered language";
    
    lblSelect.text = lblSelectLan;
}

-(void)viewWillAppear:(BOOL)animated
{
//    if ([appDelegate getValueForLabelWithId:@"BTN_CHECKUPDATE"] && [[appDelegate getValueForLabelWithId:@"BTN_CHECKUPDATE"]  length] > 0) {
        [btnUpdate setTitle:[appDelegate getValueForLabelWithId:@"BTN_CHECKUPDATE"] forState:UIControlStateNormal];
//    }else{
//        [btnUpdate setTitle:@"Check for update" forState:UIControlStateNormal];
//    }
}

-(void)setDefaultEnglish {
    
    [selectedLang setObject:@"en" forKey:KEY_LANG];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
    NSString *strTemp = [NSString stringWithFormat:@"%@/sprigeo_en.json",path];
    NSString *tempString = [NSString stringWithContentsOfFile:strTemp encoding:NSUTF8StringEncoding error:nil];
    
    //SBJsonParser *jsonDecoder = [[SBJsonParser alloc]init];
    //id aryResponse = [jsonDecoder objectWithString:tempString];
    //[appDelegate JSONresponse1:aryResponse];
    
    NSData *jsonData = [tempString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSError *error = nil;
    id objResponse = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
    
    if (!objResponse) {
        NSLog(@"setDefaultEnglish > Error parsing JSON: %@", error);
    }
    else {
        ZDebug(@"setDefaultEnglish > Response: %@", objResponse);
        
        [appDelegate JSONresponse1:objResponse];
    }
}

-(void)sendRequestForLanList
{
    if(![appDelegate isInternetConnection]){
        [dictLang setObject:@"en" forKey:@"English"];
        [[NSUserDefaults standardUserDefaults] setValue:dictLang forKey:@"DictLang"];
        ZDebug(@"%@", dictLang);
        
        [self ShowPicker:NO];
    }
    else {
        NSString *strURL = getLanguagesURL;
        etmResponse *responseObj = [[etmResponse alloc] init];
        responseObj._delegate = self;
        [responseObj sendRequest:strURL withPostData:nil];
        [responseObj release];
    }
    
}

-(void)JSONresponse:(NSMutableDictionary *)aryResponse
{
    
    dictLang =aryResponse;
    [dictLang setObject:@"en" forKey:@"English"];
    [[NSUserDefaults standardUserDefaults] setValue:dictLang forKey:@"DictLang"];
    
    [self ShowPicker:YES];
    
}

-(void)ShowPicker:(BOOL)isShowAlert {
    
    @try {
        arrAllKeys =[[NSMutableArray alloc]initWithArray:[dictLang allKeys]];
        arrAllvalues =[[NSMutableArray alloc]initWithArray:[dictLang allValues]];
        
        [picker setHidden:false];
        
        [picker reloadAllComponents];
        NSInteger indexx = 0;
        
        if ([selectedLang valueForKey:KEY_LANG] && [[selectedLang valueForKey:KEY_LANG] length] > 0)
        {
            for (int i =0; i < [arrAllvalues count]; i++) {
                if ([[selectedLang valueForKey:KEY_LANG] isEqualToString:[arrAllvalues objectAtIndex:i]]) {
                    indexx = i;
                }
            }
        }
        selecterdIndex = indexx;
        [selectedLang setObject:[arrAllvalues objectAtIndex:indexx] forKey:KEY_LANG];
        [picker selectRow:indexx inComponent:0 animated:NO];
        [progressView hide:YES];
    }
    @catch (NSException *exception) {
        ZDebug(@"ShowPicker  exception =%@",exception);
    }
    
    if(isShowAlert) {
        NSString *strMsg = [appDelegate getValueForLabelWithId:@"LBL_UPADTE_CONFIRM"];
        
        if([strMsg length] == 0) {
            strMsg = @"Application update successfully";
        }
        
        [appDelegate showAlertWithMessage:strMsg andTitle:AppName];
    }
    
}

-(void)btnBackClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnDoneClicked
{

    [selectedLang setObject:[arrAllvalues objectAtIndex:selecterdIndex] forKey:KEY_LANG];
    appDelegate.strLanguage = selectedLanguage;
    [self progressView123];
    [progressView show:YES];
    
    ZDebug(@"en = %@", appDelegate.strLanguage);
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2];
}

-(void)loadData{
    [appDelegate sendRequest];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)progressView123
{
    [progressView show:YES];
}

- (IBAction)btnChkForUpdateClicked:(id)sender
{
    if([appDelegate isInternetConnection]) {
        [progressView show:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DownloadFilesFirst"];
        [self sendRequestForLanList];
    }
    else {
        [appDelegate showAlertWithMessage:[appDelegate getValueForLabelWithId:@"ALT_NETWORK"] andTitle:AppName];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selecterdIndex = row;
    selectedLanguage = [arrAllvalues objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrAllKeys count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[arrAllKeys objectAtIndex:row]];
}

- (void)dealloc {
    [lblSelect release];
    [btnUpdate release];
    [super dealloc];
}

- (void)viewDidUnload {
    [lblSelect release];
    lblSelect = nil;
    [btnUpdate release];
    btnUpdate = nil;
    [super viewDidUnload];
}

@end
