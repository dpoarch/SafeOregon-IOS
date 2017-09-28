
#import <Foundation/Foundation.h>
@class JSONRequest;
@protocol JSONRequestDelegate <NSObject>

-(void)JSONresponse:(NSMutableData*)receivedJSONData;
-(void)JSONerror:(JSONRequest *)jsonRequest;

@end

@interface JSONRequest : NSObject <JSONRequestDelegate>
{	
	NSMutableData *receivedData;
    NSURLConnection *theConnection;
	
	id <JSONRequestDelegate> _delegate;
    BOOL isRequesting;
}

@property (assign) id<JSONRequestDelegate> delegate;

+(id)init;

-(void)sendRequest:(NSString*)strrequest;
-(void)showErrorMessage:(NSString*)title:(NSString*)message;
-(void)cancelRequest;

@end
