//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTPlace;

@protocol ListViewDelegate <NSObject>
- (void)didSelectItemForPlace:(MTPlace *)place;
@end

@interface ListView : UIView
@property (nonatomic, weak) id<ListViewDelegate>delegate;
@end
