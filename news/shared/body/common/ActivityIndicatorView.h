//
//  ActivityIndicatorView.h
//  news
//
//  Created by 熊培利 on 11-8-17.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityIndicatorView : UIView {
	UIActivityIndicatorView *_systemActivityIndicatorView;
}
@property (nonatomic, retain) UIActivityIndicatorView *systemActivityIndicatorView;

+ (void) showActivityIndicatorViewInParentView:(UIView *)view;
+ (void) hideActivityIndicatorView;
@end
