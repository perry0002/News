//
//  MoreViewController.h
//  news
//
//  Created by Perry Xiong on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UITableViewController<UIActionSheetDelegate> {
	ASIHTTPRequest *_request;
}

@end
