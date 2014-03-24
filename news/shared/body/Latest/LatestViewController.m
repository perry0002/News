//
//  LatestViewController.m
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "LatestViewController.h"
#import "ArticleViewController.h"
#import "CommonDef.h"
#import "Debug.h"

@interface LatestViewController()
- (void) httpRequest;
@end
    
@implementation LatestViewController


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = @"Latest News"; 
	self.navigationController.tabBarItem.title = @"Latest";
	
	UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		filterButton.frame = CGRectMake(0, 0, 60, 29);
	}else {
		filterButton.frame = CGRectMake(0, 0, 60, 21);
	}
    //backButton.frame = CGRectMake(0, 0, 50, 30);
	UIImage *filterBackImage = nil;
	if (_regionsID == -1 && _categoriesID == -1) {
		filterBackImage = [UIImage imageNamed:@"filter_gray"];
	}else {
		filterBackImage = [UIImage imageNamed:@"filter_orange"];
	}
	
	[filterButton setBackgroundImage:filterBackImage forState:UIControlStateNormal];
	filterButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
	filterButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
	[filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[filterButton setTitle:@"Filter" forState:UIControlStateNormal];
	[filterButton addTarget:self action:@selector(filter) forControlEvents:UIControlEventTouchUpInside];
	filterButton.autoresizesSubviews = YES;
	filterButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin/*|UIViewAutoresizingFlexibleWidth*/|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
	
	UIButton *reload = [UIButton buttonWithType:UIButtonTypeCustom];
    //reload.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
    //reload.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	reload.frame = CGRectMake(0, 0, 22, 25);
	[reload setImage:[UIImage imageNamed:@"navi_reload"] forState:UIControlStateNormal];
	[reload addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:reload];
	self.navigationItem.rightBarButtonItem = rightItem;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		reload.frame = CGRectMake(0, 0, 22, 25);
	}else {
		reload.frame = CGRectMake(0, 0, 16, 18.2);
	}
	if (!cNetWorkAvailable) {
		leftItem.enabled = NO;
        rightItem.enabled = NO;
    }
    [rightItem release];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect oldFrame = self.navigationItem.rightBarButtonItem.customView.frame;
    CGRect newFrame = oldFrame;
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait 
		|| self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        newFrame.size = CGSizeMake(22, 25);
		//self.navigationItem.rightBarButtonItem.customView.frame = CGRectMake(0, 0, 22, 25);
	}else {
        newFrame.size = CGSizeMake(16, 18.2);
		//self.navigationItem.rightBarButtonItem.customView.frame = CGRectMake(0, 0, 16, 18.2);
	}
    self.navigationItem.rightBarButtonItem.customView.frame = newFrame;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	CGRect rect = self.navigationItem.rightBarButtonItem.customView.frame;
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait 
		|| toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		rect.size = CGSizeMake(22, 25);
	}else {
		rect.size = CGSizeMake(16, 18.2);
	}
	self.navigationItem.rightBarButtonItem.customView.frame = rect;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void) httpRequest{
	[super httpRequest];
	
	if (cNetWorkAvailable) {
		//begin request
		NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,kGetArticles];
		NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
		[dic setValue:[NSNumber numberWithUnsignedInteger:_startIndex] forKey:@"start"];
		[dic setValue:[NSNumber numberWithUnsignedInteger:cLimit] forKey:@"limit"];
		//[dic setValue:@"china" forKey:@"search"];
		
		if (_categoriesID>=0) {
			[dic setValue:[NSNumber numberWithInteger:_categoriesID] forKey:@"category_id"];
		}
		if (_regionsID>=0) {
			[dic setValue:[NSNumber numberWithInteger:_regionsID]  forKey:@"category_id"];
		}
		
		NSString *ss = [dic JSONRepresentation];
		
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestString]];
		[request setRequestMethod:@"POST"];
		[request appendPostData:[ss dataUsingEncoding:NSUTF8StringEncoding]];
		[request setUserInfo:nil];    
		[request setDelegate:self];
		[self.queue addOperation:request];
		[self.queue go];
		
		_startIndex += cLimit;
	}
    
}


- (void) filterChanged{
	[super filterChanged];
	UIImage *filterBackImage = nil;
	if (_regionsID == -1 && _categoriesID == -1) {
		filterBackImage = [UIImage imageNamed:@"filter_gray"];
	}else {
		filterBackImage = [UIImage imageNamed:@"filter_orange"];
	}
	
	UIButton *filterButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[filterButton setBackgroundImage:filterBackImage forState:UIControlStateNormal];
}

- (void) saveToSQLite:(NSArray *)array{
    [[SQLiteManager sharedInstance] addLatest:array];
}

- (NSDictionary *)getFromSQLite{
    NSDictionary *dic = [[SQLiteManager sharedInstance] getLatestStart:_startIndex limit:cLimit];
    _startIndex += cLimit;
    return dic;
}


- (void) networkChanged:(BOOL)available{
	self.navigationItem.rightBarButtonItem.enabled = available;
	self.navigationItem.leftBarButtonItem.enabled = available;
}
@end

