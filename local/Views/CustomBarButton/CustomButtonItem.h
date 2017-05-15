//
//  CustomButtonItem.h
//  Local
//
//  Created by Rostyslav Stepanyak on 5/15/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButtonItem : UIBarButtonItem
- (id)initAsBackButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector;
- (id)initAsShareButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector;
@end
