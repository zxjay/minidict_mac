//
//  main.m
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/19.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[])
{
    NSApplication *app = [NSApplication sharedApplication];
    [app setDelegate:[AppDelegate new]];
    [app run];
    
    return 0;
}
