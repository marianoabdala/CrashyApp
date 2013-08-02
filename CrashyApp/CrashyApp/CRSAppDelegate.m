//
//  CRSAppDelegate.m
//  CrashyApp
//
//  Created by Mariano Abdala on 7/21/13.
//  Copyright (c) 2013 Zerously.com. All rights reserved.
//

#import "CRSAppDelegate.h"
#import "CRSViewController.h"

#define CRASH_NOTIFICATION_DELAY    6
#define CRASH_NOTIFICATION_CANCEL   5

#define ALERT_VIEW_SUPPORT_BUTTON_INDEX 1

@interface CRSAppDelegate () <
    UIAlertViewDelegate>

@property (strong, nonatomic) UILocalNotification *crashNotification;

- (void)cicleCrashNotifications;
- (void)scheduleCrashNotification;
- (void)cancelCrashNotification;
- (void)showSupportScreen;

@end

@implementation CRSAppDelegate

#pragma mark - Self
#pragma mark CRSAppDelegate ()
- (UILocalNotification *)crashNotification {
    
    if (_crashNotification == nil) {
        
        self.crashNotification =
        [[UILocalNotification alloc] init];
        
        self.crashNotification.fireDate =
        [NSDate dateWithTimeIntervalSinceNow:CRASH_NOTIFICATION_DELAY];
        
        self.crashNotification.alertBody =
        NSLocalizedString(@"CrashyApp has crashed. Can we be of assistance?", @"");
    }
    
    return _crashNotification;
}

- (void)scheduleCrashNotification {
    
    UIApplication *application =
    [UIApplication sharedApplication];
    
    [application scheduleLocalNotification:self.crashNotification];
    
    NSLog(@"Local crash notification scheduled to fire on %d seconds.", CRASH_NOTIFICATION_DELAY);
}

- (void)cancelCrashNotification {
    
    UIApplication *application =
    [UIApplication sharedApplication];
    
    [application cancelLocalNotification:self.crashNotification];
    
    self.crashNotification = nil;
    
    NSLog(@"Local crash notification was cancelled.");
}

- (void)cicleCrashNotifications {
    
    [self cancelCrashNotification];
    [self scheduleCrashNotification];
    
    [self performSelector:@selector(cicleCrashNotifications)
               withObject:nil
               afterDelay:CRASH_NOTIFICATION_CANCEL];
}

- (void)showSupportScreen {
    
    UINavigationController *navigationController =
    (UINavigationController *)self.window.rootViewController;
    
    UIViewController *viewController =
    navigationController.visibleViewController;
    
    if ([viewController class] == [CRSViewController class]) {
        
        [viewController performSegueWithIdentifier:@"showSupportScreen"
                                            sender:self];
    }
}

#pragma mark - Protocols
#pragma mark UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] != nil) {
        
        NSLog(@"App launched by opening the local crash notification. Showing the support screen.");
        
        [self showSupportScreen];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"Local crash notification received while the app was running. Showing alert view.");

    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                               message:notification.alertBody
                              delegate:self
                     cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                     otherButtonTitles:NSLocalizedString(@"Support", @""), nil];
    
    [alertView show];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self cancelCrashNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [self cicleCrashNotifications];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == ALERT_VIEW_SUPPORT_BUTTON_INDEX) {
        
        [self showSupportScreen];
    }
}

@end
