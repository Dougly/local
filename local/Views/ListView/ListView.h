//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewDelegate <NSObject>
- (void)hideListView;
@end

@interface ListView : UIView
@property (nonatomic, weak) id<ListViewDelegate>delegate;
@end
