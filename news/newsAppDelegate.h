//
//  newsAppDelegate.h
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogViewController.h"
#import "PromoViewController.h"
#import "TabRootViewController.h"
#import "Reachability.h"

@interface newsAppDelegate : NSObject <UIApplicationDelegate,LogDelegate,PromoViewDelegate> {
	UINavigationController *_logNaviController;
    //UITabBarController *_tabBarController;
	PromoViewController *_promoViewController;
    TabRootViewController *_tabRootViewController;
    
    Reachability *internetReach;
	
	NSString *_username;
	NSString *_password;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *logNaviController;
@property (nonatomic, retain) TabRootViewController *tabRootViewController;
@property (nonatomic, retain) PromoViewController *promoViewController;
@end
