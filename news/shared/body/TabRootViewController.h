//
//  TabRootViewController.h
//  news
//
//  Created by Perry Xiong on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabRootViewController : UIViewController{
    UITabBarController *_tabBarController; 
}
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController; 
@end
