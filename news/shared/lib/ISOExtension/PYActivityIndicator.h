//
//  PYActivityIndicatorView.h
//  myActivityIndicator
//
//  Created by 熊培利 on 11-9-11.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYActivityIndicator : NSObject {
	int _numFins;
	UIColor **_finColors;
	
	UIColor *_foreColor;
}

- (NSArray*) animationImagesWithSize:(CGSize)size;
@end
