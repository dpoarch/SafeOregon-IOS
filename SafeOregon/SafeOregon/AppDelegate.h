//
//  AppDelegate.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "etmResponse.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Reachability.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    NSString *path;
    NSFileManager *fileManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (nonatomic, retain) NSString *strLanguage;
@property (nonatomic, retain) NSString *strApplicationName;
@property (nonatomic, retain)  NSMutableDictionary *dictLabel;
@property (nonatomic, retain) NSString *strStatePickerTitle;
@property (nonatomic, retain) NSString *strTimePickerTitle;
@property (nonatomic, retain) NSString *strIncedentPickerTitle;


-(NSString *)getValueForLabelWithId:(NSString *) labelId;
-(void) showAlertWithMessage:(NSString *) message andTitle:(NSString *) title;
-(void)sendRequest;
+(CGSize)getTextHeight:(NSString*)text fontName:(NSString*)fontName fontSize:(CGFloat)fontSize width:(CGFloat)width;
-(UIButton *)setNavigationButton:(NSString *)strTitle;
-(void)JSONresponse1:(NSArray *)aryResponse;
-(void)zipFileRequest;
-(void)SelectEnglishLan;
-(CGFloat) webViewHeight:(NSString *)str withFont:(UIFont*)font webViewWidth:(float)width;
-(BOOL)isInternetConnection;

@end
