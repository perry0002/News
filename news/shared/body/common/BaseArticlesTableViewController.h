//
//  BaseArticlesTableViewController.h
//  news
//
//  Created by 熊培利 on 11-8-4.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleViewController.h"
#import "SQLiteManager.h"

#define kGroupDate @"groupDate"
#define kGroupArray @"groupArray"

@interface BaseArticlesTableViewController : UITableViewController<ASIHTTPRequestDelegate,ArticleViewControllerDelegate> {
	NSMutableArray *_articles;
	
	ASINetworkQueue *_queue;
    
    NSUInteger _startIndex;
    NSUInteger _total;
	//NSUInteger _databaseTotal;  //total news in sqlite database
	//BOOL _getNewsFromServer;    //is getting news from server
    
    NSUInteger _currentGroup;
	NSUInteger _currentSubArrayIndex;
    
    NSInteger _categoriesID;
    NSInteger _regionsID;
	
	BOOL _loaded;
    BOOL _willShowNextCell;
	
	UINavigationController *_articleNavi;
	
	UIView *_noResultView;
}

@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) ASINetworkQueue *queue;
@property (nonatomic, assign) NSInteger categoriesID;
@property (nonatomic, assign) NSInteger regionsID;
@property (nonatomic, retain) UIView *noResultView;

- (void) resume;
- (void) httpRequest;

- (void) filterChanged;
- (void) networkChanged:(BOOL)available;
@end
