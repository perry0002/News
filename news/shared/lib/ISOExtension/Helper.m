//
//  Helper.m
//  news
//
//  Created by 熊培利 on 11-8-10.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import "Helper.h"
#import "NSString+MD5.h"

BOOL isSameDay(NSDate* date1, NSDate* date2) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
	
    return [comp1 day]   == [comp2 day] &&
	[comp1 month] == [comp2 month] &&
	[comp1 year]  == [comp2 year];
}


NSString *stringForDate(NSDate *date){
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMMM d, YYYY"];
	return [formatter stringFromDate:date];
}

NSString *stringForDate1(NSDate *date){
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MM.d.YYYY"];
	return [formatter stringFromDate:date];
}

void saveDataToFile(NSData *data, NSURL *url){
	NSString *urlString = [url absoluteString];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"image"];
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
	//NSString *imagePath = [urlString md5Hash];
    NSString *fileName = [NSString stringWithFormat:@"%@", [urlString md5Hash]];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    
	NSError *error = nil;
	[data writeToFile:filePath options:NSDataWritingAtomic error:&error];
}

NSData *loadDataFromFile(NSURL *url){
	NSString *urlString = [url absoluteString];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"image"];
    //[[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileName = [NSString stringWithFormat:@"%@", [urlString md5Hash]];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:filePath]) {
		NSError *error = nil;
		return [NSData dataWithContentsOfFile:filePath options:NSDataReadingMapped error:&error];
	}
	
	return nil;
	
}

NSString *pathForData(NSURL *url){
	NSString *urlString = [url absoluteString];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"image"];
    //[[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileName = [NSString stringWithFormat:@"%@", [urlString md5Hash]];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];

	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:filePath]) {
		return filePath;
	}
	
	return nil;
}

void deleteDataPath(NSURL *url){
    NSString *urlString = [url absoluteString];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"image"];

    NSString *fileName = [NSString stringWithFormat:@"%@", [urlString md5Hash]];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:&error];    
}


void removeAllThumbsExcept(NSArray *thumbs){
	LOG_METHOD
	NSMutableArray *md5Thumbs = [NSMutableArray arrayWithCapacity:0];
	for (NSString *thumb in thumbs) {
		NSString *fileName = [NSString stringWithFormat:@"%@", [thumb md5Hash]];
		[md5Thumbs addObject:fileName];
		LOG(@"%@",fileName);
	}
	
	LOG(@"------------")
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:@"image"];
	
	NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *allThumbs = [fileManager subpathsOfDirectoryAtPath:directoryPath error:&error];
	for (NSString *fileName in allThumbs) {
		LOG(@"%@", fileName);
		if (![md5Thumbs containsObject:fileName]) {
			LOG(@"deleted");
			//remove file
			NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
			[fileManager removeItemAtPath:filePath error:&error];
		}
		
	}
}

void listSubviewsOfView(UIView *view) {
	LOG(@"-------------------------------------")
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
	
    // Return if there are no subviews
    if ([subviews count] == 0) return;
	
    for (UIView *subview in subviews) {
		
        LOG(@"%@", [subview description]);
		
        // List the subviews of subview
        listSubviewsOfView(subview);
    }
}