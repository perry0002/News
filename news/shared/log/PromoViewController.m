//
//  WaitingViewController.m
//  news
//
//  Created by Perry Xiong on 7/8/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "PromoViewController.h"
#import "Alerts.h"
#import "CommonDef.h"
#import "Debug.h"

@interface PromoViewController ()
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSURL *link;
@property (nonatomic, copy) NSString *newURLString;

- (void) saveNewURLToFile:(NSString *)urlString;
- (NSString *) readOldURLFromFile;
- (void) deleteOldURLFile;
@end
    

@implementation PromoViewController
@synthesize delegate = _delegate;
@synthesize request = _request;
@synthesize imageView = _imageView;
@synthesize link = _link;
@synthesize newURLString = _newURLString;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //show old promo image
    NSString *oldPromoString = [self readOldURLFromFile];
    if ([[EGOImageLoader sharedImageLoader] hasLoadedImageURL:[NSURL URLWithString:oldPromoString]]) {
        UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:[NSURL URLWithString:oldPromoString] shouldLoadWithObserver:self];
        if (image) {
            self.imageView.image = image;
        }
    }else {
		[self deleteOldURLFile];
	}

   
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kServerURL,kGetPromo];
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];    
    [self.request setUserInfo:nil];
    [self.request setDelegate:self];
    [self.request setRequestMethod:@"POST"];  
    [self.request startAsynchronous];    
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[EGOImageLoader sharedImageLoader] removeObserver:self];
	[_request clearDelegatesAndCancel];
	self.request = nil;
	self.imageView = nil;
	self.link = nil;
}


- (void)dealloc {
    [[EGOImageLoader sharedImageLoader] removeObserver:self];
	[_request clearDelegatesAndCancel];
	[_request release];
	[_imageView release];
	[_link release];
    [super dealloc];
}

- (IBAction) close{
	[_delegate promoViewClosed];
}


- (void) saveNewURLToFile:(NSString *)urlString{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"promoImage"];
     NSError *error = nil;
    [urlString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (NSString *) readOldURLFromFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"promoImage"];
    
    NSError *error = nil;
    NSString *urlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];;
    
    return urlString;
}

- (void) deleteOldURLFile{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"promoImage"];
	
	NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:&error];
}
#pragma UITouch Methods
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] openURL:self.link];
}

#pragma <ASIHttpRequestDelegate> Methods
- (void)requestStarted:(ASIHTTPRequest *)request{
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader{
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([request responseStatusCode] == chttpStatusCodeOK) {
        NSString *jsonString = [request responseString];
        NSObject *obj = [jsonString JSONValue];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //status
            NSDictionary *promoDic = (NSDictionary *)obj;
            if (YES == [[promoDic objectForKey:@"success"] boolValue]) {
                //get image url
                self.newURLString = [promoDic objectForKey:@"image"];                
                NSString *oldURL = [self readOldURLFromFile];
                if ([self.newURLString isEqualToString:oldURL]) {
                    //do nothing
                }else {
                    //image request
                    NSURL *imageURL = [NSURL URLWithString:self.newURLString];
                    UIImage *image = [[EGOImageLoader sharedImageLoader] imageForURL:imageURL shouldLoadWithObserver:self];
                    if (image) {
                        self.imageView.image = image;
                    }
                }
                
                
                //get link url
                self.link = [NSURL URLWithString:[promoDic objectForKey:@"link"]];
            }
        }     
        
    }else{
        showStatusDlg(request);
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    showErrorDlg([request error]);
}

- (void) imageDidLoad:(UIImage *)image{
    self.imageView.image = image;
}

- (void) imageLoadFailedWithError:(NSError *)error{
    
}

#pragma <EGOImageLoaderObserver> Methods
- (void)imageLoaderDidLoad:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIImage *image = [userInfo objectForKey:@"image"];
    self.imageView.image = image;
    
    //delete old promo image
    NSString *oldURL = [self readOldURLFromFile];
    [[EGOImageLoader sharedImageLoader] removeImageForURL:[NSURL URLWithString:oldURL]];
	[self saveNewURLToFile:self.newURLString];
	self.newURLString = nil;
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification{
	self.newURLString = nil;
}

@end
