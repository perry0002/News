//
//  MoreViewController.m
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import "FilterViewController.h"
#import "BaseArticlesTableViewController.h"

#define kCategories @"Categories"
#define kRegions @"Regions"
#define kFilterName @"Name"
#define kFilterItems @"Items"

#define kAllNews  @"All News"
#define kAllRegions  @"All Regions"

@interface FilterViewController()
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, retain) NSIndexPath *checkmarkedCategoriesRow;
@property (nonatomic, retain) NSIndexPath *checkmarkedRegionsRow;
- (void) resume;
- (void) update;
- (void) saveToFile;
- (void) readFromFile;
@end


@implementation FilterViewController
@synthesize parentController = _parentController;
@synthesize items = _items;
@synthesize queue = _queue;
@synthesize categoriesID = _categoriesID;
@synthesize regionsID = _regionsID;
@synthesize checkmarkedCategoriesRow = _checkmarkedCategoriesRow;
@synthesize checkmarkedRegionsRow = _checkmarkedRegionsRow;
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

    _changed = NO;
    
    self.title = @"Filter Articles";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //barItems
/*
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		backButton.frame = CGRectMake(0, 0, 50, 29);
	}else {
		backButton.frame = CGRectMake(0, 0, 50, 21);
	}
    //backButton.frame = CGRectMake(0, 0, 50, 30);
	[backButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
	backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
	backButton.titleEdgeInsets = UIEdgeInsetsMake(0,12,0,5);
	backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	backButton.autoresizesSubviews = YES;
	//backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = leftItem;
	[leftItem release];
*/
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTapped)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	//barItems
	UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		updateButton.frame = CGRectMake(0, 0, 60, 29);
	}else {
		updateButton.frame = CGRectMake(0, 0, 60, 21);
	}
    //backButton.frame = CGRectMake(0, 0, 50, 30);
	UIImage *rightBackImage = nil;
	if (_regionsID == -1 && _categoriesID == -1) {
		rightBackImage = [UIImage imageNamed:@"filter_gray"];
	}else {
		rightBackImage = [UIImage imageNamed:@"filter_orange"];
	}

	[updateButton setBackgroundImage:rightBackImage forState:UIControlStateNormal];
	updateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
	updateButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
	[updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[updateButton setTitle:@"Update" forState:UIControlStateNormal];
	[updateButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
	updateButton.autoresizesSubviews = YES;
	updateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin/*|UIViewAutoresizingFlexibleWidth*/|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:updateButton];
	self.navigationItem.rightBarButtonItem = rightItem;
	[rightItem release];
	
    self.queue = [ASINetworkQueue queue];
    self.queue.delegate = self;
    [self.queue setMaxConcurrentOperationCount:1];
    self.queue.queueDidFinishSelector = @selector(queueDidFinished);    
    
	[self readFromFile];
    if (self.items == nil || [self.items count] == 0) {
        self.items = [NSMutableArray arrayWithCapacity:0];
        [self resume];
    }    
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return  YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)backButtonTapped{
    [self dismissModalViewControllerAnimated:YES];
	/*
    if (_changed) {
        BaseArticlesTableViewController *parent = (BaseArticlesTableViewController*)_parentController;
        [parent filterChanged];
        [parent resume];		
    }
    */
}

- (void) resume{
	self.items = [NSMutableArray arrayWithCapacity:0];
    
    //get regions
    NSDictionary *regionsDic = [NSDictionary dictionaryWithObject:kRegions forKey:kFilterName];
    NSString *regionsRequestString = [NSString stringWithFormat:@"%@%@",kServerURL,@"getRegions"];    
    
    ASIHTTPRequest *regionsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:regionsRequestString]];
    [regionsRequest setRequestMethod:@"POST"];
    [regionsRequest setUserInfo:regionsDic];
    [regionsRequest setDelegate:self];
    [self.queue addOperation:regionsRequest];
    
    //get categories
    NSDictionary *cateDic = [NSDictionary dictionaryWithObject:kCategories forKey:kFilterName];
    NSString *categoryRequestString = [NSString stringWithFormat:@"%@%@",kServerURL,@"getCategories"];    
    
    ASIHTTPRequest *categoryRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:categoryRequestString]];
    [categoryRequest setRequestMethod:@"POST"];
    [categoryRequest setUserInfo:cateDic];
    [categoryRequest setDelegate:self];
    [self.queue addOperation:categoryRequest];
	
    [self.queue go];
    [ActivityIndicatorView showActivityIndicatorViewInParentView:self.navigationController.view];
}


- (void) update{
	if (_changed) {
        BaseArticlesTableViewController *parent = (BaseArticlesTableViewController*)_parentController;
		parent.categoriesID = _categoriesID;
		parent.regionsID = _regionsID;
        [parent filterChanged];
        [parent resume];
		
		//if (_categoriesID != -1 && _regionsID != -1) {
			UIButton *updateButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
			UIImage *rightBackImage = nil;
			if (_regionsID == -1 && _categoriesID == -1) {
				rightBackImage = [UIImage imageNamed:@"filter_gray"];
			}else {
				rightBackImage = [UIImage imageNamed:@"filter_orange"];
			}
			
			[updateButton setBackgroundImage:rightBackImage forState:UIControlStateNormal];
		//}
    }
	//return;

	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.items count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self.items objectAtIndex:section] objectForKey:kFilterItems] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString *title = [[self.items objectAtIndex:section] objectForKey:kFilterName];
	
	return title;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
	
	if ([self.items count] == 0) {
		return cell;
	}

    NSString *string = [[[[self.items objectAtIndex:indexPath.section] objectForKey:kFilterItems] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.textLabel.text = string;
    if (indexPath.row == 0) {   //all categories or regions, color is different
		cell.textLabel.textColor = [UIColor orangeColor];
	}else {
		cell.textLabel.textColor = [UIColor blackColor];
	}

    NSString *title = [[self.items objectAtIndex:indexPath.section] objectForKey:kFilterName];
    if ([title isEqualToString:kCategories]) {
        NSInteger iId = [[[[[self.items objectAtIndex:indexPath.section] objectForKey:kFilterItems] objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        if (iId == _categoriesID) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //self.checkmarkedCategoriesRow = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else{
        NSInteger iId = [[[[[self.items objectAtIndex:indexPath.section] objectForKey:kFilterItems] objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        if (iId == _regionsID) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //self.checkmarkedRegionsRow = indexPath;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //set to parent controller
    //BaseArticlesTableViewController *parent = (BaseArticlesTableViewController*)_parentController;    
    
    
    NSString *title = [[self.items objectAtIndex:indexPath.section] objectForKey:kFilterName];
    if ([title isEqualToString:kCategories]) {
        /*
        if (nil != self.checkmarkedCategoriesRow) {
            if (indexPath.section == self.checkmarkedCategoriesRow.section && indexPath.row == self.checkmarkedCategoriesRow.row) {
                return;
            }
        }
        
        //reset old cell checkmark 
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.checkmarkedCategoriesRow];
        cell.accessoryType = UITableViewCellAccessoryNone;
        */
        NSInteger iId = [[[[[self.items objectAtIndex:indexPath.section] objectForKey:kFilterItems] objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        _categoriesID = iId;
        //parent.categoriesID = _categoriesID;
        
        //self.checkmarkedCategoriesRow = indexPath;
    }else{
        /*
        if (nil != self.checkmarkedCategoriesRow){
            if (indexPath.section == self.checkmarkedRegionsRow.section && indexPath.row == self.checkmarkedRegionsRow.row) {
                return;
            }
        }
        
        //reset old cell checkmark
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.checkmarkedCategoriesRow];
        cell.accessoryType = UITableViewCellAccessoryNone;
        */
        NSInteger iId = [[[[[self.items objectAtIndex:indexPath.section] objectForKey:kFilterItems] objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        _regionsID = iId;
        //parent.regionsID = _regionsID;
        
        //self.checkmarkedRegionsRow = indexPath;
    }
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.checkmarkedCategoriesRow]; 
    //cell.accessoryType = UITableViewCellAccessoryNone;
    _changed = YES;
    
    [self.tableView reloadData];
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
	self.items = nil;
    [self.queue cancelAllOperations];
    self.queue = nil;
}


- (void)dealloc {
    [_queue cancelAllOperations];
    [_queue release];
	[_items release];
    [super dealloc];
}



- (void) saveToFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"filters"];
    
    [self.items writeToFile:filePath atomically:YES];
}

- (void) readFromFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"filters"];
    
    self.items = [NSMutableArray arrayWithContentsOfFile:filePath];
}


#pragma <ASIHttpRequestDelegate> Methods
- (void)requestStarted:(ASIHTTPRequest *)request{
    //[ActivityIndicatorView showActivityIndicatorViewInParentView:self.navigationController.view];
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader{
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    LOG_METHOD
    //[ActivityIndicatorView hideActivityIndicatorView];
	
    if ([request responseStatusCode] == chttpStatusCodeOK) {
        NSDictionary *dic = [[request responseString] JSONValue];
        
        //status
        BOOL status = [[dic objectForKey:kHttpSuccess] boolValue];
        if (!status) {
            return;
        }
        

        LOG(@"%@",[request responseString]);
        NSDictionary *userInfo = request.userInfo;
        if ([[userInfo objectForKey:kFilterName] isEqualToString:kCategories]) {
            NSMutableDictionary *cateDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [cateDic setValue:kCategories forKey:kFilterName];
            
            NSMutableDictionary *allNews = [NSMutableDictionary dictionaryWithCapacity:2];
            [allNews setValue:[NSNumber numberWithInt:-1] forKey:@"id"];
            [allNews setValue:kAllNews forKey:@"name"];
            
            NSMutableArray *categories = [NSMutableArray arrayWithCapacity:1];
            [categories addObject:allNews];
			NSArray *cts = [dic objectForKey:@"categories"];
			for (NSDictionary *d in cts) {
				NSString *name = [d objectForKey:@"name"];
				if (nil != name) {
					if ([name isEqualToString:kAllNews]) {
						
					}else {
						[categories addObject:d];
					}

				}

			}
            //[categories addObjectsFromArray:[dic objectForKey:@"categories"]];
            
            [cateDic setValue:categories forKey:kFilterItems];
            [self.items addObject:cateDic];
        }else{
            NSMutableDictionary *regionDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [regionDic setValue:kRegions forKey:kFilterName];
            
            NSMutableDictionary *allRegions = [NSMutableDictionary dictionaryWithCapacity:2];
            [allRegions setValue:[NSNumber numberWithInt:-1] forKey:@"id"];
            [allRegions setValue:kAllRegions forKey:@"name"];
            
            NSMutableArray *regions = [NSMutableArray arrayWithCapacity:1];
            [regions addObject:allRegions];
            [regions addObjectsFromArray:[dic objectForKey:/*@"categories"*/@"regions"]];
            
            [regionDic setValue:regions forKey:kFilterItems];
            [self.items addObject:regionDic];
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
}


- (void) queueDidFinished{
	LOG_METHOD
	[ActivityIndicatorView hideActivityIndicatorView];
    [self.tableView reloadData];
    
    [self saveToFile];
}

@end

