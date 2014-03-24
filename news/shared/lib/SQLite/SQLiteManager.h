//
//  SQLiteManager.h
//  news
//
//  Created by 熊培利 on 11-8-16.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "/usr/include/sqlite3.h"
#import "sqlite3.h"

@interface SQLiteManager : NSObject{
   sqlite3    *_database;
}
+ (SQLiteManager *)sharedInstance;

- (void) addLatest:(NSArray *)articles;
- (void) addTopNews:(NSArray *)articles;
- (void) addSearch:(NSArray *)articles;
- (void) addFavorites:(NSArray *)articles;

- (void) deleteSearch;
- (void) deleteFavorite:(int)articleID;
- (BOOL) isFavorite:(int)articleID;

- (NSDictionary *)getLatestStart:(int)start limit:(int)limit;
- (NSDictionary *)getTopNewsStart:(int)start limit:(int)limit;
- (NSDictionary *)getSearchStart:(int)start limit:(int)limit;
- (NSDictionary *)getFavoritesStart:(int)start limit:(int)limit;

- (NSDictionary *) getArticleById:(int)iId;
- (NSArray *)getAllThumbUrlStrings;
@end
