//
//  MDMainWindow.m
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/25.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MDMainWindow.h"
#import "MDWindow.h"
#import "MDResultWindow.h"
#import "MDComboBoxCell.h"

#define UI_MAIN_WIDTH    300
#define UI_MAIN_HEIGHT   27
#define UI_RESULT_HEIGHT 500

@implementation MDMainWindow {
    NSComboBox *mComboBox;
    NSWindow *mWindow;
    MDResultWindow *mResultWindow;
}

- (id)init
{
    if (self = [super init]) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    // main window
    CGFloat mainMenuHeight = [NSStatusBar systemStatusBar].thickness + 1;
    NSRect mainScreenRect = [NSScreen mainScreen].frame;
    NSRect mdWindowRect;
    mdWindowRect.origin = CGPointMake(mainScreenRect.size.width - UI_MAIN_WIDTH * 2, mainScreenRect.size.height - mainMenuHeight - UI_MAIN_HEIGHT);
    mdWindowRect.size = CGSizeMake(UI_MAIN_WIDTH, UI_MAIN_HEIGHT);
    
    mWindow = [[MDWindow alloc] initWithContentRect:mdWindowRect styleMask:NSWindowStyleMaskFullSizeContentView backing:NSBackingStoreBuffered defer:YES];
    mWindow.backgroundColor = NSColor.greenColor;
    mWindow.movableByWindowBackground = YES;
    mWindow.delegate = self;
    [mWindow setLevel:NSMainMenuWindowLevel];
    [mWindow setCanHide:NO];
    
    // combobox
    NSRect comboBoxRect = NSMakeRect(10, 0, UI_MAIN_WIDTH - 17, UI_MAIN_HEIGHT);
    mComboBox = [[NSComboBox alloc] initWithFrame:comboBoxRect];
    NSComboBoxCell *comboBoxCell = [MDComboBoxCell new];
    [comboBoxCell setUsesSingleLineMode:YES];
    mComboBox.cell = comboBoxCell;
    [mComboBox setMaximumNumberOfLines:1];
    [mComboBox setEditable:YES];
    [mComboBox setStringValue:@""];
    mComboBox.focusRingType = NSFocusRingTypeExterior;
    mComboBox.delegate = self;
    mComboBox.bordered = YES;
    
    [mWindow.contentView addSubview:mComboBox];
    [mWindow makeFirstResponder:mComboBox];
    
    // button
    NSRect buttonRect = NSMakeRect(UI_MAIN_WIDTH - 10, 0, 10, UI_MAIN_HEIGHT);
    NSButton *searchButton = [[NSButton alloc] initWithFrame:buttonRect];
    [searchButton setBordered:NO];
    [searchButton setTitle:@""];
    [searchButton setAction:@selector(searchButtonClick:)];
    
    [mWindow.contentView addSubview:searchButton];
    [mWindow makeKeyAndOrderFront:mWindow];
}

- (void)searchButtonClick:(id)sender
{
    [self showResult:mComboBox.stringValue];
}

- (void)showResult:(NSString *)word
{
    word = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (word == nil || word.length == 0) {
        return;
    }
    
    BOOL contains = NO;
    NSInteger itemCount = [mComboBox numberOfItems];
    for (NSInteger i = 0; i < itemCount; ++i) {
        if ([[mComboBox itemObjectValueAtIndex:i] compare:word options:NSCaseInsensitiveSearch] == kCFCompareEqualTo) {
            contains = YES;
            break;
        }
    }
    if (!contains) {
        [mComboBox addItemWithObjectValue:word];
    }
    
    [self selectText];
    
    if (mResultWindow == nil) {
        [self initResultWindow];
    }
    
    [mResultWindow showResult:word];
    [mWindow makeKeyAndOrderFront:mWindow];
}

- (void)initResultWindow
{
    mResultWindow = [[MDResultWindow alloc] initWithFrame:[self getResultWindowRect]];
}

- (void)notifyApplicationDidHide { 
    if (mResultWindow.isVisible) {
        [mResultWindow setIsVisible:NO];
    };
}

- (void)windowDidMove:(NSNotification *)notification
{
    [mResultWindow moveTo:[self getResultWindowRect]];
}

- (NSRect)getResultWindowRect
{
    return NSMakeRect(mWindow.frame.origin.x, mWindow.frame.origin.y - UI_RESULT_HEIGHT, mWindow.frame.size.width, UI_RESULT_HEIGHT);
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    [mWindow makeFirstResponder:mComboBox];
    [self selectText];
    if (mResultWindow.isVisible) {
        [mResultWindow orderFront];
    }
}

- (void)selectText
{
    if (mComboBox.stringValue.length > 0) {
        [mComboBox selectText:mComboBox];
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    [self showResult:[mComboBox itemObjectValueAtIndex:[mComboBox indexOfSelectedItem]]];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    id object = [obj object];
    [object setCompletes:YES];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(insertNewline:)) {
        [self showResult:mComboBox.stringValue];
        return YES;
    }
    else if (commandSelector == @selector(cancelOperation:) && mResultWindow.isVisible) {
        [mResultWindow setIsVisible:NO];
    }
    else if (commandSelector == @selector(paste:)) {
        [self showResult:mComboBox.stringValue];
    }
    
    return NO;
}

@end
