//
//  AppDelegate.m
//  PotTheBall
//
//  Created by PC on 6/1/15.
//  Copyright (c) 2015 Randel Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "IAPStore.h"
#import "GameNavigationController.h"



#import "AdHelper.h"

#import <BlocksKit/BlocksKit.h>







@interface AppDelegate ()
@property BOOL enteringFromForeground;


@property BOOL isshowingAd;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPStore sharedManager]];
    
    [IAPStore sharedManager].productIdentifiers = [[NSSet setWithArray:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"IPA_ProductIdentifiers"]] mutableCopy];
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector (storeDidChange:)
     name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
     object: [NSUbiquitousKeyValueStore defaultStore]];
    
    // get changes that might have happened while this
    // instance of your app wasn't running
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    NSLog(@"simple print--lunach---bonus count------{%f}", [[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"]);
    
    [[AdHelper sharedManager] loadAdNetworks];
    
    if ([AdHelper shouldShowInterstitialOnStartUp]) {
        if ([AdHelper shouldShowAdmobInterstitialOnStartUp]) {
            [[AdHelper sharedManager] showAdmobInterstitial];
        }
        if ([AdHelper shouldShowChartboostInterstitialOnStartUp]) {
            [[AdHelper sharedManager] showChartboostInterstitial];
        }
        
    }
    
    return YES;
}

- (void)storeDidChange:(NSNotification *)notification
{
    // Retrieve the changes from iCloud
    NSLog(@"simple print-----erferer bonus count------{%f}", [[NSUbiquitousKeyValueStore defaultStore] doubleForKey:@"BonusBallsCount"]);
    

}

- (BOOL) isICloudAvailable
{
    // Make sure a correct Ubiquity Container Identifier is passed
    id iCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if ( iCloudToken != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPStore sharedManager]];
    
//    self.enteringFromForeground = YES;
    
    if ([AdHelper shouldShowInterstitialOnEnterForeground]) {
        [NSTimer bk_scheduledTimerWithTimeInterval:0.1 block:^(NSTimer *timer) {
            
            if ([AdHelper shouldShowAdmobInterstitialOnEnterForeground]) {
                [[AdHelper sharedManager] showAdmobInterstitial];
            }
            if ([AdHelper shouldShowChartboostInterstitialOnEnterForeground]) {
                [[AdHelper sharedManager] showChartboostInterstitial];
            }
            
        } repeats:NO];
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPStore sharedManager]];
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
