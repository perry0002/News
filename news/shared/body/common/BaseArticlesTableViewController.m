//
//  BaseArticlesTableViewController.m
//  news
//
//  Created by 熊培利 on 11-8-4.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import "BaseArticlesTableViewController.h"
#import "ArticleViewController.h"
#import "FilterViewController.h"
#import "Helper.h"
#import "BaseTableViewCell.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>


@interface BaseArticlesTableViewController()
@property (nonatomic, retain) UINavigationController *articleNavi;
- (void) filter;
- (NSArray *) orderArticles:(NSArray *)array;
- (void) groupArticles:(NSArray *)array;
- (void) saveToSQLite:(NSArray *)array;
- (NSDictionary *)getFromSQLite;
- (void) saveToFile;
- (void) readFromFile;
@end

@implementation BaseArticlesTableViewController
@synthesize articles = _articles;
@synthesize queue = _queue;
@synthesize categoriesID = _categoriesID;
@synthesize regionsID = _regionsID;
@synthesize articleNavi = _articleNavi;
@synthesize noResultView = _noResultView;

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

- (void) hideNoResultView{
	[self.noResultView removeFromSuperview];
	self.noResultView = nil;
}

- (void) showNoResultView{
	[self hideNoResultView];
	if ([self isKindOfClass:NSClassFromString(@"SearchViewController")]) {
		return;
	}
	UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
	v.backgroundColor = [UIColor whiteColor];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
	label.text = @"There are no results";
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:12];
	[v addSubview:label];
	label.center = CGPointMake(CGRectGetMidX(v.bounds),CGRectGetMidY(v.bounds));
	
	[self.view addSubview:v];
	
	
	self.noResultView = v;
	[label release];
	[v release];
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	_currentGroup = 0;
    _currentSubArrayIndex = 0;
    _startIndex = 0;
    
    [self readFromFile];
	
	_loaded = NO;
    _willShowNextCell = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.articles = [NSMutableArray arrayWithCapacity:0];
        
    self.queue = [ASINetworkQueue queue];
    self.queue.delegate = self;
    self.queue.queueDidFinishSelector = @selector(queueDidFinished);
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!_loaded) {
		[self httpRequest];
		_loaded = YES;
	}
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if ([self.articles count]==0) {
		[self showNoResultView];
	}else {
		[self hideNoResultView];
	}

	return [self.articles count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.articles count]==0) {
		[self showNoResultView];
	}else {
		[self hideNoResultView];
	}
    // Return the number of rows in the section.
	NSInteger ret = [[[self.articles objectAtIndex:section] objectForKey:kGroupArray] count];;
	if ((section == [self.articles count]-1) && _willShowNextCell) {
		ret += 1;   //add new articles button
	}
    
	return ret;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	NSArray *lastSubArray = [[self.articles lastObject] objectForKey:kGroupArray];
	if ((indexPath.section == [self.articles count]-1) && (indexPath.row == [lastSubArray count])) {
		static NSString *CellIdentifier = @"CellButton";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
        /*
		//custom subview
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor lightGrayColor];
		label.text = [NSString stringWithFormat:@"Click for next %d news",cLimit];
		[cell.contentView addSubview:label];
         */
		
		
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		//cell.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.textLabel.text = [NSString stringWithFormat:@"Load More Listings..."];
        
	}else {
		static NSString *CellIdentifier = @"Cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		NSDictionary *dic = [self.articles objectAtIndex:indexPath.section];
		NSArray *subArray = [dic objectForKey:kGroupArray];
        [(BaseTableViewCell *)cell showImageView:[[subArray objectAtIndex:indexPath.row] objectForKey:@"thumb"]];
		//cell.imageView.image = [UIImage imageNamed:@"tableCellPlacehoder"];
		cell.textLabel.numberOfLines = 2;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
		NSString *string = [[subArray objectAtIndex:indexPath.row] objectForKey:@"title"];
		if ([string isKindOfClass:[NSNull class]]) {
			string = @"";
		}
		cell.textLabel.text = string;
		cell.detailTextLabel.numberOfLines = 2;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
		
		string = [[subArray objectAtIndex:indexPath.row] objectForKey:@"body"];
		if ([string isKindOfClass:[NSNull class]]) {
			string = @"";
		}
		cell.detailTextLabel.text = string;
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSDictionary *dic = [self.articles objectAtIndex:section];
	NSString *groupTitle = [dic objectForKey:kGroupDate];
	//NSString *ss = stringForDate([NSDate date]);
	if ([groupTitle isEqualToString:stringForDate([NSDate date])]) {
		return @"Today";
	}else if ([groupTitle isEqualToString:stringForDate([NSDate dateWithTimeIntervalSinceNow:-24*60*60])]) {
		return @"Yesterday";
	}
	return groupTitle;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
	
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(12, 0, 300, 22);
    label.backgroundColor = [UIColor clearColor];
	label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    label.text = sectionTitle;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlebackground"]];
	[imageView addSubview:label];
	[label release];
	return [imageView autorelease];
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    if ((indexPath.section == [self.articles count]-1) && (indexPath.row == [[[self.articles lastObject] objectForKey:kGroupArray] count])) {
		//create cell button
		[self httpRequest];
	}else {
		_currentGroup = indexPath.section;
		_currentSubArrayIndex = indexPath.row;
		ArticleViewController *viewer = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController_iPhone" bundle:nil];
		// ...
		// Pass the selected object to the new view controller.
		NSDictionary *dic = [self.articles objectAtIndex:_currentGroup];
		NSArray *subArray = [dic objectForKey:kGroupArray];
		
		viewer.article = [subArray objectAtIndex:_currentSubArrayIndex];
		viewer.delegate = self;
		if ([self isKindOfClass:NSClassFromString(@"FavoritesViewController")]) {
			viewer.bfavorite = YES;
		}else {
			if ([[SQLiteManager sharedInstance] isFavorite:[[viewer.article objectForKey:kArticleId] intValue]]) {
				viewer.bfavorite = YES;
			}
		}

		
		UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewer];	
		navi.navigationBar.barStyle = UIBarStyleBlackTranslucent;

		CGRect destFrame = self.tabBarController.view.bounds;

		CATransition *animation = [CATransition animation];
		//animation.delegate = self;
		animation.duration = 0.3f;
		animation.timingFunction = UIViewAnimationCurveEaseInOut;
		animation.fillMode = kCAFillModeForwards;
		animation.type = kCATransitionPush;
		if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			animation.subtype = kCATransitionFromRight;
		}else if (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
			animation.subtype = kCATransitionFromLeft;
		}else if (self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
			animation.subtype = kCATransitionFromTop;
		}else {
			animation.subtype = kCATransitionFromBottom;
		}

		[self.tabBarController.view addSubview:navi.view];
		navi.view.frame = destFrame;
		//[self.view.window.layer addAnimation:animation forKey:@"animation"];
		[self.tabBarController.view.layer addAnimation:animation forKey:@"animation"];
		
		if (_currentGroup == 0 && _currentSubArrayIndex == 0) {
			viewer.rightButtonView.backEnd = YES;
		}else if (_currentGroup == [self.articles count]-1 && _currentSubArrayIndex == [subArray count]-1) {
			viewer.rightButtonView.fowardEnd = YES;
		}

		
		self.articleNavi = navi;
		[navi release];
		[viewer release];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 83;
	/*
	if ((indexPath.section == [self.articles count]-1) && (indexPath.row == [[[self.articles lastObject] objectForKey:kGroupArray] count])) {
		return 32;
	}else {
		return 83;
	}
	 */
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
  
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(12, 0, 300, 22);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    label.text = sectionTitle;

    // Create header view and add label as a subview
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)] autorelease];
    [sectionView setBackgroundColor:[UIColor lightGrayColor]];
    [sectionView addSubview:label];
    return sectionView;
}*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	NSArray *lastSubArray = [[self.articles lastObject] objectForKey:kGroupArray];
	if ((indexPath.section == [self.articles count]-1) && (indexPath.row == [lastSubArray count])) {
		
	}else {
		NSDictionary *article = [[[self.articles objectAtIndex:indexPath.section] objectForKey:kGroupArray] objectAtIndex:indexPath.row];
        
        BaseTableViewCell *baseCell = (BaseTableViewCell *)cell;
        [baseCell startLoadingImage:[article objectForKey:@"thumb"]];
	}

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
	[super viewDidLoad];
	
	self.articles = nil;
	[_queue cancelAllOperations];
	self.queue = nil;
	self.articleNavi= nil;
	self.noResultView = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_queue cancelAllOperations];
	[_queue release];
	[_articles release];
	[_articleNavi release];
	[_noResultView release];
    [super dealloc];
}


- (void) httpRequest{
    if (!cNetWorkAvailable) {
		NSDictionary *dic = [self getFromSQLite];
        _total = [[dic objectForKey:@"total"] intValue];
        NSArray *array = [dic objectForKey:@"articles"];
		[self groupArticles:array];
        if (_total>10 && _startIndex<_total) {
            _willShowNextCell = YES;
        }else{
            _willShowNextCell = NO;
        }
		[self.tableView reloadData];
		
	}
}


- (void) filter{   
    FilterViewController *filter = [[FilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    filter.parentController = self;
    filter.categoriesID = _categoriesID;
    filter.regionsID = _regionsID;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:filter];
    [filter release];
    [self presentModalViewController:navi animated:YES];
    [navi release];
}


- (NSArray *) orderArticles:(NSArray *)array{
	//order the array by date
	NSArray *sortedArray = [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
		NSDictionary *dic1 = (NSDictionary*)obj1;
		NSDictionary *dic2 = (NSDictionary*)obj2;
		
		if ([[dic1 objectForKey:@"date"] integerValue] > [[dic2 objectForKey:@"date"] integerValue]) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		
		if ([[dic1 objectForKey:@"date"] integerValue] > [[dic2 objectForKey:@"date"] integerValue]) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];
	
	return sortedArray;
}

- (void) groupArticles:(NSArray *)array{
	if (nil == _articles) {
		_articles = [[NSMutableArray arrayWithCapacity:0] retain];
	}
	
	//add array to dictionary
	for (NSDictionary *article in array) {
        
        NSString *thumbURL = [article objectForKey:kArticleThumb];
        NSString *n = [thumbURL stringByReplacingOccurrencesOfString:@".thumbnail" withString:@""];
        [article setValue:n forKey:kArticleThumb];
        
		NSString *articleDataString = stringForDate([NSDate dateWithTimeIntervalSince1970:[[article objectForKey:@"date"] integerValue]]);
		//find the same date group
		NSDictionary *group = nil;
		for (group in self.articles) {
			if ([[group objectForKey:kGroupDate] isEqualToString:articleDataString]) {
				break;
			}
		}
		
		if (group) {
			NSMutableArray *mArray = [group objectForKey:kGroupArray];
			[mArray addObject:article];

		}else {
			NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:0];
			[mArray addObject:article];
			
			NSDictionary *classifiedDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:articleDataString, mArray, nil]
																	  forKeys:[NSArray arrayWithObjects:kGroupDate,kGroupArray,nil]]; 
			[self.articles addObject:classifiedDic];
		}
	}
}
#pragma Actions
- (void) resume{
    if (!cNetWorkAvailable) {
        return;
    }
    [self.articles removeAllObjects];
	_startIndex = 0;
	
	[self httpRequest];
}

- (void) filterChanged{
	[self saveToFile];
}

- (void) saveToSQLite:(NSArray *)array{
}

- (NSDictionary *)getFromSQLite{
    return  nil;
}

- (void) readFromFile{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithUTF8String:object_getClassName(self)]];
    
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (nil != dic) {
		_categoriesID = [[dic objectForKey:@"categoriesID"] integerValue];
		_regionsID    = [[dic objectForKey:@"regionsID"] integerValue];
	}else {
		_categoriesID = -1;
		_regionsID = -1;
	}

	
}

- (void) saveToFile{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithUTF8String:object_getClassName(self)]];
    
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
	[dic setValue:[NSNumber numberWithInteger:_categoriesID] forKey:@"categoriesID"];
	[dic setValue:[NSNumber numberWithInteger:_regionsID] forKey:@"regionsID"];
    [dic writeToFile:filePath atomically:YES];
}


#pragma <ArticleViewControllerDelegate> Methods
- (BOOL) ArticleViewControllerForwardButtonTapped:(ArticleViewController*)controller{
    BOOL bRet = NO;
	
	NSDictionary *dic = [self.articles objectAtIndex:_currentGroup];
	NSArray *subArray = [dic objectForKey:kGroupArray];
	if (_currentSubArrayIndex < ([subArray count]-1)) {
		_currentSubArrayIndex ++;
		controller.article = [subArray objectAtIndex:_currentSubArrayIndex];
	}else {
		_currentGroup++;
		_currentSubArrayIndex = 0;
		
		dic = [self.articles objectAtIndex:_currentGroup];
		subArray = [dic objectForKey:kGroupArray];
		controller.article = [subArray objectAtIndex:_currentSubArrayIndex];
	}

	if (_currentGroup == [self.articles count]-1 && _currentSubArrayIndex == [subArray count]-1) {
		bRet = YES;
	}

	//[controller resume];
    return bRet;
}

- (BOOL) ArticleViewControllerBackButtonTapped:(ArticleViewController*)controller{
    BOOL bRet = NO;
	
	NSDictionary *dic = [self.articles objectAtIndex:_currentGroup];
	NSArray *subArray = [dic objectForKey:kGroupArray];
	if (_currentSubArrayIndex > 0) {
		_currentSubArrayIndex --;
		controller.article = [subArray objectAtIndex:_currentSubArrayIndex];
	}else {
		_currentGroup--;
		NSDictionary *dic = [self.articles objectAtIndex:_currentGroup];
		NSArray *subArray = [dic objectForKey:kGroupArray];
		
		_currentSubArrayIndex = [subArray count]-1;
		controller.article = [subArray objectAtIndex:_currentSubArrayIndex];
	}
	
	if (_currentGroup == 0 && _currentSubArrayIndex == 0) {
		bRet = YES;
	}

    //[controller resume];
    return bRet;
}

- (void) ArticleViewControllerViewShouldBeDismissed:(ArticleViewController*)controller{
	[self viewWillAppear:YES];
	
	//navi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	CGRect orgFrame = self.tabBarController.view.frame;
	CGRect destFrame = CGRectOffset(orgFrame, orgFrame.size.width, 0);
	
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 0.3f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeRemoved;
	animation.type = kCATransitionPush;
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
		animation.subtype = kCATransitionFromLeft;
	}else if (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
		animation.subtype = kCATransitionFromRight;
	}else if (self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) {
		animation.subtype = kCATransitionFromBottom;
	}else {
		animation.subtype = kCATransitionFromTop;
	}

	controller.navigationController.view.frame = destFrame;
	[controller.navigationController.view removeFromSuperview];
	[self.view.window.layer addAnimation:animation forKey:@"animation"];
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //[self.articleNavi.view removeFromSuperview];
	self.articleNavi = nil;
	[self viewDidAppear:YES];
}
#pragma <ASIHttpRequestDelegate> Methods
- (void)requestStarted:(ASIHTTPRequest *)request{
	LOG_METHOD
	[ActivityIndicatorView showActivityIndicatorViewInParentView:self.navigationController.view];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader{
}

- (void)requestFinished:(ASIHTTPRequest *)request{
	LOG_METHOD
    [ActivityIndicatorView hideActivityIndicatorView];
    
	//LOG(@"%@", [request responseString]);
    if ([request responseStatusCode] == chttpStatusCodeOK) {
        NSDictionary *dic = [[request responseString] JSONValue];
        
        //status
        BOOL status = [[dic objectForKey:@"success"] boolValue];
        if (!status) {
            return;
        }
        
        //total
        NSObject *t = [dic objectForKey:@"total"];
        if ([t isKindOfClass:[NSString class]]) {
            _total = [(NSString *)t integerValue];
        }else if([t isKindOfClass:[NSNumber class]]){
            _total = [(NSNumber *)t unsignedIntegerValue];
        }
        if (_total>10 && _startIndex<_total) {
            _willShowNextCell = YES;
        }else {
            _willShowNextCell = NO;
        }
		NSArray *array = [dic objectForKey:@"articles"];
		[self groupArticles:array];
        [self saveToSQLite:array];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
	LOG_METHOD
    [ActivityIndicatorView hideActivityIndicatorView];
}

- (void) queueDidFinished{
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Network changed
- (void) networkChanged:(BOOL)available{
}
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    //return;
	Reachability* curReach = [note object];
    cNetWorkAvailable = ([curReach currentReachabilityStatus] != kNotReachable);
    [self networkChanged:cNetWorkAvailable];
}
@end

