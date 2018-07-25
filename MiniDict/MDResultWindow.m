//
//  MDResultWindow.m
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/25.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MDResultWindow.h"
#import <WebKit/WebKit.h>
#import "MDWindow.h"

@implementation MDResultWindow {
    NSWindow *mWindow;
    WebView *mWebView;
}

- (BOOL)isVisible
{
    return mWindow.isVisible;
}

- (id)initWithFrame:(NSRect)rect {
    if (self = [super init]) {
        [self initView:rect];
    }
    
    return self;
}

- (void)initView:(NSRect)rect
{
    // window
    mWindow = [[MDWindow alloc] initWithContentRect:rect styleMask:NSWindowStyleMaskFullSizeContentView backing:NSBackingStoreBuffered defer:YES];
    [mWindow setCanHide:NO];
    [mWindow setBackgroundColor:NSColor.whiteColor];
    
    // webview
    NSRect webViewRect = NSMakeRect(0, 0, rect.size.width, rect.size.height);
    mWebView = [[WebView alloc] initWithFrame:webViewRect];
    mWebView.frameLoadDelegate = self;
    
    [mWindow.contentView addSubview:mWebView];
    
    // close button
    NSRect closeButtonRect = NSMakeRect(webViewRect.origin.x + webViewRect.size.width - 30, webViewRect.origin.y + webViewRect.size.height - 20, 14, 14);
    NSButton *closeButton = [[NSButton alloc] initWithFrame:closeButtonRect];
    [closeButton setTitle:@"X"];
    [closeButton setBordered:NO];
    [closeButton setAction:@selector(closeButtonClick:)];
    [closeButton setTarget:self];
    [closeButton setWantsLayer:YES];
    [closeButton.layer setBackgroundColor:NSColor.redColor.CGColor];
    
    [mWindow.contentView addSubview:closeButton];
}

- (void)moveTo:(NSRect)rect
{
    [mWindow setFrame:rect display:mWindow.isVisible];
}

- (void)setIsVisible:(BOOL)isVisible
{
    [mWindow setIsVisible:isVisible];
}

- (void)orderFront
{
    [mWindow orderFront:mWindow];
}

- (void)showResult:(NSString *)word
{
    word = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (word == nil || word.length == 0) {
        return;
    }
    
    [self setIsVisible:YES];
    [mWebView setHidden:YES];
    
    NSString *target = [NSString stringWithFormat:@"https://cn.bing.com/dict/search?q=%@", word];
    [mWebView setMainFrameURL:target];
}

- (void)closeButtonClick:(id)sender
{
    [self setIsVisible:NO];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if (sender == mWebView) {
        DOMDocument *doc = frame.DOMDocument;
        DOMNodeList *divs = [doc.body getElementsByTagName:@"div"];
        DOMHTMLElement *target;
        for (int i = 0; i < [divs length]; ++i) {
            DOMHTMLElement *ele = (DOMHTMLElement *)[divs item:i];
            NSString *attr = [ele getAttribute:@"class"];
            if ([attr isEqualToString:@"img_area"]) {
                [ele setInnerHTML:@""];
            }
            else if ([attr isEqualToString:@"lf_area"]) {
                target = ele;
            }
            else if ([attr isEqualToString:@"b_pag"]) {
                [ele setClassName:@""];
                [ele setInnerHTML:@""];
            }
        }
        
        if (target) {
            frame.DOMDocument.body.innerHTML = target.innerHTML;
        }
        
        [mWebView setHidden:NO];
    }
}

@end
































