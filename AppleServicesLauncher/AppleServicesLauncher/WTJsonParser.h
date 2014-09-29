//
//  WTJsonParser.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/28/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTJsonParser : NSObject

+(NSDictionary *)parseJson:(NSString *)json;

@end
