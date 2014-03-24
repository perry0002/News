//
//  ShareArticleViewController.h
//  news
//
//  Created by Perry Xiong on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareArticleViewController : UIViewController <UITextFieldDelegate>{
    UILabel *_promptLabel;
    UITextField *_emailAddressField;
	
	ASIHTTPRequest *_request;
}
@property (nonatomic, retain) IBOutlet UILabel *promptLabel;
@property (nonatomic, retain) IBOutlet UITextField *emailAddressField;

@end
