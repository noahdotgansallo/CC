//
//  WTHTTPApi.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "WTHTTPApi.h"

@implementation WTHTTPApi



+ (NSString*)encodeData:(NSDictionary*)data usingPrependedQuestionMark:(BOOL)doPrependQuestionMark {
    if (data == nil) {
        return @"";
    }
    NSMutableString *ret = [[NSMutableString alloc] init];
    int i=0;
    for (NSString *param in data) {
        if (i!=0) {
            [ret appendString:@"&"];
        }
        else if (i==0 && doPrependQuestionMark) {
            [ret appendString:@"?"];
        }
        [ret appendString:[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [ret appendString:@"="];
        NSString *tmp = data[param];
        NSString *tmpUrl = [tmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ret appendString:tmpUrl];
        ++i;
    }
    return (NSString*)ret;
}

- (NSString *)httpGetRequest:(NSString*) url usingData:(NSDictionary*)data {
    NSString *newUrl = nil;
    if (data!=nil) {
        newUrl = [NSString stringWithFormat:@"%@%@", url, [WTHTTPApi encodeData:data usingPrependedQuestionMark:YES]];
    }
    else {
        newUrl = url;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:newUrl]];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return nil;
    }
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

- (NSString *)httpPostRequest:(NSString *) url usingGetData:(NSDictionary *)httpGetData usingPostData:(NSDictionary *)httpPostData {
    NSString *newUrl = nil;
    if (httpGetData != nil) {
        newUrl = [NSString stringWithFormat:@"%@%@", url, [WTHTTPApi encodeData:httpGetData usingPrependedQuestionMark:YES]];
    }
    else {
        newUrl = url;
    }
    NSString *postData = [WTHTTPApi encodeData:httpPostData usingPrependedQuestionMark:NO];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)" forHTTPHeaderField:@"User-Agent"];
    [request setURL:[NSURL URLWithString:newUrl]];
    NSError *error;
    NSHTTPURLResponse *responseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}


@end
