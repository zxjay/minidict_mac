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
    NSArray *tl;
    NSApplication *app = [NSApplication sharedApplication];
    [[NSBundle mainBundle] loadNibNamed:@"MainMenu" owner:app topLevelObjects:&tl];
    
    AppDelegate *appDelegate = [AppDelegate new];
    [app setDelegate:appDelegate];
    [app run];
    
    return 0;
}
