//
//  TestServerViewController.h
//  news
//
//  Created by Perry Xiong on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestServerViewController : UIViewController <UITextFieldDelegate>{
    UITextField *_textField;
}
@property (nonatomic, retain) IBOutlet UITextField *textField;
@end
