//
//  MDComboBoxCell.m
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/26.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "MDComboBoxCell.h"

@interface MDTextView : NSTextView

- (id)initWithControl:(NSView *)control;

@end

@implementation MDComboBoxCell {
    MDTextView *mdTextview;
}

- (NSTextView *)fieldEditorForView:(NSView *)controlView
{
    if (!mdTextview) {
        mdTextview = [[MDTextView alloc] initWithControl:controlView];
    }
    
    return mdTextview;
}

@end

@implementation MDTextView {
    NSComboBox *comboBox;
}

- (id)initWithControl:(NSView *)control {
    if (self = [super init]) {
        if ([control isKindOfClass:[NSComboBox class]]) {
            comboBox = (NSComboBox *)control;
        };
    }
    
    return self;
}

- (void)paste:(id)sender
{
    [super paste:sender];
    
    [comboBox.delegate control:comboBox textView:self doCommandBySelector:@selector(paste:)];
}

@end
