//
//  LogViewController.h
//  news
//
//  Created by Perry Xiong on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSAlertView.h"

@protocol LogDelegate<NSObject>
- (void) logBegan;
- (void) logSucceededWithUsername:(NSString *)username password:(NSString *)password;
- (void) logFailed;
@end


@interface LogViewController : UIViewController <UITextFieldDelegate
,ASIHTTPRequestDelegate
,TSAlertViewDelegate>{
	NSObject<LogDelegate> *_delegate;
	UIView *_parentView;
	UIImageView *_imageView;
	UIImageView *_logoImageView;
	UIImageView *_userNameTextFieldBackImage;
	UIImageView *_passwordTextFieldBackImage;
    UITextField *_userNameTextField;
    UITextField *_passwordTextField; 
	
	
	UIControl *_backControl;
	UILabel *_promptLabel;
	UILabel *_forgotUserNameOrPasswordLabel;
	UILabel *_becomeAStylesightSubscriberLabel;
    
    ASIFormDataRequest *_request;
}
@property (nonatomic, assign) IBOutlet NSObject<LogDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UIView *parentView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) IBOutlet UIImageView *userNameTextFieldBackImage;
@property (nonatomic, retain) IBOutlet UIImageView *passwordTextFieldBackImage;
@property (nonatomic, retain) IBOutlet UITextField *userNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UILabel *promptLabel;
@property (nonatomic, retain) IBOutlet UILabel *forgotUserNameOrPasswordLabel;
@property (nonatomic, retain) IBOutlet UILabel *becomeAStylesightSubscriberLabel;
@property (nonatomic, retain) IBOutlet ASIFormDataRequest *request;

- (IBAction) forgotUserNameOrPassword;
- (IBAction) becomeAStylesightSubscriber;

- (IBAction) backControlTapped;
- (IBAction) resetServer;
//- (IBAction) close;
- (void) login;
@end
