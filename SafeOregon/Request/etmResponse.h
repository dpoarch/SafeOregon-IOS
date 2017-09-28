//
//  etmResponseClass.h
//  DNW
//
//  Created by Krunal Doshi on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRequest.h"
#import "MBProgressHUD.h"

@protocol JSONResponseDelegate <NSObject>
-(void)JSONresponse:(NSArray *)aryResponse;
@end

@interface etmResponse : NSObject<JSONRequestDelegate,JSONResponseDelegate>
{
    JSONRequest *jsonRequest;
    MBProgressHUD *HUD;
    id<JSONResponseDelegate> delegate;
    NSMutableData *receivedData;
    NSURLConnection *theConnection;

}

@property (assign) id<JSONResponseDelegate> _delegate;
+(id)init;
-(void)sendRequest:(NSString*)strrequest;
-(void)sendRequest:(NSString*)strrequest withPostData:(NSString*)requestData;
-(void)cancelRequest;
@end
