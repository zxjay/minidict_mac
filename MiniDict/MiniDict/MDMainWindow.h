//
//  MDMainWindow.h
//  MiniDict
//
//  Created by zhouzhenxing on 2018/7/25.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDMainWindow : NSObject <NSComboBoxDelegate, NSWindowDelegate>

- (id)init;
- (void)notifyApplicationDidHide;

@end
