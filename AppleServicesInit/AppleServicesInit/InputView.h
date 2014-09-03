//
//  InputView.h
//  AppleServicesInit
//
//  Created by James Pickering on 9/2/14.
//  Copyright (c) 2014 James Pickering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InputView : NSView

@property (unsafe_unretained) IBOutlet NSTextField *usernameField;
@property (unsafe_unretained) IBOutlet NSSecureTextField *passwordField;

+ (InputView *)inputViewWithUsername:(NSString *)username;

@end
