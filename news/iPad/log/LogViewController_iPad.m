    //
//  LogViewController_iPad.m
//  news
//
//  Created by Perry Xiong on 7/7/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "LogViewController_iPad.h"


@implementation LogViewController_iPad

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait 
		|| toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		/*
		_parentView.frame = CGRectMake(0, 0, 320, 416);
		_imageView.frame = _parentView.frame;
		_backControl.frame = _parentView.frame;
		_logoImageView.frame = CGRectMake(0, 357, 320, 59);
		_logoImageView.image = [UIImage imageNamed:@"image015_640.png"];
		_promptLabel.frame = CGRectMake(10, 22, 300, 21);
		_userNameTextField.frame = CGRectMake(10, 52, 300, 38);
		_userNameTextField.background = [UIImage imageNamed:@"textFieldBorder_300_38.png"];
		_passwordTextField.frame = CGRectMake(10, 116, 300, 38);
		_passwordTextField.background = [UIImage imageNamed:@"textFieldBorder_300_38.png"];
		_forgotUserNameOrPasswordLabel.frame = CGRectMake(20, 235, 280, 21);
		_becomeAStylesightSubscriberLabel.frame = CGRectMake(20, 285, 280, 42);
		 */
	}else {
		/*
		_parentView.frame = CGRectMake(0, 0, 480, 268);
		_imageView.frame = _parentView.frame;
		_backControl.frame = _parentView.frame;
		_logoImageView.frame = CGRectMake(0, 225, 480, 43);
		_logoImageView.image = [UIImage imageNamed:@"image015_960.png"];
		_promptLabel.frame = CGRectMake(10, 12, 460, 21);
		_userNameTextField.frame = CGRectMake(10, 39, 460, 38);
		_userNameTextField.background = [UIImage imageNamed:@"textFieldBorder_460_38.png"];
		_passwordTextField.frame = CGRectMake(10, 85, 460, 38);
		_passwordTextField.background = [UIImage imageNamed:@"textFieldBorder_460_38.png"];
		_forgotUserNameOrPasswordLabel.frame = CGRectMake(20, 150, 440, 21);
		_becomeAStylesightSubscriberLabel.frame = CGRectMake(20, 187, 440, 21);
		*/
		if ([_passwordTextField isFirstResponder]) {
			CGFloat offsetY = _userNameTextField.frame.origin.y - _passwordTextField.frame.origin.y;
			CGRect rect = _parentView.frame;
			rect.origin.y = offsetY;
			_parentView.frame = rect;
		}
	}
	
	
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
}


- (void)dealloc {
    [super dealloc];
}

@end
