//
//  newsAppDelegate_iPad.m
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "newsAppDelegate_iPad.h"

@implementation newsAppDelegate_iPad

- (void)dealloc
{
	[super dealloc];
}

- (void) logSucceeded{
	_promoViewController = [[PromoViewController alloc] initWithNibName:@"WaitingViewController_iPad" bundle:[NSBundle bundleForClass:[PromoViewController class]]];
	_promoViewController.view.frame = self.window.bounds;
	
	[UIView beginAnimations:@"log1" context:nil];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationTransition:UIViewContentModeTop forView:self.window cache:YES];
	
	[self.window addSubview:_promoViewController.view];
	
	
    [UIView commitAnimations];
}

@end
