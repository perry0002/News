//
//  Helper.h
//  news
//
//  Created by 熊培利 on 11-8-10.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL isSameDay(NSDate* date1, NSDate* date2);
NSString *stringForDate(NSDate *date);
NSString *stringForDate1(NSDate *date);

void saveDataToFile(NSData *data, NSURL *url);
NSData *loadDataFromFile(NSURL *url);
NSString *pathForData(NSURL *url);
void deleteDataPath(NSURL *url);
void removeAllThumbsExcept(NSArray *thumbs);
void listSubviewsOfView(UIView *view);
