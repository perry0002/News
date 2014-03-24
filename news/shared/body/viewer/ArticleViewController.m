//
//  viewerViewController.m
//  news
//
//  Created by Perry Xiong on 7/8/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "ArticleViewController.h"
#import "ShareArticleViewController.h"
#import "Alerts.h"
#import "Helper.h"
#import "EGOImageLoader.h"
#import "SQLiteManager.h"

@interface ArticleViewController()
@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) UIBarButtonItem *textZoomOut;
@property (nonatomic, retain) UIBarButtonItem *textZoomIn;
@property (nonatomic, retain) UIBarButtonItem *favoriteItem;

- (NSString *)timeString;
- (NSString *)articleHtmlString;
- (NSString *)emailHtmlString;  //no title
@end

@implementation ArticleViewController
@synthesize delegate = _delegate;
@synthesize queue = _queue;
@synthesize webView = _webView;
@synthesize article = _article;
@synthesize rightButtonView = _rightButtonView;
@synthesize textZoomOut = _textZoomOut;
@synthesize textZoomIn = _textZoomIn;
@synthesize favoriteItem = _favoriteItem;
@synthesize bfavorite = _bfavorite;
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
	LOG_METHOD
    [super viewDidLoad];
	self.navigationController.navigationBar.barStyle = /*UIBarStyleBlack;//*/UIBarStyleBlackTranslucent;
	self.navigationController.toolbar.barStyle = /*UIBarStyleBlack;//*/UIBarStyleBlackTranslucent;
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController setToolbarHidden:YES animated:NO];
    self.hidesBottomBarWhenPushed = YES;
    //add notification
 
    
    //add toolbar buttonItems
    UIBarButtonItem *textZoomOut = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"article_text-"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(textZoomout)];
    
    UIBarButtonItem *textZoomIn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"article_text+"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(textZoomin)];
    self.textZoomOut = textZoomOut;
	self.textZoomIn  = textZoomIn;
	if (cFontSizeLevel == 1) {
		self.textZoomOut.enabled = NO;
	}else if (cFontSizeLevel == 6) {
		self.textZoomIn.enabled = NO;
	}
    UIBarButtonItem *email = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"article_email"] style:UIBarButtonItemStylePlain target:self action:@selector(email)];
    
	UIImage *favoriteImage = nil;
	if (!_bfavorite) {
		favoriteImage = [UIImage imageNamed:@"article_favorite_gray.png"];
	}else {
		favoriteImage = [UIImage imageNamed:@"article_favorite.png"];
	}

    UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithImage:favoriteImage style:UIBarButtonItemStylePlain target:self action:@selector(favorite)];
	/*
    if (_bfavorite) {
		favorite.enabled = NO;
	}*/
	self.favoriteItem = favorite;
    if (!cNetWorkAvailable) {
        email.enabled = NO;
        favorite.enabled = NO;
    }
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	
    NSArray *items = [NSArray arrayWithObjects:textZoomOut, space, textZoomIn, space, space, email, space, space, space, space, favorite, space, nil];
    [textZoomOut release];
    [textZoomIn release];
    [email release];
    [favorite release];
	[space release];
    [self setToolbarItems:items animated:YES];
    

	//barItems
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		backButton.frame = CGRectMake(0, 0, 50, 29);
	}else {
		backButton.frame = CGRectMake(0, 0, 50, 21);
	}

	//backButton.frame = CGRectMake(0, 0, 50, 30);
	[backButton setBackgroundImage:[UIImage imageNamed:@"article_backExit"] forState:UIControlStateNormal];
	backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
	backButton.titleEdgeInsets = UIEdgeInsetsMake(0,12,0,5);
	backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	backButton.autoresizesSubviews = YES;
	backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
	
	//right button
	CustomBFViewController *rightButtonView = [[CustomBFViewController alloc] initWithNibName:@"CustomBFViewController_iPhone" bundle:nil];
	rightButtonView.view.autoresizesSubviews = YES;
	rightButtonView.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin/*|UIViewAutoresizingFlexibleWidth*/|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	//[self addChildViewController:rightButtonView];  //if crash
    self.rightButtonView = rightButtonView;
	rightButtonView.delegate = self;
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView.view];
	rightItem.style = UIBarButtonItemStylePlain;
	CGRect rightButtonFrame = rightButtonView.view.frame;
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		rightButtonFrame.size.height = 29;
	}else {
		rightButtonFrame.size.height = 21;
	}
	self.rightButtonView.view.frame = rightButtonFrame;
	[rightButtonView release];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem release];
	
	self.queue = [ASINetworkQueue queue];
	
    [self resume];
	//add gesture recongnizer
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePTapGesture:)];
	[self.webView addGestureRecognizer:tap];
    tap.delegate = self;
	[tap release];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	CGRect rightButtonFrame = self.rightButtonView.view.frame;
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		rightButtonFrame.size.height = 21;
	}else {
		rightButtonFrame.size.height = 29;
	}
	self.rightButtonView.view.frame = rightButtonFrame;

    [self resume];
}
 
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
}


- (void) viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBar.barStyle = /*UIBarStyleBlack;//*/UIBarStyleBlackTranslucent;
	self.navigationController.toolbar.barStyle = /*UIBarStyleBlack;//*/UIBarStyleBlackTranslucent;
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];

	//
	//listSubviewsOfView(self.view.window);
	
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
    [self.queue cancelAllOperations];
	self.queue = nil;
    self.webView = nil;
    self.rightButtonView = nil;
    self.article = nil;
	self.textZoomOut = nil;
	self.textZoomIn = nil;
	self.favoriteItem = nil;
}


- (void)dealloc {
    [_queue cancelAllOperations];
	[_queue release];
	[_textZoomOut release];
	[_textZoomIn release];
	[_favoriteItem release];
	[_article release];
	[_rightButtonView release];
    [_webView release];
    [super dealloc];
}


- (void) backButtonTapped{
	//[self dismissModalViewControllerAnimated:YES];
	[_delegate ArticleViewControllerViewShouldBeDismissed:self];
}

- (void) textZoomout{
    if (cFontSizeLevel>1) {
        cFontSizeLevel -= 1;
        [self resume];
		
		if (!self.textZoomIn.enabled) {
			self.textZoomIn.enabled = YES;
		}
    }
	
	if (cFontSizeLevel == 1) {
		self.textZoomOut.enabled = NO;
	}
   
}

- (void) textZoomin{
    if (cFontSizeLevel<6) {
        cFontSizeLevel += 1;
        [self resume];
		if (!self.textZoomOut.enabled) {
			self.textZoomOut.enabled = YES;
		}
    }
	
	if (cFontSizeLevel == 6) {
		self.textZoomIn.enabled = NO;
	}
    
}

- (void) email{
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:[self.article objectForKey:@"title"]];
            
            //NSString *emailString = self.emailAddressField.text;
            //NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@",; "];
            //NSArray *emailAddresses =  [emailString componentsSeparatedByCharactersInSet:cset];
            //check address valid
            //...
            // Set up recipients
            NSArray *toRecipients = nil; 
            NSArray *ccRecipients = nil; 
            NSArray *bccRecipients = nil; 
            
            [picker setToRecipients:toRecipients];
            [picker setCcRecipients:ccRecipients];	
            [picker setBccRecipients:bccRecipients];
			
            
            //fill out image
            //NSString *path = pathForData([NSURL URLWithString:[self.article objectForKey:kArticleThumb]]);
            //NSData *myData = [NSData dataWithContentsOfFile:path];
            //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"thumb"];
            // Fill out the email body text
            NSString *body = [self emailHtmlString];//[self.article objectForKey:kArticleBody];
            NSString *emailBody = body;
            [picker setMessageBody:emailBody isHTML:YES];
            
            [self presentModalViewController:picker animated:YES];
            picker.topViewController.title = @"New Message";
            [picker release];
		}
		else
		{
		}
	}
	else
	{
		
	}
}

- (void) favorite{
	/*
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil 
													delegate:self 
										   cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:@"Set Favorite"
										   otherButtonTitles:nil];
	[as showInView:self.navigationController.view];
	[as release];
	 */
	//begin request
	NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,kSetFavorites];
	NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
	[dic setValue:[self.article objectForKey:kID] forKey:@"article_id"];
	if (_bfavorite) {
		[dic setValue:[NSNumber numberWithInt:0] forKey:@"favorite"];
	}else {
		[dic setValue:[NSNumber numberWithInt:1] forKey:@"favorite"];
	}

	
	LOG(@"%@", requestString);
	
	NSString *ss = [dic JSONRepresentation];
	LOG(@"%@",ss);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestString]];
	[request setRequestMethod:@"POST"];
	[request appendPostData:[ss dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSDictionary *userInfo = nil;
	if (_bfavorite) {
		userInfo = [NSDictionary dictionaryWithObject:kRemoveFavoriteNotification forKey:@"tag"];
	}else {
		userInfo = [NSDictionary dictionaryWithObject:kSetFavoriteNotification forKey:@"tag"];
	}

	            
	[request setUserInfo:userInfo];    
	[request setDelegate:self];
	[self.queue addOperation:request];
	[self.queue go];
}


- (NSString *)timeString{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[self.article objectForKey:kArticleDate] integerValue]];
	return [NSString stringWithFormat:@"Posted:%@",stringForDate1(date)];
}

- (NSString *)articleHtmlString{
	NSError *error = nil;
	NSString *fileName = [NSString stringWithFormat:@"article%d",cFontSizeLevel];
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
	NSString *templateString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

	
	NSString *articleTitle = [self.article objectForKey:kArticleTitle];
	NSString *articleThumb = [self.article objectForKey:kArticleThumb];
	NSString *localPath = pathForData([NSURL URLWithString:articleThumb]);
	if (nil == localPath) {
		localPath = articleThumb;
	}
	NSString *articleTime  = [self timeString];
	NSString *articleBody  = [self.article objectForKey:kArticleBody];
     
	NSString *mString = [NSString stringWithFormat:templateString,articleTitle,localPath,articleTime,articleBody];

    return mString;
}

- (NSString *)emailHtmlString{
	NSError *error = nil;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"email" ofType:@"txt"];
	NSString *templateString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	
	NSString *articleBody  = [self.article objectForKey:kArticleBody];
	//NSString *localPath = pathForData([NSURL URLWithString:[self.article objectForKey:@"thumb"]]);
	NSString *localPath = [self.article objectForKey:@"thumb"];
	NSString *mString = [NSString stringWithFormat:templateString,localPath,articleBody];

    return mString;
}

- (void) resume{
	LOG_METHOD
    
    [self.webView loadHTMLString:[self articleHtmlString] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

#pragma mark <CustomBFViewDelegate> Methods
- (void) bfViewControllerBackButtonDown:(CustomBFViewController *)controller{
	if (self.rightButtonView.fowardEnd) {
		self.rightButtonView.fowardEnd = NO;
	}
	BOOL bfirst = [_delegate ArticleViewControllerBackButtonTapped:self];
    [self resume];
    self.rightButtonView.backEnd = bfirst;

}

- (void) bfViewControllerFowardButtonDown:(CustomBFViewController *)controller{
	if (self.rightButtonView.backEnd) {
		self.rightButtonView.backEnd = NO;
	}
	BOOL bLast = [_delegate ArticleViewControllerForwardButtonTapped:self];
    [self resume];
    self.rightButtonView.fowardEnd = bLast;
}


#pragma mark <UIGustureRecognizerDelegate> Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark <UIActionSheetDelegate> Methods
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:{
			//begin request
			NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,kSetFavorites];
			NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
			[dic setValue:[self.article objectForKey:kID] forKey:@"article_id"];
			[dic setValue:[NSNumber numberWithInt:1] forKey:@"favorite"];
			LOG(@"%@", requestString);
			
			NSString *ss = [dic JSONRepresentation];
			LOG(@"%@",ss);
			
			ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestString]];
			[request setRequestMethod:@"POST"];
			[request appendPostData:[ss dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:kSetFavoriteNotification forKey:@"tag"];            
			[request setUserInfo:userInfo];    
			[request setDelegate:self];
			[self.queue addOperation:request];
			[self.queue go];
		}
			break;
		default:
			break;
	}
}

#pragma <ASIHttpRequestDelegate> Methods
- (void)requestStarted:(ASIHTTPRequest *)request{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader{
    LOG_METHOD
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    LOG_METHOD
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    LOG(@"%@", [request responseString]);
	//LOG(@"%d", [request responseStatusCode]);
    //LOG(@"%@", [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease]);
    if ([request responseStatusCode] == chttpStatusCodeOK) {
        NSDictionary *userInfo = [request userInfo];
        NSString *tagValue = [userInfo objectForKey:@"tag"];
        if ([tagValue isEqualToString:kSetFavoriteNotification]){
            _bfavorite = YES;
			self.favoriteItem.image = [UIImage imageNamed:@"article_favorite.png"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSetFavoriteNotification object:nil];
        }else if ([tagValue isEqualToString:kRemoveFavoriteNotification]) {
			_bfavorite = NO;
			[[SQLiteManager sharedInstance] deleteFavorite:[[self.article objectForKey:kArticleId] intValue]];
			[[NSNotificationCenter defaultCenter] postNotificationName:kSetFavoriteNotification object:nil];
			self.favoriteItem.image = [UIImage imageNamed:@"article_favorite_gray.png"];
		}
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    LOG_METHOD
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) queueDidFinished{
    LOG_METHOD
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[self dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSaved:
			[self dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultSent:{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
																message:@"Article shared"
															   delegate:self 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
			
			[alertView show];
			[alertView release];
		}
			break;
		case MFMailComposeResultFailed:
			[self dismissModalViewControllerAnimated:YES];
			break;
		default:
			break;
	}
	//[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark getsture recongnizer Methods
- (void)_handlePTapGesture:(UITapGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		//
		if (self.navigationController.navigationBar.hidden) {
			[self.navigationController setNavigationBarHidden:NO animated:YES];
			[self.navigationController setToolbarHidden:NO animated:YES];
		}else {
			[self.navigationController setNavigationBarHidden:YES animated:YES];
			[self.navigationController setToolbarHidden:YES animated:YES];
		}

	}
}

@end
