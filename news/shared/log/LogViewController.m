//
//  LogViewController.m
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogViewController.h"
#import "Debug.h"
#import "CommonDef.h"
#import "NSString+MD5.h"
#import "Alerts.h"

@implementation LogViewController
@synthesize delegate = _delegate;
@synthesize parentView = _parentView;
@synthesize imageView = _imageView;
@synthesize logoImageView = _logoImageView;
@synthesize userNameTextFieldBackImage = _userNameTextFieldBackImage;
@synthesize passwordTextFieldBackImage = _passwordTextFieldBackImage;
@synthesize userNameTextField = _userNameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize promptLabel = _promptLabel;
@synthesize forgotUserNameOrPasswordLabel = _forgotUserNameOrPasswordLabel;
@synthesize becomeAStylesightSubscriberLabel = _becomeAStylesightSubscriberLabel;
@synthesize request = _request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_request clearDelegatesAndCancel];
	[_request release];
    
	[_userNameTextField release];
	[_passwordTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    // Do any additional setup after loading the view from its nib.
	self.title = @"Please Log In";
/*	
	self.userNameTextField.text = @"cntiny@qq.com";
	self.passwordTextField.text = @"howaYo";
 */
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.userNameTextField = nil;
	self.passwordTextField = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma Private Methods
- (void) login{
	[_delegate logBegan];
 
    NSString *userName = self.userNameTextField.text;//@"cntiny@qq.com";
    NSString *password = self.passwordTextField.text;//@"howaYo";
    /*
    NSString *requestString = [NSString stringWithFormat:@"%@%@?username=%@&password=%@",kServerURL,@"login",userName,password];
    LOG(requestString);
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    [self.request setUseCookiePersistence:YES];
    [self.request setUserInfo:nil];
    [self.request setRequestMethod:@"POST"];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
*/

    NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,@"login"];
    NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:userName forKey:@"username"];
    [dic setValue:password forKey:@"password"];
    NSString *ss = [dic JSONRepresentation];
    
    self.request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestString]];
    [self.request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [self.request addRequestHeader:@"Content-Type" value:@"application/json"];
    [self.request setRequestMethod:@"POST"];
    //[self.request buildPostBody];
    [self.request appendPostData:[ss dataUsingEncoding:NSUTF8StringEncoding]];
    [self.request setUseCookiePersistence:YES];
    [self.request setUserInfo:nil];    
    [self.request setDelegate:self];
    [self.request startAsynchronous];
    
}

/*
- (void) onTimer{
	[self close];
}

*/

#pragma IBAction Methods
- (IBAction) forgotUserNameOrPassword{
	TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"Please enter your email address:" message:@"Your username and new password will be sent to you." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	alert.style = TSAlertViewStyleInput;
	alert.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
	[alert show];
	[alert release];
}


- (IBAction) becomeAStylesightSubscriber{
}


- (IBAction) backControlTapped{
	if ([_userNameTextField canResignFirstResponder]) {
		[_userNameTextField resignFirstResponder];
	}
	
	if ([_passwordTextField canResignFirstResponder]) {
		[_passwordTextField resignFirstResponder];
	}
}

- (IBAction) resetServer{
	kServerURL = @"http://www.stylesight.com/news/m/";
}
#pragma mark <UITextFieldDelegate> Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	if (isPad/*[UIDevice currentDevice].model == @"iPad"*/) {
		
	}else {
		if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft 
			|| self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			//keep textField above keyboard		
			if (textField == _passwordTextField) {
				CGFloat offsetY = _userNameTextField.frame.origin.y - _passwordTextField.frame.origin.y;
				[UIView animateWithDuration:0.3
								 animations:^{
									 CGRect rect = _parentView.frame;
									 rect.origin.y = offsetY;
									 _parentView.frame = rect;
								 }
								 completion:^(BOOL finished){
								 }];
			}else {
				CGRect rect = _parentView.frame;
				if (rect.origin.y != 0) {
					[UIView animateWithDuration:0.3
									 animations:^{
										 CGRect nrect = _parentView.frame;
										 nrect.origin.y = 0;
										 _parentView.frame = nrect;
									 }
									 completion:^(BOOL finished){
									 }];
				}
			}
			
			
		}
	}

	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField == _userNameTextField) {
		[_passwordTextField becomeFirstResponder];
	}else {
		[textField resignFirstResponder];
		[self login];
	}	
	
	return YES;	
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	
}



#pragma <ASIHttpRequestDelegate> Methods
- (void)requestStarted:(ASIHTTPRequest *)request{
	[ActivityIndicatorView showActivityIndicatorViewInParentView:self.navigationController.view];
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader{
}

- (void)requestFinished:(ASIHTTPRequest *)request{
	[ActivityIndicatorView hideActivityIndicatorView];
	
    int statusCode = [request responseStatusCode];
    if (chttpStatusCodeOK == statusCode) {
		NSDictionary *userInfo = request.userInfo;
		if (userInfo) {
			NSDictionary *dic = [[request responseString] JSONValue];
			BOOL status = [[dic objectForKey:@"success"] boolValue];
			if (status) {
				TSAlertView *alert = [[TSAlertView alloc] initWithTitle:nil message:@"Your new password has been sent to your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}else {
				/*
				TSAlertView *alert = [[TSAlertView alloc] initWithTitle:@"Please enter a valid e-mail address:" message:@"Your username and new password will be sent to you." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
				alert.style = TSAlertViewStyleInput;
				alert.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
				[alert show];
				[alert release];
				 */
				TSAlertView *alert = [[TSAlertView alloc] initWithTitle:nil message:@"Please enter a valid e-mail address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}else {
			NSDictionary *dic = [[request responseString] JSONValue];
			BOOL status = [[dic objectForKey:@"success"] boolValue];
			if (status) {
				cAdmin = [[dic objectForKey:@"dev_user"] boolValue];
				
				[_delegate logSucceededWithUsername:self.userNameTextField.text password:self.passwordTextField.text];
			}else {
				showErrorDlg1(@"Login failed",@"User doesn't exist or password is wrong");
			}
		}

       
    }else{
        showStatusDlg(request);
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
	[ActivityIndicatorView hideActivityIndicatorView];  

    showErrorDlg([request error]);
}

#pragma mark <TSAlertViewDelegate> Methods
- (void)alertView:(TSAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	LOG(@"BUTTON INDEX:%d",buttonIndex);
	switch (buttonIndex) {
		case 1:   //ok
		{			
			NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,@"forgotLogin"];
			
			NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
			[dic setValue:alertView.inputTextField.text forKey:@"email"];
			NSString *ss = [dic JSONRepresentation];
			
			//get categories
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"forgotLogin" forKey:@"userKey"];
			self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestString]];
			[self.request appendPostData:[ss dataUsingEncoding:NSUTF8StringEncoding]];
			[self.request setUseCookiePersistence:YES];
			[self.request setUserInfo:userInfo];    
			[self.request setDelegate:self];
			[self.request startAsynchronous];
		}
			break;
		default:
			break;
	}
}

@end
