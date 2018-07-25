//
//  AppDelegate.m
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/19.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "MDMainWindow.h"

@implementation AppDelegate {
    MDMainWindow *mWindow;
}

-(id)init
{
    if (self = [super init]) {
        mWindow = [[MDMainWindow alloc] init];
    }
    
    return self;
}

- (void)applicationDidHide:(NSNotification *)notification
{
    [mWindow notifyApplicationDidHide];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{

}

@end
