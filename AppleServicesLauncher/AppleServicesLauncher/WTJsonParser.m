//
//  WTJsonParser.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/28/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "WTJsonParser.h"

@implementation WTJsonParser

+(NSDictionary *)parseJson:(NSString *)json {
    if ([json isEqualToString:@"No commands"]) return nil;
    NSError *error = nil;
    id object = [NSJSONSerialization
                 JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                 options:0
                 error:&error];
    
    if(error) NSLog(@"Malformed json: %@", json);
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        return results;
    }
    return nil;
}

@end
