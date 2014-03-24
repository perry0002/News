//
//  ShareArticleViewController.m
//  news
//
//  Created by Perry Xiong on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareArticleViewController.h"
#import <MessageUI/MessageUI.h>
#import "CommonDef.h"

@interface ShareArticleViewController()
@property (nonatomic, retain) ASIHTTPRequest *request;
@end


@implementation ShareArticleViewController
@synthesize promptLabel = _promptLabel;
@synthesize emailAddressField = _emailAddressField;
@synthesize request = _request;

#pragma Private Methods
- (void) email{
    //check address valid
    //...
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kServerURL]];
	self.request.delegate = self;
	[self.request setRequestMethod:@"POST"];
	
	[self.request startAsynchronous];
    
    /*
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:@"Share article"];
            
            NSString *emailString = self.emailAddressField.text;
            NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@",; "];
            NSArray *emailAddresses =  [emailString componentsSeparatedByCharactersInSet:cset];
            //check address valid
            //...
            // Set up recipients
            NSArray *toRecipients = emailAddresses; 
            NSArray *ccRecipients = nil; 
            NSArray *bccRecipients = nil; 
            
            [picker setToRecipients:toRecipients];
            [picker setCcRecipients:ccRecipients];	
            [picker setBccRecipients:bccRecipients];
         
            // Fill out the email body text
            NSString *emailBody = @"It is raining in sunny California!";
            [picker setMessageBody:emailBody isHTML:NO];
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
		}
		else
		{
		}
	}
	else
	{

	}
     */
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    self.title = @"Share Article";
    //navigation bar style
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //right button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_promptLabel release];
    [_emailAddressField release];
    [super dealloc];
}

- (void) viewDidAppear:(BOOL)animated{
    [self.emailAddressField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    CGRect labelRect = self.promptLabel.frame;
    CGRect textFieldRect = self.emailAddressField.frame;
    
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait 
		|| toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {        
		labelRect.origin.y = 50;
        self.promptLabel.frame = labelRect;
        
        textFieldRect.origin.y = 105;
        self.emailAddressField.frame = textFieldRect;
	}else {
		labelRect.origin.y = 15;
        self.promptLabel.frame = labelRect;
        
        textFieldRect.origin.y = 50;
        self.emailAddressField.frame = textFieldRect;
	}	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self email];
	
	return YES;	
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	
}

@end
