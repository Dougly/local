//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate <NSObject>
- (void)hideFilterView:(BOOL)shouldRevertToPreviousIndex;
@end

@interface FilterView : UIView
@property (nonatomic, weak) id<FilterViewDelegate>delegate;
@end
