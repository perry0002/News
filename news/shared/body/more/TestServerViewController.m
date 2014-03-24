//
//  TestServerViewController.m
//  news
//
//  Created by Perry Xiong on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestServerViewController.h"

@implementation TestServerViewController
@synthesize textField = _textField;



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
    self.title = @"Enter Testing Server";
	self.textField.text = kServerURL;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void) viewDidAppear:(BOOL)animated{
	[self.textField becomeFirstResponder];
}

#pragma mark <UITextFieldDelegate> Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
    if(![textField.text isEqualToString:kServerURL]){
        //log out
        NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, kLogout];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.delegate = self;
        [request startSynchronous];
        NSDictionary *result = [[request responseString] JSONValue];
        if (nil != result) {
            if ([result objectForKey:@"success"]) {
                //log out successfully
                [[NSNotificationCenter defaultCenter] postNotificationName:kLogOutNotification object:nil];
                
                [textField.text retain];
                [kServerURL release];
                kServerURL = textField.text;
            }
        }
    }
	
	return YES;	
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	
}

@end
