//
//  NSString+MD5.h
//  TsoApp
//
//  Created by houwf on 11-4-20.
//  Copyright 2011 PIONEER CORPORATION. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface NSString (NSString_M5)

- (NSString *)md5Hash;

@end
