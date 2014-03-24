//
//  CustomBFViewController.h
//  news
//
//  Created by Perry Xiong on 7/22/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomBFViewController;

@protocol CustomBFViewDelegate<NSObject>
- (void) bfViewControllerBackButtonDown:(CustomBFViewController *)controller;
- (void) bfViewControllerFowardButtonDown:(CustomBFViewController *)controller;
@end



@interface CustomBFViewController : UIViewController {
	NSObject<CustomBFViewDelegate> *_delegate;
	UIButton *_backButton;
	UIButton *_fowardButton;
	
	BOOL _backEnd;
	BOOL _fowardEnd;
}
@property (nonatomic, assign) NSObject<CustomBFViewDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *fowardButton;
@property (nonatomic) BOOL backEnd;
@property (nonatomic) BOOL fowardEnd;

- (IBAction) backButtonDown;
- (IBAction) fowardButtonDown;
- (IBAction) backButtonUp;
- (IBAction) forwardButtonUp;
@end
