//
//  TabRootViewController.m
//  news
//
//  Created by Perry Xiong on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabRootViewController.h"

@implementation TabRootViewController
@synthesize tabBarController = _tabBarController;

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

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tabBarController.view.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:_tabBarController.view];
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

- (UITabBarController *)tabBarController {
    if (_tabBarController == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TabRootViewController_iPhone" owner:self options:nil];
    }
    return _tabBarController; 
}  

@end
