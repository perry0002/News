//
//  BaseTableViewCell.m
//  news
//
//  Created by Perry Xiong on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Helper.h"

UIImage *whiteBlackgroundImageWithSize(CGSize size){
	UIGraphicsBeginImageContext(size);
	
	CGContextRef currentContext = UIGraphicsGetCurrentContext();	
    // Move the CTM so 0,0 is at the center of our bounds
    CGContextTranslateCTM(currentContext,size.width/2,size.height/2);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@interface BaseTableViewCell()
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) PYActivityIndicator *ai;
@property (nonatomic, retain) UIImageView *sImageView;
@end

@implementation BaseTableViewCell
@synthesize urlString = _urlString;
@synthesize ai = _ai;
@synthesize sImageView = _sImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _loaded = NO;

		PYActivityIndicator *a = [[PYActivityIndicator alloc] init];
		self.ai = a;
		[a release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
	_loaded = NO;
	self.sImageView.image = nil;
	[self.sImageView stopAnimating];
	self.sImageView.animationImages = nil;
    //[[EGOImageLoader sharedImageLoader] cancelLoadForURL:[NSURL URLWithString:self.urlString]];
    [[EGOImageLoader sharedImageLoader] removeObserver:self];
}


- (void) dealloc{
	[_urlString release];
	[_sImageView release];
	
	[_ai release];
	
	[super dealloc];
}


- (void) showImageView:(NSString *)urlString{
    self.urlString = urlString;
	self.imageView.image = whiteBlackgroundImageWithSize(CGSizeMake(63, 63));
	
	UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 63, 63)];
	[self.imageView addSubview:newImageView];
	[newImageView release];
	self.sImageView = newImageView;
    NSData *imageData = loadDataFromFile([NSURL URLWithString:urlString]);
    if (imageData != nil) {
        self.sImageView.image = [UIImage imageWithData:imageData];
        _loaded = YES;
    }else{
        _loaded = NO;
		 self.sImageView.image = [UIImage imageNamed:@"tableCellPlacehoder"];
		self.sImageView.animationImages = [self.ai animationImagesWithSize:CGSizeMake(63, 63)];
		self.sImageView.animationDuration = 0.8;
		[self.sImageView startAnimating];
    }
}

- (void) startLoadingImage:(NSString *)urlString{
    self.urlString = urlString;
    if (!_loaded) {
		self.sImageView.image = [UIImage imageNamed:@"tableCellPlacehoder"];
		self.sImageView.animationImages = [self.ai animationImagesWithSize:CGSizeMake(63, 63)];
		self.sImageView.animationDuration = 0.8;
		[self.sImageView startAnimating];
        [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:urlString] observer:self];
    }else{
        NSData *imageData = loadDataFromFile([NSURL URLWithString:urlString]);
        if (imageData != nil) {
            self.sImageView.image = [UIImage imageWithData:imageData];
            _loaded = YES;
        }else{
            _loaded = NO;
            self.sImageView.image = [UIImage imageNamed:@"tableCellPlacehoder"];
        }
    }
}

- (void) cancelLoadingImage:(NSString *)urlString{
    if (_loaded) {
        return;
    }
    
    [[EGOImageLoader sharedImageLoader] cancelLoadForURL:[NSURL URLWithString:urlString]];
}

#pragma <EGOImageLoaderObserver> Methods
- (void)imageLoaderDidLoad:(NSNotification*)notification {
    _loaded = YES;
	[self.sImageView stopAnimating];
	
    NSDictionary *userInfo = notification.userInfo;
    UIImage *image = [userInfo objectForKey:@"image"];
    self.sImageView.image = image;
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification{
	[self.sImageView stopAnimating];
	self.sImageView.animationImages = nil;
}
@end
