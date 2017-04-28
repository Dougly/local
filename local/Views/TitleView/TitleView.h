//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleViewDelegate <NSObject>
- (void)titleViewClicked:(BOOL)isRevealing;
@end

@interface TitleView : UIView
@property (nonatomic, weak) id<TitleViewDelegate> delegate;
- (void)reveal;
- (void)collapse;
@end
