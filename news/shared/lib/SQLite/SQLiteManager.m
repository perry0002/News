//
//  SQLiteManager.m
//  news
//
//  Created by 熊培利 on 11-8-16.
//  Copyright 2011 先锋商泰. All rights reserved.
//

#import "SQLiteManager.h"
#define PATH_SQLiteFile @"news.sqlite3"
static SQLiteManager *_instance = nil;

/*
void updateDone(void *info,int updateType,char const *dataBaseName,char const *tableName,sqlite3_int64 rowId){
    //LOG_METHOD
    //LOG(@"%d, %s   %s, %lld",updateType,dataBaseName,tableName, rowId);
    if (updateType == SQLITE_DELETE) {  //delete
        NSDictionary * dic = [[SQLiteManager sharedInstance] getArticleById:rowId];
        //NSLog(@"%@", dic);
    }
}
*/
@interface SQLiteManager ()
- (NSString *)dataFilePath;
- (void) deleteAll:(NSString *)tableName;
- (int) getTotal:(NSString *)tableName;

@end

@implementation SQLiteManager

+ (SQLiteManager *)sharedInstance{
	
	@synchronized(self) {
		if (nil == _instance) {
			_instance = [[SQLiteManager alloc] init];
		}
	}	
	
	return _instance;
}

- (void)createTables{
	//@@@@@@@create articles table      
	char *errorMsg;
	
	NSError *error = nil;
	NSString *createSQL = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SQL_tablesCreate" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];

	if (sqlite3_exec (_database, [createSQL  UTF8String],
					  NULL, NULL, &errorMsg) != SQLITE_OK) {
		//LOG(@"%s", errorMsg);
		sqlite3_close(_database);
		//NSAssert1(0, @"Error creating table: %s", errorMsg);
	}
}


- (id)init {
	self = [super init];
	if (self != nil) {
		if (sqlite3_open([[self dataFilePath] UTF8String], &_database)
			!= SQLITE_OK) {
			sqlite3_close(_database);
			//NSAssert(0, @"Failed to open database");
		}
		
		[self createTables];
        
        //sqlite3_update_hook(_database, &updateDone,nil);
	}

	return self;
}

#pragma mark ---
#pragma mark PrivateMethods
- (NSString *)dataFilePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:PATH_SQLiteFile];
}


- (void) addLatest:(NSArray *)articles{
    for (NSDictionary *article in articles) {
        //add articles to articles table
        char *update = "INSERT INTO articles (ID,title,thumb,excerpt,body,dateFrom1970)"\
        "VALUES"\
        "(?,?,?,?,?,?)";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
			NSNumber *n = [article objectForKey:kArticleId];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  1, [n intValue]);
			
			NSString *string = [article objectForKey:kArticleTitle];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 2, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleThumb];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 3, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleExcerpt];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 4, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleBody];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 5, [string UTF8String], -1, NULL);
			
			n = [article objectForKey:kArticleDate];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  6, [n intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            //LOG(@"add articles %s",sqlite3_errmsg(_database));
        }
        sqlite3_finalize(stmt);
        
        //add articleID to latest table
        update = "INSERT INTO latest (articleID)"\
        "VALUES"\
        "(?)";
        //sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt,  1, [[article objectForKey:kArticleId] intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            //LOG(@"add latest %s", sqlite3_errmsg(_database));
        }
        sqlite3_finalize(stmt);
    }
}

- (void) addTopNews:(NSArray *)articles{
    for (NSDictionary *article in articles) {
        //add articles to articles table
        char *update = "INSERT INTO articles (ID,title,thumb,excerpt,body,dateFrom1970)"\
        "VALUES"\
        "(?,?,?,?,?,?)";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
            NSNumber *n = [article objectForKey:kArticleId];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  1, [n intValue]);
			
			NSString *string = [article objectForKey:kArticleTitle];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 2, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleThumb];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 3, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleExcerpt];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 4, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleBody];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 5, [string UTF8String], -1, NULL);
			
			n = [article objectForKey:kArticleDate];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  6, [n intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
        }
        sqlite3_finalize(stmt);
        
        //add articleID to latest table
        update = "INSERT INTO topnews (articleID)"\
        "VALUES"\
        "(?)";
        sqlite3_stmt *stmt1;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt1, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt1,  1, [[article objectForKey:kArticleId] intValue]);
        }
        if (sqlite3_step(stmt1) != SQLITE_DONE){
        }
        sqlite3_finalize(stmt1);
    }

}

- (void) addSearch:(NSArray *)articles{
    for (NSDictionary *article in articles) {
        //add articles to articles table
        char *update = "INSERT INTO articles (ID,title,thumb,excerpt,body,dateFrom1970)"\
        "VALUES"\
        "(?,?,?,?,?,?)";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
            NSNumber *n = [article objectForKey:kArticleId];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  1, [n intValue]);
			
			NSString *string = [article objectForKey:kArticleTitle];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 2, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleThumb];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 3, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleExcerpt];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 4, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleBody];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 5, [string UTF8String], -1, NULL);
			
			n = [article objectForKey:kArticleDate];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  6, [n intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            
        }
        sqlite3_finalize(stmt);
        
        //add articleID to latest table
        update = "INSERT INTO search (articleID)"\
        "VALUES"\
        "(?)";
        //sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt,  1, [[article objectForKey:kArticleId] intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            
        }
        sqlite3_finalize(stmt);
    }

}

- (void) addFavorites:(NSArray *)articles{
    for (NSDictionary *article in articles) {
        //add articles to articles table
        char *update = "INSERT INTO articles (ID,title,thumb,excerpt,body,dateFrom1970)"\
        "VALUES"\
        "(?,?,?,?,?,?)";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
            NSNumber *n = [article objectForKey:kArticleId];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  1, [n intValue]);
			
			NSString *string = [article objectForKey:kArticleTitle];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 2, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleThumb];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 3, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleExcerpt];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 4, [string UTF8String], -1, NULL);
			
			string = [article objectForKey:kArticleBody];
			if ([string isKindOfClass:[NSNull class]]) {
				string = @"";
			}
            sqlite3_bind_text(stmt, 5, [string UTF8String], -1, NULL);
			
			n = [article objectForKey:kArticleDate];
			if ([n isKindOfClass:[NSNull class]]) {
				n = [NSNumber numberWithInt:0];
			}
            sqlite3_bind_int(stmt,  6, [n intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
			//LOG(@"add articles %s",sqlite3_errmsg(_database));
        }
        sqlite3_finalize(stmt);
        
        //add articleID to latest table
        update = "INSERT INTO favorites (articleID)"\
        "VALUES"\
        "(?)";
        //sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(_database, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt,  1, [[article objectForKey:kArticleId] intValue]);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE){
            //LOG(@"add favorite %s",sqlite3_errmsg(_database));
        }
        sqlite3_finalize(stmt);
    }
}

- (NSDictionary *)getLatestStart:(int)start limit:(int)limit{
    NSMutableDictionary *rt = nil;
    int total = [self getTotal:@"latest"];
    if (total == 0) {
        return  rt;
    }
    
    rt = [NSMutableDictionary dictionaryWithCapacity:3];
    [rt setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
    [rt setValue:[NSNumber numberWithInt:total] forKey:@"total"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles WHERE ID IN (SELECT articleID FROM view_latest ORDER BY dateFrom1970 desc LIMIT %d,%d) ORDER BY dateFrom1970 desc",start,limit];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles"];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM latest"];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSMutableArray *articles = [NSMutableArray arrayWithCapacity:0];
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:6];
            
            //0:ID
            int iID = sqlite3_column_int(stmt, 0);
            [mDic setValue:[NSNumber numberWithInt:iID] forKey:kArticleId];
            
            //title
            char *text = (char*)sqlite3_column_text(stmt, 1);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleTitle];
            }
            
            //thumb
            text = (char*)sqlite3_column_text(stmt, 2);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleThumb];
            }
            
            //excerpt
            text = (char*)sqlite3_column_text(stmt, 3);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleExcerpt];
            }
            
            //body
            text = (char*)sqlite3_column_text(stmt, 4);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleBody];
            }
            
            int date = sqlite3_column_int(stmt, 5);
            [mDic setValue:[NSNumber numberWithInt:date] forKey:kArticleDate];
            
            [articles addObject:mDic];
        }
        
        [rt setValue:articles forKey:@"articles"];
 
	}else {

	}
	sqlite3_finalize(stmt);
	
	return rt;
}

- (NSDictionary *)getTopNewsStart:(int)start limit:(int)limit{
    NSMutableDictionary *rt = nil;
    int total = [self getTotal:@"topnews"];
    if (total == 0) {
        return  rt;
    }
    
    rt = [NSMutableDictionary dictionaryWithCapacity:3];
    [rt setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
    [rt setValue:[NSNumber numberWithInt:total] forKey:@"total"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles WHERE ID IN (SELECT articleID FROM view_topnews ORDER BY dateFrom1970 desc LIMIT %d,%d) ORDER BY dateFrom1970 desc",start,limit];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles"];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM latest"];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSMutableArray *articles = [NSMutableArray arrayWithCapacity:0];
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:6];
            
            //0:ID
            int iID = sqlite3_column_int(stmt, 0);
            [mDic setValue:[NSNumber numberWithInt:iID] forKey:kArticleId];
            
            //title
            char *text = (char*)sqlite3_column_text(stmt, 1);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleTitle];
            }
            
            //thumb
            text = (char*)sqlite3_column_text(stmt, 2);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleThumb];
            }
            
            //excerpt
            text = (char*)sqlite3_column_text(stmt, 3);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleExcerpt];
            }
            
            //body
            text = (char*)sqlite3_column_text(stmt, 4);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleBody];
            }
            
            int date = sqlite3_column_int(stmt, 5);
            [mDic setValue:[NSNumber numberWithInt:date] forKey:kArticleDate];
            
            [articles addObject:mDic];
        }
		
        [rt setValue:articles forKey:@"articles"];
	}else {
		
	}
	sqlite3_finalize(stmt);
	
	return rt;
}

- (NSDictionary *)getSearchStart:(int)start limit:(int)limit{
    NSMutableDictionary *rt = nil;
    int total = [self getTotal:@"search"];
    if (total == 0) {
        return  rt;
    }
    
    rt = [NSMutableDictionary dictionaryWithCapacity:3];
    [rt setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
    [rt setValue:[NSNumber numberWithInt:total] forKey:@"total"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles WHERE ID IN (SELECT articleID FROM view_search ORDER BY dateFrom1970 desc LIMIT %d,%d) ORDER BY dateFrom1970 desc",start,limit];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles"];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM latest"];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSMutableArray *articles = [NSMutableArray arrayWithCapacity:0];
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:6];
            
            //0:ID
            int iID = sqlite3_column_int(stmt, 0);
            [mDic setValue:[NSNumber numberWithInt:iID] forKey:kArticleId];
            
            //title
            char *text = (char*)sqlite3_column_text(stmt, 1);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleTitle];
            }
            
            //thumb
            text = (char*)sqlite3_column_text(stmt, 2);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleThumb];
            }
            
            //excerpt
            text = (char*)sqlite3_column_text(stmt, 3);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleExcerpt];
            }
            
            //body
            text = (char*)sqlite3_column_text(stmt, 4);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleBody];
            }
            
            int date = sqlite3_column_int(stmt, 5);
            [mDic setValue:[NSNumber numberWithInt:date] forKey:kArticleDate];
            
            [articles addObject:mDic];
        }
        
        [rt setValue:articles forKey:@"articles"];
		
	}else {
		
	}
	sqlite3_finalize(stmt);
	
	return rt;
}

- (NSDictionary *)getFavoritesStart:(int)start limit:(int)limit{
	NSMutableDictionary *rt = nil;
    int total = [self getTotal:@"favorites"];
    if (total == 0) {
        return  rt;
    }
    
    rt = [NSMutableDictionary dictionaryWithCapacity:3];
    [rt setValue:[NSNumber numberWithBool:YES] forKey:@"success"];
    [rt setValue:[NSNumber numberWithInt:total] forKey:@"total"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles WHERE ID IN (SELECT articleID FROM view_favorites ORDER BY dateFrom1970 desc LIMIT %d,%d) ORDER BY dateFrom1970 desc",start,limit];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles"];
    //NSString *query = [NSString stringWithFormat:@"SELECT * FROM latest"];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSMutableArray *articles = [NSMutableArray arrayWithCapacity:0];
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:6];
            
            //0:ID
            int iID = sqlite3_column_int(stmt, 0);
            [mDic setValue:[NSNumber numberWithInt:iID] forKey:kArticleId];
            
            //title
            char *text = (char*)sqlite3_column_text(stmt, 1);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleTitle];
            }
            
            //thumb
            text = (char*)sqlite3_column_text(stmt, 2);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleThumb];
            }
            
            //excerpt
            text = (char*)sqlite3_column_text(stmt, 3);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleExcerpt];
            }
            
            //body
            text = (char*)sqlite3_column_text(stmt, 4);
            if (nil != text && 0 != *text) {
                [mDic setValue:[NSString stringWithUTF8String:text] forKey:kArticleBody];
            }
            
            int date = sqlite3_column_int(stmt, 5);
            [mDic setValue:[NSNumber numberWithInt:date] forKey:kArticleDate];
            
            [articles addObject:mDic];
        }
        
        [rt setValue:articles forKey:@"articles"];
		
	}else {
		
	}
	sqlite3_finalize(stmt);
	
	return rt;
}

- (NSDictionary *) getArticleById:(int)iId{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM articles WHERE ID = %d",iId];
    NSMutableDictionary *ret = nil;
    
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            ret = [NSMutableDictionary dictionaryWithCapacity:6];
            
            //0:ID
            int iID = sqlite3_column_int(stmt, 0);
            [ret setValue:[NSNumber numberWithInt:iID] forKey:kArticleId];
            
            //title
            char *text = (char*)sqlite3_column_text(stmt, 1);
            if (nil != text && 0 != *text) {
                [ret setValue:[NSString stringWithUTF8String:text] forKey:kArticleTitle];
            }
            
            //thumb
            text = (char*)sqlite3_column_text(stmt, 2);
            if (nil != text && 0 != *text) {
                [ret setValue:[NSString stringWithUTF8String:text] forKey:kArticleThumb];
            }
            
            //excerpt
            text = (char*)sqlite3_column_text(stmt, 3);
            if (nil != text && 0 != *text) {
                [ret setValue:[NSString stringWithUTF8String:text] forKey:kArticleExcerpt];
            }
            
            //body
            text = (char*)sqlite3_column_text(stmt, 4);
            if (nil != text && 0 != *text) {
                [ret setValue:[NSString stringWithUTF8String:text] forKey:kArticleBody];
            }
            
            int date = sqlite3_column_int(stmt, 5);
            [ret setValue:[NSNumber numberWithInt:date] forKey:kArticleDate];
        }

		
	}else {
		
	}
	sqlite3_finalize(stmt);
	
	return ret;
}


- (NSArray *)getAllThumbUrlStrings{
	NSString *query = [NSString stringWithFormat:@"SELECT thumb FROM articles"];
    NSMutableArray *ret= nil;
    
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		ret = [NSMutableArray arrayWithCapacity:0];
		while (sqlite3_step(stmt) == SQLITE_ROW) { 
            //thumb url string
            char *text = (char*)sqlite3_column_text(stmt, 0);
            if (nil != text && 0 != *text) {
                [ret addObject:[NSString stringWithUTF8String:text]];
            }
        }
		
		
	}else {
		
	}
	sqlite3_finalize(stmt);
	
	return ret;
}

- (void) deleteSearch{
	[self deleteAll:@"search"];
}


- (void) deleteFavorite:(int)articleID{
	NSString *query = [NSString stringWithFormat:@"DELETE FROM favorites WHERE articleID=%d",articleID];
	sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        //LOG(@"delete OK")
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        //LOG(@"delete favorite %s",sqlite3_errmsg(_database));
    }
    sqlite3_finalize(stmt);
}


- (BOOL) isFavorite:(int)articleID{
	BOOL ret = NO;
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM favorites WHERE articleID=%d",articleID];
	sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) { 
            ret = YES;
        }
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        //LOG(@"delete favorite %s",sqlite3_errmsg(_database));
    }
    sqlite3_finalize(stmt);
	
	return ret;
}

- (void) deleteAll:(NSString *)tableName{
    NSString *update = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    //char *update = "DELETE FROM aricles";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [update UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        //LOG(@"delete OK")
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        
    }
    sqlite3_finalize(stmt);
}



- (int) getTotal:(NSString *)tableName{
    int total = 0;
    
    NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM %@",tableName];
    //char *update = "DELETE FROM aricles";
	//NSString *query = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;"];
    sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
            //total
            total = sqlite3_column_int(stmt, 0);
        }
	}else {
		
	}
	sqlite3_finalize(stmt);
    
    return total;
}

@end
