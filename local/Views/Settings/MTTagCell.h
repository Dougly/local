//
//  MTTagCell.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLTagsControl;

@protocol MTSettingsAddTagProtocol <NSObject>
- (void)addButtonClicked:(MTSettingsSectionType)secionType;
@end

@protocol MTSettingsDeleteTagCellProtocol <NSObject>
- (void)deleteButtonClicked:(NSString *)tag;
@end

@protocol MTSettingsDeleteTagProtocol <NSObject>
- (void)deleteButtonClicked:(NSString *)tag sectiontype:(MTSettingsSectionType)sectionType;
@end

@interface MTTagCell : UITableViewCell
@property (nonatomic, weak) IBOutlet TLTagsControl *tagsControl;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic) MTSettingsSectionType sectionType;
@property (nonatomic, weak) id <MTSettingsAddTagProtocol, MTSettingsDeleteTagProtocol> delegate;
- (void)deleteButtonClicked:(NSString *)tag;
@end
