//
//  newsAppDelegate.m
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "newsAppDelegate.h"
#import "CommonDef.h"
#import "Alerts.h"
#import "SearchViewController.h"
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>

const NSUInteger cLimit = 100;
const NSUInteger chttpStatusCodeOK = 200;
int cFontSizeLevel = 2;
BOOL cAdmin = YES;
BOOL cNetWorkAvailable = NO;
NSString *kServerURL = @"http://www.stylesight.com/news/m/";
NSString *const kLogOutNotification = @"LogOutNotification";
NSString *const kSetFavoriteNotification = @"SetFavoriteNotification";
NSString *const kRemoveFavoriteNotification = @"RemoveFavoriteNotification";

@interface newsAppDelegate()
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@end

@implementation newsAppDelegate
@synthesize window = _window;
@synthesize logNaviController = _logNaviController;
@synthesize tabRootViewController = _tabRootViewController;
@synthesize promoViewController = _promoViewController;
@synthesize username = _username;
@synthesize password = _password;

- (NSDictionary *)loadUserInfo{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo"];
    
	NSDictionary *dictionary = nil;
    dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
	
	return dictionary;
}

- (void)saveUserInfo{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo"];
    
	NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:3];
	if (self.username) {
		[mDic setValue:self.username forKey:@"username"];
	}
	if (self.password) {
		[mDic setValue:self.password forKey:@"password"];
	}
	
	[mDic setValue:[NSNumber numberWithInt:cFontSizeLevel] forKey:@"fontLevel"];
    [mDic writeToFile:filePath atomically:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:kLogOutNotification object:nil];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    cNetWorkAvailable = ([internetReach currentReachabilityStatus] != kNotReachable);
    if (!cNetWorkAvailable) {
        showErrorDlg1(nil,@"Network is not available");
		/*
		NSHTTPCookieStorage *ss = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		NSArray *allCookies = [ss cookies];
		NSArray *sCookies = [ss cookiesForURL:[NSURL URLWithString:kServerURL]];
		
		
		LOG(@"all cookies:%@", allCookies);
		LOG(@"s cookies:%@", sCookies);
		if ([sCookies count] > 0) {
			[ASIHTTPRequest setSessionCookies:[NSMutableArray arrayWithArray:sCookies]];
		}
		*/
		TabRootViewController *tabRootViewController = [[TabRootViewController alloc] initWithNibName:@"TabRootViewController_iPhone" bundle:nil];
		
		self.window.rootViewController = tabRootViewController.tabBarController;	
		self.tabRootViewController = tabRootViewController;
/*        
        if (!cNetWorkAvailable) {
            for (UINavigationController *navi in tabRootViewController.tabBarController.viewControllers) {
                if ([navi.topViewController isKindOfClass:[SearchViewController class]]) {
                    navi.tabBarItem.enabled = NO;
                }
            }
        }
*/        
		[tabRootViewController release];
		
		[self.window makeKeyAndVisible];
    }else {
		LogViewController *logViewController = [[LogViewController alloc] initWithNibName:@"LogViewController_iPhone" bundle:nil];
		logViewController.delegate = self;
		
		_logNaviController = [[UINavigationController alloc] initWithRootViewController:logViewController];
		self.window.rootViewController = _logNaviController;
		
		[self.window makeKeyAndVisible];
		
		NSDictionary *userInfo = [self loadUserInfo];
		//if ([userInfo count] == 2) {
			logViewController.userNameTextField.text = [userInfo objectForKey:@"username"];
			logViewController.passwordTextField.text = [userInfo objectForKey:@"password"];
			cFontSizeLevel = [[userInfo objectForKey:@"fontLevel"] intValue];   //font level for article viewer
			if (cFontSizeLevel == 0) {
				cFontSizeLevel = 2;
			}
		if (logViewController.userNameTextField.text!=nil && logViewController.passwordTextField.text!=nil) {
			[logViewController login];
		}
			
		//}
		
		[logViewController release];
		
	}
    
    
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	[self saveUserInfo];
	return;
    NSArray *sCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kServerURL]];
    [ASIHTTPRequest clearSession];
    for (NSHTTPCookie *c in sCookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:c];
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
	NSArray *thumbs = [[SQLiteManager sharedInstance] getAllThumbUrlStrings];
	removeAllThumbsExcept(thumbs);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{   
	[_logNaviController release];
	[_tabRootViewController release];
    [_window release];
    [super dealloc];
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if ([animationID isEqualToString:@"log1"]) {
		
	}else {
		//[_logNaviController.view removeFromSuperview];
		self.logNaviController = nil;
	}
}

- (void) logBegan{
	
}

- (void) logSucceededWithUsername:(NSString *)username password:(NSString *)password{
    self.username = username;
	self.password = password;
	[self saveUserInfo];
	_promoViewController = [[PromoViewController alloc] initWithNibName:@"PromoViewController_iPhone" bundle:[NSBundle bundleForClass:[PromoViewController class]]];
    _promoViewController.delegate = self;

    _promoViewController.view.alpha = 0.1;
    self.logNaviController.navigationBar.hidden = YES;
    [UIView animateWithDuration:0.3 
                          //delay:0.0 
                        //options:UIViewAnimationTransitionFlipFromLeft
                     animations:^{
                        [self.logNaviController pushViewController:_promoViewController animated:NO];
						 _promoViewController.view.alpha = 1.0;
					 }
                     completion:^(BOOL finished){
					 }];
}


- (void) logFailed{
	self.username = nil;
	self.password = nil;
}

- (void) promoViewClosed{
    TabRootViewController *tabRootViewController = [[TabRootViewController alloc] initWithNibName:@"TabRootViewController_iPhone" bundle:nil];
    
	CATransition *animation = [CATransition animation];
	//animation.delegate = self;
	animation.duration = 0.3f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	animation.type = kCATransitionReveal;
	animation.subtype = kCATransitionFromBottom;

	
	self.window.rootViewController = tabRootViewController.tabBarController;	
    self.tabRootViewController = tabRootViewController;
    [tabRootViewController release];
	//[self.view.window.layer addAnimation:animation forKey:@"animation"];
	[self.window.layer addAnimation:animation forKey:@"animation"];
}


- (void) logOut{
	self.username = nil;
	self.password = nil;
	[self saveUserInfo];
	LogViewController *logViewController = [[LogViewController alloc] initWithNibName:@"LogViewController_iPhone" bundle:nil];
	logViewController.delegate = self;
	_logNaviController = [[UINavigationController alloc] initWithRootViewController:logViewController];
	[logViewController release];
	
	self.tabRootViewController = nil;
    self.window.rootViewController = _logNaviController;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    //return;
	Reachability* curReach = [note object];
    cNetWorkAvailable = ([curReach currentReachabilityStatus] != kNotReachable);
    if (!cNetWorkAvailable) {
        showErrorDlg1(nil,@"Network is not available");
    }
/*	
	if (!cNetWorkAvailable) {
		if (self.tabRootViewController.tabBarController.selectedIndex == 2) {
			self.tabRootViewController.tabBarController.selectedIndex = 0;
            for (UINavigationController *navi in self.tabRootViewController.tabBarController.viewControllers) {
                if ([navi.topViewController isKindOfClass:[SearchViewController class]]) {
                    navi.tabBarItem.enabled = NO;
                }
            }
        }
	}
 */
}
@end
