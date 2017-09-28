//
//  etmResponseClass.m
//  DNW
//
//  Created by Krunal Doshi on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "etmResponse.h"
#import "Reachability.h"

@implementation etmResponse
@synthesize _delegate = delegate;

+(id)init
{
	return self;
}
-(void)sendRequest:(NSString*)strrequest
{
    if(!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithWindow:appDelegate.window];
        [appDelegate.window addSubview:HUD];
        HUD.dimBackground = YES;
    }
    
    strrequest = [strrequest stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    jsonRequest = [[JSONRequest alloc] init];
    jsonRequest.delegate = self;
    [jsonRequest sendRequest:strrequest];
    
    if(!HUD.isHidden)
        [HUD show:YES];
}

-(void)sendRequest:(NSString*)strrequest withPostData:(NSString*)requestData
{
    if(!HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithWindow:appDelegate.window];
        [appDelegate.window addSubview:HUD];
        [appDelegate.window bringSubviewToFront:HUD];
        HUD.dimBackground = YES;
    }
    
    if(blnIsRequesting)
        [self cancelRequest];
    
    strrequest = [strrequest stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *reqData = [requestData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",strrequest]]] autorelease];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: reqData];
    
    theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    ZDebug(@"request==%@", request);
   
    [theConnection start];
    
    if (theConnection)
    {
        blnIsRequesting = YES;
    }
    if(!HUD.isHidden)
        [HUD show:YES];
    
}

-(void)JSONresponse:(NSMutableData*)receivedJSONData {
    [HUD hide:YES];
    
    /*
    NSString *tempString = [[NSString alloc] initWithData:receivedJSONData encoding:NSUTF8StringEncoding];
    SBJsonParser *jsonDecoder = [[SBJsonParser alloc]init];
    id aryResponse = [jsonDecoder objectWithString:tempString];
    */
    
    
    NSError *error = nil;
    id objResponse = [NSJSONSerialization JSONObjectWithData:receivedJSONData options: NSJSONReadingMutableContainers error: &error];
    
    if (!objResponse) {
        NSLog(@"Error parsing JSON: %@", error);
    }
    else {
        ZDebug(@"JSONresponse > Response: %@", objResponse);
        
        if([delegate respondsToSelector:@selector(JSONresponse:)])
            [delegate JSONresponse:objResponse];
    }
}

-(void)JSONerror:(JSONRequest *)jsonRequest
{
    [HUD hide:YES];
}

#pragma mark -
#pragma mark NSURLConnection
#pragma mark

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = [[NSMutableData alloc]init];
	[receivedData setLength:0];
    NSLog(@"IsResponse");
    //isRequesting = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection release];			// release the connection, and the data object
    [receivedData release];			// receivedData is declared as a method instance elsewhere
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[appDelegate getValueForLabelWithId:@"ALT_NETWORK"] delegate:self cancelButtonTitle:[appDelegate getValueForLabelWithId:@"BTN_OK"] otherButtonTitles:nil,nil];
	[alert show];
	[alert release];
    blnIsRequesting = NO;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self JSONresponse:receivedData];
	
	//[theConnection release];

	//[receivedData release];

    blnIsRequesting = NO;
}


#pragma mark -
#pragma mark Exception
#pragma mark

-(void)showErrorMessage:(NSString*)title :(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:[appDelegate getValueForLabelWithId:@"BTN_OK"] otherButtonTitles:nil,nil];
	[alert show];
	[alert release];
}

-(void)cancelRequest{
    //    if(isRequesting){
    NSLog(@"Cancel Request");
   // [theConnection cancel];
   //theConnection = nil;
   // [theConnection release];
    //[receivedData release];
    blnIsRequesting = NO;
    [HUD hide:YES];
    //    }
}


@end
