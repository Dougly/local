//
//  MTSettignsViewController.h
//  ProZ.com
//
//  Created by Ross on 10/15/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZTagCell.h"

@interface PZSettignsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
extern NSString *const TAG_CELL_REUSE_IDENTIFIER;
extern NSString *const SWITCH_CELL_REUSE_IDENTIFIER;

@property (nonatomic) PZSettingsSectionType cellBeingEdited;
@end
