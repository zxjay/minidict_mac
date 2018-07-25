//
//  MDResultWindow.h
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/25.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface MDResultWindow : NSObject <WebFrameLoadDelegate>

@property (nonatomic, getter=isVisible, readonly) BOOL visible;

- (id)initWithFrame:(NSRect)rect;
- (void)moveTo:(NSRect)rect;
- (void)setIsVisible:(BOOL)isVisible;
- (void)orderFront;
- (void)showResult:(NSString *)word;

@end
