//
//  BaseTableViewCell.h
//  news
//
//  Created by Perry Xiong on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader.h"
#import "PYActivityIndicator.h"

@interface BaseTableViewCell : UITableViewCell<EGOImageLoaderObserver>{
    BOOL _loaded;
    
    NSString *_urlString;
	UIImageView *_sImageView;
	
	PYActivityIndicator *_ai;
}

- (void) startLoadingImage:(NSString *)urlString;
- (void) cancelLoadingImage:(NSString *)urlString;
- (void) showImageView:(NSString *)urlString;
@end
