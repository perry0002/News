//
//  viewerViewController.h
//  news
//
//  Created by Perry Xiong on 7/8/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBFViewController.h"



@class  ArticleViewController;

@protocol ArticleViewControllerDelegate <NSObject>
- (BOOL) ArticleViewControllerForwardButtonTapped:(ArticleViewController*)controller;   //return whether last news shows
- (BOOL) ArticleViewControllerBackButtonTapped:(ArticleViewController*)controller; //return whether first news shows
- (void) ArticleViewControllerViewShouldBeDismissed:(ArticleViewController*)controller;
@end

@interface ArticleViewController : UIViewController<CustomBFViewDelegate
, UIGestureRecognizerDelegate
, UIActionSheetDelegate
, ASIHTTPRequestDelegate
, MFMailComposeViewControllerDelegate> {
    NSObject<ArticleViewControllerDelegate> *_delegate;
	UIWebView *_webView;	
	NSDictionary *_article;	
	CustomBFViewController *_rightButtonView;
	
	ASINetworkQueue *_queue;
	
	UIBarButtonItem *_textZoomOut;
	UIBarButtonItem *_textZoomIn;
	UIBarButtonItem *_favoriteItem;
	
	BOOL _bfavorite;
}
@property (nonatomic, assign) NSObject<ArticleViewControllerDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSDictionary *article;
@property (nonatomic, retain) CustomBFViewController *rightButtonView;
@property (nonatomic) BOOL bfavorite;
- (void) resume;
@end
