//
//  PZTagCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLTagsControl;

@protocol PZSettingsAddTagProtocol <NSObject>
- (void)addButtonClicked:(PZSettingsSectionType)secionType;
@end

@protocol PZSettingsDeleteTagCellProtocol <NSObject>
- (void)deleteButtonClicked:(NSString *)tag;
@end

@protocol PZSettingsDeleteTagProtocol <NSObject>
- (void)deleteButtonClicked:(NSString *)tag sectiontype:(PZSettingsSectionType)sectionType;
@end

@interface PZTagCell : UITableViewCell
@property (nonatomic, weak) IBOutlet TLTagsControl *tagsControl;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic) PZSettingsSectionType sectionType;
@property (nonatomic, weak) id <PZSettingsAddTagProtocol, PZSettingsDeleteTagProtocol> delegate;
- (void)deleteButtonClicked:(NSString *)tag;
@end
