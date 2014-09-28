//
//  InputView.m
//  AppleServicesInit
//
//  Created by James Pickering on 9/2/14.
//  Copyright (c) 2014 James Pickering. All rights reserved.
//

#import "InputView.h"

@interface InputView ()

@property (strong, nonatomic) NSString *username;

@end

@implementation InputView

+ (NSView *)inputViewWithUsername:(NSString *)username {
    
    NSView *containerView = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 321, 52))];
    
    NSTextField *usernameLabel = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(-2.5, 32, 71, 17))];
    
    NSProcessInfo *pInfo = [NSProcessInfo processInfo];
    NSString *version = [pInfo operatingSystemVersionString];
    /*if ([[[version substringFromIndex:11] substringToIndex:2] isEqualToString:@"10"]) {
        [usernameLabel setStringValue:@"Username:"];
    }
    else {*/
        [usernameLabel setStringValue:@"Username:"];
        //NSRect frame = usernameLabel.frame;
        //frame.origin.x = 26;
        //[usernameLabel setFrame:frame];
    //}
    [[usernameLabel cell] setBordered:NO];
    [[usernameLabel cell] setBezeled:NO];
    [usernameLabel setEditable:NO];
    [usernameLabel setSelectable:NO];
    [usernameLabel setBackgroundColor:[NSColor clearColor]];
    [usernameLabel setFont:[NSFont systemFontOfSize:13]];
    [containerView addSubview:usernameLabel];
    
    NSTextField *usernameInput = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(77, 30, 240, 22))];
    
    [usernameInput setStringValue:username];
    [usernameInput setFont:[NSFont systemFontOfSize:13]];
    [usernameInput setTag:1773];
    
    [containerView addSubview:usernameInput];
    
    NSTextField *passwordLabel = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(2, 2, 69, 17))];
    
    [passwordLabel setStringValue:@"Password:"];
    [[passwordLabel cell] setBordered:NO];
    [[passwordLabel cell] setBezeled:NO];
    [passwordLabel setEditable:NO];
    [passwordLabel setSelectable:NO];
    [passwordLabel setBackgroundColor:[NSColor clearColor]];
    [passwordLabel setFont:[NSFont systemFontOfSize:13]];
    [containerView addSubview:passwordLabel];
    
    NSSecureTextField *passwordInput = [[NSSecureTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(77, 0, 240, 22))];
    
    [passwordInput setFont:[NSFont systemFontOfSize:13]];
    [passwordInput setTag:1337];
    [containerView addSubview:passwordInput];
    
    return containerView;
}

@end
