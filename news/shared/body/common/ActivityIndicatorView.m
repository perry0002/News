//
//  ActivityIndicatorView.m
//  news
//
//  Created by 熊培利 on 11-8-17.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import "ActivityIndicatorView.h"
#import "newsAppDelegate.h"

const CGFloat cActivityViewWidth = 130;
const CGFloat cActivityViewHeight = 50;

ActivityIndicatorView *_instance = nil;

@implementation ActivityIndicatorView
@synthesize systemActivityIndicatorView = _systemActivityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        // Initialization code.
		CGPoint centerPt = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
		/*
		UIView *centerView = [[UIView alloc] initWithFrame:
							  CGRectMake(centerPt.x-cActivityViewWidth/2, 
										 centerPt.y-cActivityViewHeight/2, 
										 cActivityViewWidth, 
										 cActivityViewHeight)];
		centerView.backgroundColor = [UIColor blackColor];
		centerView.alpha = 0.6;
		*/
		UIImageView *centerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingBackground"]];
		centerView.center = centerPt;
		_systemActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[centerView addSubview:_systemActivityIndicatorView];
		//[_systemActivityIndicatorView startAnimating];
		//av.frame = CGRectMake(0, 0, 50, 50);
		_systemActivityIndicatorView.center = CGPointMake(90, 25);
		
		UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
		lb.textColor = [UIColor whiteColor];
		lb.backgroundColor = [UIColor clearColor];
		lb.text = @"Loading...";
		[centerView addSubview:lb];
        lb.center = CGPointMake(90, 65);
		[lb release];
		
		[self addSubview:centerView];
		[centerView release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[_systemActivityIndicatorView release];
    [super dealloc];
}


+ (void) showActivityIndicatorViewInParentView:(UIView *)view{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//UIView *superView = ((newsAppDelegate*)[UIApplication sharedApplication].delegate).tabRootViewController.tabBarController.view;
	if (_instance == nil) {
		_instance = [[ActivityIndicatorView alloc] initWithFrame:view.bounds];
	}
	
	[_instance removeFromSuperview];
	[view addSubview:_instance];
	[_instance.systemActivityIndicatorView startAnimating];
	
	view.window.userInteractionEnabled = NO;
	LOG(@"%@", [view description]);
}

+ (void) hideActivityIndicatorView{
	_instance.window.userInteractionEnabled = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[_instance.systemActivityIndicatorView stopAnimating];
	[_instance removeFromSuperview];
	[_instance release];
	_instance = nil;
}

@end
