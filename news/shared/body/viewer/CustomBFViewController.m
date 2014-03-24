//
//  CustomBFViewController.m
//  news
//
//  Created by Perry Xiong on 7/22/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "CustomBFViewController.h"


@implementation CustomBFViewController
@synthesize delegate = _delegate;
@synthesize backButton = _backButton;
@synthesize fowardButton = _fowardButton;
@synthesize backEnd = _backEnd;
@synthesize fowardEnd = _fowardEnd;
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
	
	//self.backEnd = YES;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

- (void) setBackEnd:(BOOL)bEnd{
	if (bEnd != _backEnd) {
		_backEnd = bEnd;
		
		if (bEnd) {
			//[self.backButton setImage:[UIImage imageNamed:@"article_back_end"] forState:UIControlStateNormal];
			self.backButton.enabled = NO;
		}else {
			//[self.backButton setImage:[UIImage imageNamed:@"article_back"] forState:UIControlStateNormal];
			self.backButton.enabled = YES;
		}
	}
}

- (BOOL) backEnd{
	return _backEnd;
}

- (void) setFowardEnd:(BOOL)bEnd{
	if (bEnd != _fowardEnd) {
		_fowardEnd = bEnd;
		
		if (bEnd) {
			//[self.fowardButton setImage:[UIImage imageNamed:@"article_foward_end"] forState:UIControlStateNormal];
			self.fowardButton.enabled = NO;
		}else {
			//[self.fowardButton setImage:[UIImage imageNamed:@"article_foward"] forState:UIControlStateNormal];
			self.fowardButton.enabled = YES;
		}
	}
}

- (BOOL) fowardEnd{
	return _fowardEnd;
}

- (IBAction) backButtonDown{
	_backButton.alpha = 0.5;
	if ([_delegate respondsToSelector:@selector(bfViewControllerBackButtonDown:)]) {
		[_delegate performSelector:@selector(bfViewControllerBackButtonDown:) withObject:self];
	}
	//_backButton.alpha = 1.0;
}

- (IBAction) fowardButtonDown{
	_fowardButton.alpha = 0.5;
	if ([_delegate respondsToSelector:@selector(bfViewControllerFowardButtonDown:)]) {
		[_delegate performSelector:@selector(bfViewControllerFowardButtonDown:) withObject:self];
	}
	//_fowardButton.alpha = 1.0;
}

- (IBAction) backButtonUp{
	_backButton.alpha = 1.0;
}

- (IBAction) forwardButtonUp{
	_fowardButton.alpha = 1.0;
}

@end
