//
//  UINavigationBar+MTTransparent.m
//  Hiiper
//
//  Created by Steven on 01/06/16.
//  Copyright © 2016 Hiiper llc. All rights reserved.
//

#import "UINavigationBar+MTTransparent.h"
#import <objc/runtime.h>

@implementation UINavigationBar (MTTransparent)
static char overlayKey;

- (UIView *)overlay {
  return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay {
  objc_setAssociatedObject(self, &overlayKey, overlay,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mt_setBackgroundColor:(UIColor *)backgroundColor {
  if (!self.overlay) {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.overlay = [[UIView alloc]
        initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds) + 20)];
    self.overlay.userInteractionEnabled = NO;
    self.overlay.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.overlay atIndex:0];
  }
  self.overlay.backgroundColor = backgroundColor;
}

- (void)mt_setTranslationY:(CGFloat)translationY {
  self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)mt_setElementsAlpha:(CGFloat)alpha {
  [[self valueForKey:@"_leftViews"]
      enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
      }];

  [[self valueForKey:@"_rightViews"]
      enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
      }];

  UIView *titleView = [self valueForKey:@"_titleView"];
  titleView.alpha = alpha;
  //    when viewController first load, the titleView maybe nil
  [[self subviews]
      enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
          obj.alpha = alpha;
          *stop = YES;
        }
      }];
}

- (void)mt_reset {
  [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  [self.overlay removeFromSuperview];
  self.overlay = nil;
}

@end