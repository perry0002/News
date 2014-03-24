//
//  MoreViewController.h
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FilterViewController : UITableViewController {
	NSMutableArray *_items;
    ASINetworkQueue *_queue;
    NSInteger _categoriesID;
    NSInteger _regionsID;
    NSIndexPath *_checkmarkedCategoriesRow;
    NSIndexPath *_checkmarkedRegionsRow;
    BOOL _changed;
    
    UIViewController *_parentController;
}
@property (nonatomic, assign) UIViewController *parentController;
@property (nonatomic)  NSInteger categoriesID;
@property (nonatomic)  NSInteger regionsID;
@end
