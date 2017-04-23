//
//  MTSettignsViewController.m
//  ProZ.com
//
//  Created by Ross on 10/15/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "PZSettignsViewController.h"
#import "RMActionController.h"
#import "RMPickerViewController.h"
#import "MTDataModel.h"
#import "PZSoftwareManager.h"
#import "TLTagsControl.h"
#import "PZSwitchCell.h"
#import "PZSettings.h"

@interface PZSettignsViewController ()<PZSettingsAddTagProtocol, PZSettingsDeleteTagProtocol,PZSwitchCellProtocol>
@property (nonatomic, weak) IBOutlet UISwitch *myLangPairsSwitch;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PZSoftwareManager *softwareManager;
@end

@implementation PZSettignsViewController
NSString *const TAG_CELL_REUSE_IDENTIFIER = @"PZTagCellReuseIdentifier";
NSString *const SWITCH_CELL_REUSE_IDENTIFIER = @"PZSwitchCellReuseIdentifier";

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"ProZ.com";
    self.navigationController.navigationBar.topItem.title = @"Jobs";
    
    self.softwareManager = [[PZSoftwareManager alloc] init];
    [self.myLangPairsSwitch setOn:true];
    
    [self registerCells];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"PZTagCell"
                                               bundle:nil]
         forCellReuseIdentifier:TAG_CELL_REUSE_IDENTIFIER];
    [self.tableView registerNib:[UINib nibWithNibName:@"PZSwitchCell"
                                               bundle:nil]
         forCellReuseIdentifier:SWITCH_CELL_REUSE_IDENTIFIER];
}

#pragma mark - Picker

- (NSString *)titleForSection {
    NSString *itemName = @"";
    switch (self.cellBeingEdited)
    {
        case PZSoftwareType: {
            itemName = @"sofwtares";
            break;
        }
        case PZType: {
            itemName = @"job types";
            break;
        }
        default: {
            itemName = @"items";
            break;
        }
    }
    return itemName;

}
- (void)presentPicker:(NSString *)titleText {
    if([self numberOfItemsForPicker] == 0) {
        NSString *itemName = [self titleForSection];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"All %@ are added", itemName]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    BOOL isBlack = false;
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    if(isBlack) {
        style = RMActionControllerStyleBlack;
    }
    
    RMAction<RMActionController<UIPickerView *> *> *selectAction = [RMAction<RMActionController<UIPickerView *> *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[controller.contentView numberOfComponents] ; i++) {
            [selectedRows addObject:@([controller.contentView selectedRowInComponent:i])];
        }
        
        [self handlePickerSelection:selectedRows];
    }];
    
    RMAction<RMActionController<UIPickerView *> *> *cancelAction = [RMAction<RMActionController<UIPickerView *> *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:style];
    pickerController.title = titleText;
    pickerController.message = @"";
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    
    //You can enable or disable blur, bouncing and motion effects
    pickerController.disableBouncingEffects = false;
    pickerController.disableMotionEffects = false;
    pickerController.disableBlurEffects = false;
    
    //On the iPad we want to show the picker view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if([pickerController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        pickerController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        pickerController.popoverPresentationController.sourceView = self.view;
        pickerController.popoverPresentationController.sourceRect = CGRectMake(0, 100, self.view.bounds.size.width, 40);
    }
    
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];

}

#pragma mark - RMPickerViewController Delegates

- (void)handlePickerSelection:(NSArray *)selectedRows {
    if(self.cellBeingEdited == PZSoftwareType) {
        NSUInteger softwareRow = [[selectedRows objectAtIndex:0] integerValue];
        NSMutableArray *softwares = [self.softwareManager allSoftwares];
        
        /*Remove already added softwares*/
        NSArray *storedSoftwares = [[PZSettings sharedSettings] getSoftwares];
        [softwares removeObjectsInArray:storedSoftwares];
        
        NSString *software = [NSString stringWithFormat:@"%@", [softwares objectAtIndex:softwareRow]];
        [[PZSettings sharedSettings] addSoftware:software];
        
        NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForItem:0 inSection:self.cellBeingEdited];
        PZTagCell *cell = (PZTagCell *)[self.tableView cellForRowAtIndexPath:indexPathToUpdate];
        [cell.tagsControl addTag:software];
    }
    if(self.cellBeingEdited == PZType) {
        NSUInteger typeRow = [[selectedRows objectAtIndex:0] integerValue];
        NSMutableArray *jobPostingTypes = [[NSMutableArray alloc] initWithArray:POSTING_TYPES];
        
        /*Remove already added types*/
        NSArray *storedTypes = [[PZSettings sharedSettings] getJobPostingTypes];
        [jobPostingTypes removeObjectsInArray:storedTypes];
        
        NSString *postingType = [NSString stringWithFormat:@"%@", [jobPostingTypes objectAtIndex:typeRow]];
        [[PZSettings sharedSettings] addJobPostingType:postingType];
        
        NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForItem:0 inSection:self.cellBeingEdited];
        PZTagCell *cell = (PZTagCell *)[self.tableView cellForRowAtIndexPath:indexPathToUpdate];
        [cell.tagsControl addTag:postingType];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSUInteger)numberOfItemsForPicker {
    NSUInteger count = 0;
    switch (self.cellBeingEdited)
    {
        case PZSoftwareType: {
            NSMutableArray *softwares = [self.softwareManager allSoftwares];
            NSArray *storedSoftwares = [[PZSettings sharedSettings] getSoftwares];
            [softwares removeObjectsInArray:storedSoftwares];
            count = softwares.count;
            break;
        }
        case PZType: {
            NSMutableArray *types = [[NSMutableArray alloc] initWithArray:POSTING_TYPES];
            NSArray *storedTypes = [[PZSettings sharedSettings] getJobPostingTypes];
            [types removeObjectsInArray:storedTypes];
            count = types.count;
            break;
        }
        default: {
            count = 5;
            break;
        }
    }
    return count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self numberOfItemsForPicker];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.cellBeingEdited == PZSoftwareType) {
        NSMutableArray *softwares = [self.softwareManager allSoftwares];
        /*Remove already stored softwares*/
        [softwares removeObjectsInArray:[[PZSettings sharedSettings] getSoftwares]];
        return [NSString stringWithFormat:@"%@", [softwares objectAtIndex:row]];
    }
    if(self.cellBeingEdited == PZType) {
        NSMutableArray *jobPostingTypes = [[NSMutableArray alloc] initWithArray:POSTING_TYPES];
        /*Remove already stored softwares*/
        [jobPostingTypes removeObjectsInArray:[[PZSettings sharedSettings] getJobPostingTypes]];
        
        return [NSString stringWithFormat:@"%@", [jobPostingTypes objectAtIndex:row]];
    }
   
    return @"";
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PZSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(section <= PZType)
       return 1;
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case PZSoftwareType:
            sectionName = @"Software";
            break;
        case PZType:
            sectionName = @"Job type";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *finalCell = nil;
    /*Setup the UI fo the cell*/
    if(indexPath.section <= PZType) {
        PZTagCell *cell = [tableView dequeueReusableCellWithIdentifier:TAG_CELL_REUSE_IDENTIFIER
                                                          forIndexPath:indexPath];
        /*The cell shoud keep its section type*/
        cell.sectionType = indexPath.section;
        
        /*Set the delegate*/
        cell.delegate = self;
       [self setupCell:cell forSectionType:cell.sectionType];
        finalCell = cell;
    }
    else {
        PZSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SWITCH_CELL_REUSE_IDENTIFIER
                                                          forIndexPath:indexPath];
        
        /*Set the delegate*/
        cell.delegate = self;
        cell.cellType = indexPath.row;
        [self setupSwitchCell:cell forCellType:indexPath.row];
        finalCell = cell;
    }
    
    return finalCell;
}

- (void)setupCell:(PZTagCell *)cell forSectionType:(PZSettingsSectionType)sectionType{
    NSMutableArray *tags = nil;
    
    switch (sectionType) {
        case PZSoftwareType: {
            tags = [[PZSettings sharedSettings] getSoftwares];
            break;
        }
        case PZType: {
            tags = [[PZSettings sharedSettings] getJobPostingTypes];
            break;
        }
            
        default:
            break;
    }
    
    /*Set the delegate for the cell*/
    cell.tagsControl.tags = tags;
    cell.tagsControl.tagsBackgroundColor = kTotsAmourBrandColorHEX;
    UIColor *whiteTextColor = [UIColor whiteColor];
    cell.tagsControl.tagsDeleteButtonColor = whiteTextColor;
    cell.tagsControl.tagsTextColor = whiteTextColor;
    [cell.tagsControl reloadTagSubviews];
}

- (void)setupSwitchCell:(PZSwitchCell *)cell forCellType:(PZSwitchCellType)type {
    if(type == PZSwitchCellShowPostsInNativeLanguagePairs) {
        cell.captionLabel.text = @"Only posts in my language pairs";
    }
    if(type == PZSwitchCellICanQuote) {
        cell.captionLabel.text = @"Only posts I can quote on";
    }
}

#pragma mark - PZSettingsAddTagProtocol

- (void)addButtonClicked:(PZSettingsSectionType)sectionType {
    self.cellBeingEdited = sectionType;
    NSString *title = @"";
    
    switch (sectionType) {
        case PZSoftwareType: {
            title = @"Select the software to add";
            break;
        }
        case PZType: {
            title = @"Select the job posting type to add";
            break;
        }
            
        default:
            break;
    }
    
    /*Show the picker*/
    [self presentPicker:title];
}

#pragma mark - PZSettingsDeleteTagProtocol

- (void)deleteButtonClicked:(NSString *)tag sectiontype:(PZSettingsSectionType)sectionType {
    if(sectionType == PZSoftwareType) {
        [[PZSettings sharedSettings] removeSoftware:tag];
    }
    if(sectionType == PZType) {
        [[PZSettings sharedSettings] removeJobPostingType:tag];
    }
}

#pragma mark - PZSwitchCellProtocol

- (void)switchStateChanged:(Boolean)state forCellType:(PZSwitchCellType)cellType {
    if(cellType == PZSwitchCellShowPostsInNativeLanguagePairs) {
       
    }
    if(cellType == PZSwitchCellICanQuote) {
    }
}

                                                                               
@end
