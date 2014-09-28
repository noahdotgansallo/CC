//
//  WTHTTPApi.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHTTPApi : NSObject

+ (NSString*)encodeData:(NSDictionary*)data usingPrependedQuestionMark:(BOOL)doPrependQuestionMark;
- (NSString *)httpGetRequest:(NSString*)url usingData:(NSDictionary*)data;
- (NSString *)httpPostRequest:(NSString *)url usingGetData:(NSDictionary *)httpGetData usingPostData:(NSDictionary *)httpPostData;
@end
