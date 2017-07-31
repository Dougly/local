//
//  TitleView.h
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LocationViewDelegate;
@protocol LocationViewTextfieldCellDelegate;

@interface LocationView : UIView
@property (nonatomic, weak) id<LocationViewDelegate, LocationViewTextfieldCellDelegate>delegate;
@end
