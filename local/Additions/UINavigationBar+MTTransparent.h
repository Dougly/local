//
//  UINavigationBar+MTTransparent.h
//  Hiiper
//
//  Created by Steven on 01/06/16.
//  Copyright © 2016 Hiiper llc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (MTTransparent)
- (void)mt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)mt_setElementsAlpha:(CGFloat)alpha;
- (void)mt_setTranslationY:(CGFloat)translationY;
- (void)mt_reset;
@end
