//
//  PYActivityIndicatorView.m
//  myActivityIndicator
//
//  Created by 熊培利 on 11-9-11.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import "PYActivityIndicator.h"


@implementation PYActivityIndicator

- (id) init{
	if (self = [super init]) {
		_numFins = 12;
		_finColors = calloc(_numFins, sizeof(UIColor*));
		_foreColor = [UIColor blackColor];
	}
	
	return self;
}


- (UIImage *) imageWithSize:(CGSize)size index:(int)index{
	UIGraphicsBeginImageContext(size);
	
	CGContextRef currentContext = UIGraphicsGetCurrentContext();	
    // Move the CTM so 0,0 is at the center of our bounds
    CGContextTranslateCTM(currentContext,size.width/2,size.height/2);
	
	CGFloat minAlpha = 0.01;
	CGFloat maxAlpha = 1.0;
	CGFloat currentAlpha = maxAlpha;
	
	int count = 0;
	int currentFinIndex = index;
	while (count<_numFins) {
		CGFloat newAlpha = currentAlpha;
        if (newAlpha < minAlpha)
            newAlpha = minAlpha;
        UIColor *oldColor = _finColors[currentFinIndex];
        _finColors[currentFinIndex] = [[_foreColor colorWithAlphaComponent:newAlpha] retain];
        [oldColor release];
		
		currentAlpha *= 0.85;
		
		currentFinIndex++;
		if (currentFinIndex==_numFins) {
			currentFinIndex = 0;
		}
		
		count++;
	}
	

	UIBezierPath *path = [[UIBezierPath alloc] init];
	//CGFloat lineWidth = 0.0859375 * theMaxSize; // should be 2.75 for 32x32
	//CGFloat lineStart = 0.234375 * theMaxSize; // should be 7.5 for 32x32
	//CGFloat lineEnd = 0.421875 * theMaxSize;  // should be 13.5 for 32x32
	CGFloat lineWidth = 2.75;//0.0859375 * theMaxSize; // should be 2.75 for 32x32
	CGFloat lineStart = 7.5;//0.234375 * theMaxSize; // should be 7.5 for 32x32
    CGFloat lineEnd = 13.5;//0.421875 * theMaxSize;  // should be 13.5 for 32x32
	[path setLineWidth:lineWidth];
	[path setLineCapStyle:kCGLineCapRound];
	[path moveToPoint:CGPointMake(0,lineStart)];
	[path addLineToPoint:CGPointMake(0,lineEnd)];
	
	for (int i=0; i<_numFins; i++) {
			[_finColors[i] set];
		
		[path stroke];
		
		// we draw all the fins by rotating the CTM, then just redraw the same segment again
		CGContextRotateCTM(currentContext, 6.282185/_numFins);
	}
	[path release];
	

	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

- (NSArray*) animationImagesWithSize:(CGSize)size{
	NSMutableArray *array = [NSMutableArray array];
	for (int i=0; i<_numFins; i++) {
		[array addObject:[self imageWithSize:size index:i]];
	}
	
	return array;
}
@end
