//
//  FavoritesViewController.m
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ArticleViewController.h"

@implementation FavoritesViewController

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
	self.title = @"Favorites";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:kSetFavoriteNotification object:nil];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
	self.navigationItem.leftBarButtonItem = item;
	if (!cNetWorkAvailable) {
		item.enabled = NO;
	}
	[item release];
	
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	if (_willShowNextCell) {
		NSArray *lastSubArray = [[self.articles lastObject] objectForKey:kGroupArray];
		if ((indexPath.section == [self.articles count]-1) && (indexPath.row == [lastSubArray count])) {
			return NO;
		}
	}
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	LOG_METHOD
	
	NSDictionary *dic = [self.articles objectAtIndex:indexPath.section];
	NSMutableArray *subArray = [dic objectForKey:kGroupArray];
	NSDictionary *article = [subArray objectAtIndex:indexPath.row];
	int articleID = [[article objectForKey:kArticleId] intValue];
	[[SQLiteManager sharedInstance] deleteFavorite:articleID];
	[subArray removeObjectAtIndex:indexPath.row];
	
	//begin request
	NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,kSetFavorites];
	NSDictionary *rdic = [NSMutableDictionary dictionaryWithCapacity:1];
	[rdic setValue:[NSNumber numberWithInt:articleID] forKey:@"article_id"];
	[rdic setValue:[NSNumber numberWithInt:0] forKey:@"favorite"];
	
	NSString *ss = [rdic JSONRepresentation];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestString]];
	[request setRequestMethod:@"POST"];
	[request appendPostData:[ss dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:kSetFavoriteNotification forKey:@"tag"];            
	[request setUserInfo:userInfo];    
	[request setDelegate:self];
	[self.queue addOperation:request];
	[self.queue go];
	
	if ([subArray count] == 0) {  //all removed
		[self.articles removeObjectAtIndex:indexPath.section];
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:YES];
	}else {
		NSArray *rows = [NSArray arrayWithObject:indexPath];
		[tableView deleteRowsAtIndexPaths:rows withRowAnimation:YES];
	}
}

/*
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
	return -5;
}
*/
- (void) httpRequest{
	[super httpRequest];
	
	if (cNetWorkAvailable) {
		//begin request
		NSString *requestString = [NSString stringWithFormat:@"%@%@",kServerURL,kGetFavorites];
		NSDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
		[dic setValue:[NSNumber numberWithUnsignedInteger:_startIndex] forKey:@"start"];
		[dic setValue:[NSNumber numberWithUnsignedInteger:cLimit] forKey:@"limit"];
		
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


- (void) reloadTableFromSQLite{
    
}

- (void) saveToSQLite:(NSArray *)array{
    [[SQLiteManager sharedInstance] addFavorites:array];
}

- (NSDictionary *)getFromSQLite{
    NSDictionary *dic = [[SQLiteManager sharedInstance] getFavoritesStart:_startIndex limit:cLimit];
    _startIndex += cLimit;
    return dic;
}


- (void) edit{
	if (!self.tableView.editing) {
		[self.tableView setEditing:YES animated:YES];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit)];
		self.navigationItem.leftBarButtonItem = item;
        [item release];
	}else {
		[self.tableView setEditing:NO animated:YES];
		
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
		self.navigationItem.leftBarButtonItem = item;
        [item release];
	}

	
}


- (void) networkChanged:(BOOL)available{
	self.navigationItem.rightBarButtonItem.enabled = available;
	//self.navigationItem.leftBarButtonItem.enabled = available;
}
@end

