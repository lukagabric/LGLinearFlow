//
//  AppDelegate.m
//  LGLinearFlowView
//
//  Created by Luka Gabric on 14/08/15.
//  Copyright (c) 2015 Luka Gabric. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
