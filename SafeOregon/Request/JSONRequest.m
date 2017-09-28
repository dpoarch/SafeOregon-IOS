
#import "JSONRequest.h"


@implementation JSONRequest

@synthesize delegate;


+(id)init
{
	return self;
}

-(void)sendRequest:(NSString*)strrequest
{	
	NSMutableString *url=[[NSMutableString alloc] init];
	[url appendString:strrequest];	
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if (theConnection)
		receivedData = [[NSMutableData data] retain];
	else
		NSLog(@"Connection fail....");
    
    isRequesting = YES;
}


#pragma mark -
#pragma mark NSURLConnection
#pragma mark 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
    if([delegate respondsToSelector:@selector(JSONerror:)])
		[delegate JSONerror:self];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSString *str = [[NSString alloc]initWithData:receivedData encoding:NSASCIIStringEncoding];
    //if([str isKindOfClass:[NSString class]]) 
        [self JSONresponse:receivedData];
	
	[connection release];
	[receivedData release];
} 


-(void)JSONresponse:(NSMutableData*)receivedJSONData;
{
	if([delegate respondsToSelector:@selector(JSONresponse:)])
		[delegate JSONresponse:receivedJSONData];
	
}

#pragma mark -
#pragma mark Exception
#pragma mark 

-(void)showErrorMessage:(NSString*)title:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
	[alert show];
	[alert release];    
}

-(void)cancelRequest{
//    if(isRequesting){
        [theConnection cancel];
        [theConnection release];
        [receivedData release];
//    }
}

@end
