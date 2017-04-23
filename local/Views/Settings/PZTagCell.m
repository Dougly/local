//
//  PZTagCell.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/16/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "PZTagCell.h"
#import "TLTagsControl.h"

@interface PZTagCell()<PZSettingsDeleteTagCellProtocol>

@end

@implementation PZTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagsControl.deleteDelegate = self;
}

- (IBAction)addButtonTapped:(id)sender {
    [self.delegate addButtonClicked:self.sectionType];
}

- (void)deleteButtonClicked:(NSString *)tag {
    [self.delegate deleteButtonClicked:tag sectiontype:self.sectionType];
}

@end
