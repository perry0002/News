//
//  CommonDef.h
//  news
//
//  Created by Perry Xiong on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef news_CommonDef_h
#define news_CommonDef_h

//#define kServerURL @"http://www.baidu.com"
//#define kServerURL @"http://passport.hoopchina.com/?m=interface&a=login"
//#define kServerURL @"http://www.stylesight.com/news/m/"
#define kLogin @"login"
#define kLogout @"logout"
#define kGetArticles @"getArticles"
#define kGetFavorites @"getFavorites"
#define kSetFavorites @"setFavorite"
#define kGetTopNews @"getTopNews"
#define kGetPromo @"getPromo"
#define kHttpSuccess @"success"
#define kID @"id"
#define kIsFavorite @"favorite"

#define kArticleId @"id"
#define kArticleTitle @"title"
#define kArticleThumb @"thumb"
#define kArticleExcerpt @"excerpt"
#define kArticleBody @"body"
#define kArticleDate @"date"

extern NSString *kServerURL;
extern NSString *const kLogOutNotification;
extern NSString *const kSetFavoriteNotification;
extern NSString *const kRemoveFavoriteNotification;

extern const NSUInteger cLimit;
extern const NSUInteger chttpStatusCodeOK;
extern int cFontSizeLevel;
extern BOOL cAdmin;
extern BOOL cNetWorkAvailable;
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif
