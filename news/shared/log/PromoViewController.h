//
//  WaitingViewController.h
//  news
//
//  Created by Perry Xiong on 7/8/11.
//  Copyright 2011 Xiong Peili-PSET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader.h"

@protocol PromoViewDelegate <NSObject>
- (void) promoViewClosed;
@end


@interface PromoViewController : UIViewController <ASIHTTPRequestDelegate, EGOImageLoaderObserver> {
    NSObject<PromoViewDelegate> *_delegate;
    
    ASIHTTPRequest *_request;
    
    UIImageView *_imageView;
    NSURL *_link;
    
    NSString *_newURLString;
}
@property (nonatomic, assign) NSObject<PromoViewDelegate> *delegate;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (IBAction) close;
@end
