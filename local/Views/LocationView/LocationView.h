//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationViewDelegate <NSObject>
- (void)hideLocationView;
@end

@interface LocationView : UIView
@property (nonatomic, weak) id<LocationViewDelegate, MTLocationViewTextfieldCellDelegate>delegate;
@end
