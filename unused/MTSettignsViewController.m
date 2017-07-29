//
//  MTSettignsViewController.m
//  ProZ.com
//
//  Created by Ross on 10/15/15.
//  Copyright © 2015 Tilf AB. All rights reserved.
//

#import "MTSettignsViewController.h"
#import "RMActionController.h"
#import "RMPickerViewController.h"
#import "MTDataModel.h"
#import "MTPlaceTypeManager.h"
#import "TLTagsControl.h"
#import "MTSwitchCell.h"
#import "MTSettings.h"
#import "MTRatingCell.h"
#import "MTDistanceCell.h"

@interface MTSettignsViewController ()<MTSettingsAddTagProtocol, MTSettingsDeleteTagProtocol, MTSwitchCellProtocol, MTRatingCellProtocol, MTDistanceValueProtocol>
@property (nonatomic, weak) IBOutlet UISwitch *myLangPairsSwitch;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MTPlaceTypeManager *placeTypeManager;
@end

@implementation MTSettignsViewController
NSString *const TAG_CELL_REUSE_IDENTIFIER = @"MTTagCellReuseIdentifier";
NSString *const SWITCH_CELL_REUSE_IDENTIFIER = @"MTSwitchCellReuseIdentifier";
NSString *const RATING_CELL_REUSE_IDENTIFIER = @"MTRatingCellReuseIdentifier";
NSString *const DISTANCE_CELL_REUSE_IDENTIFIER = @"MTDistanceCellReuseIdentifier";

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"Settings";
    self.navigationController.navigationBar.topItem.title = @"Settings";
    
    self.placeTypeManager = [[MTPlaceTypeManager alloc] init];
    [self.myLangPairsSwitch setOn:true];
    
    [self registerCells];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTTagCell"
                                               bundle:nil]
         forCellReuseIdentifier:TAG_CELL_REUSE_IDENTIFIER];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTSwitchCell"
                                               bundle:nil]
         forCellReuseIdentifier:SWITCH_CELL_REUSE_IDENTIFIER];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTRatingCell"
                                               bundle:nil]
         forCellReuseIdentifier:RATING_CELL_REUSE_IDENTIFIER];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTDistanceCell"
                                               bundle:nil]
         forCellReuseIdentifier:DISTANCE_CELL_REUSE_IDENTIFIER];
}

#pragma mark - Picker

- (NSString *)titleForSection {
    NSString *itemName = @"";
    switch (self.cellBeingEdited)
    {
        case MTPlaceTypeSection: {
            itemName = @"Place types";
            break;
        }
        case MTFoodTypeSection: {
            itemName = @"Meals";
            break;
        }
        case MTDistanceSection: {
            itemName = @"Radius";
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
                                                        message:[NSString stringWithFormat:@"All possible %@ are added", [itemName lowercaseString]]
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
    if(self.cellBeingEdited == MTPlaceTypeSection) {
        NSUInteger softwareRow = [[selectedRows objectAtIndex:0] integerValue];
        NSMutableArray *placeTypes = [self.placeTypeManager allPlaceTypes];
        
        /*Remove already added softwares*/
        NSArray *storedPlaceTypes = [[MTSettings sharedSettings] getPlaceTypes];
        [placeTypes removeObjectsInArray:storedPlaceTypes];
        
        NSString *placeType = [NSString stringWithFormat:@"%@", [placeTypes objectAtIndex:softwareRow]];
        [[MTSettings sharedSettings] addPlaceType:placeType];
        
        NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForItem:0 inSection:self.cellBeingEdited];
        MTTagCell *cell = (MTTagCell *)[self.tableView cellForRowAtIndexPath:indexPathToUpdate];
        [cell.tagsControl addTag:placeType];
    }
    if(self.cellBeingEdited == MTFoodTypeSection) {
        NSUInteger typeRow = [[selectedRows objectAtIndex:0] integerValue];
        NSMutableArray *foodTypes = [[NSMutableArray alloc] initWithArray:FOOD_TYPES];
        
        /*Remove already added foods*/
        NSArray *storedFoods = [[MTSettings sharedSettings] getFoodTypes];
        [foodTypes removeObjectsInArray:storedFoods];
        
        NSString *foodType = [NSString stringWithFormat:@"%@", [foodTypes objectAtIndex:typeRow]];
        [[MTSettings sharedSettings] addFoodType:foodType];
        
        NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForItem:0 inSection:self.cellBeingEdited];
        MTTagCell *cell = (MTTagCell *)[self.tableView cellForRowAtIndexPath:indexPathToUpdate];
        [cell.tagsControl addTag:foodType];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSUInteger)numberOfItemsForPicker {
    NSUInteger count = 0;
    switch (self.cellBeingEdited)
    {
        case MTPlaceTypeSection: {
            NSMutableArray *placeTypes = [self.placeTypeManager allPlaceTypes];
            NSArray *storedplaceTypes = [[MTSettings sharedSettings] getPlaceTypes];
            [placeTypes removeObjectsInArray:storedplaceTypes];
            count = placeTypes.count;
            break;
        }
        case MTFoodTypeSection: {
            NSMutableArray *types = [[NSMutableArray alloc] initWithArray:FOOD_TYPES];
            NSArray *storedFoodsTypes = [[MTSettings sharedSettings] getFoodTypes];
            [types removeObjectsInArray:storedFoodsTypes];
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
    if(self.cellBeingEdited == MTPlaceTypeSection) {
        NSMutableArray *placeTypes = [self.placeTypeManager allPlaceTypes];
        /*Remove already stored softwares*/
        [placeTypes removeObjectsInArray:[[MTSettings sharedSettings] getPlaceTypes]];
        return [NSString stringWithFormat:@"%@", [placeTypes objectAtIndex:row]];
    }
    if(self.cellBeingEdited == MTFoodTypeSection) {
        NSMutableArray *foodTypes = [[NSMutableArray alloc] initWithArray:FOOD_TYPES];
        /*Remove already stored softwares*/
        [foodTypes removeObjectsInArray:[[MTSettings sharedSettings] getFoodTypes]];
        
        return [NSString stringWithFormat:@"%@", [foodTypes objectAtIndex:row]];
    }
   
    return @"";
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MTSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if(section == MTSwitchesSection)
       return 2;
    
    return 1;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == MTDistanceSection) {
        return 72;
    }
    
    return 46;
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case MTPlaceTypeSection:
            sectionName = @"Place types";
            break;
        case MTFoodTypeSection:
            sectionName = @"Food";
            break;
        case MTRatingSection:
            sectionName = @"Minimum rating";
            break;
        case MTDistanceSection:
            sectionName = @"Radius";
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
    if(indexPath.section <= MTFoodTypeSection) {
        MTTagCell *cell = [tableView dequeueReusableCellWithIdentifier:TAG_CELL_REUSE_IDENTIFIER
                                                          forIndexPath:indexPath];
        /*The cell shoud keep its section type*/
        cell.sectionType = indexPath.section;
        
        /*Set the delegate*/
        cell.delegate = self;
        [self setupCell:cell forSectionType:cell.sectionType];
        finalCell = cell;
    }
    else if (indexPath.section == MTSwitchesSection ){
        MTSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SWITCH_CELL_REUSE_IDENTIFIER
                                                          forIndexPath:indexPath];
        
        /*Set the delegate*/
        cell.delegate = self;
        cell.cellType = indexPath.row;
        [self setupSwitchCell:cell forCellType:indexPath.row];
        finalCell = cell;
    }
    else if (indexPath.section == MTRatingSection) {
        MTRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:RATING_CELL_REUSE_IDENTIFIER
                                                             forIndexPath:indexPath];
        
        /*Set the delegate*/
        cell.delegate = self;
        finalCell = cell;
    }
    
    else if (indexPath.section == MTDistanceSection) {
        MTDistanceCell *cell = [tableView dequeueReusableCellWithIdentifier:DISTANCE_CELL_REUSE_IDENTIFIER
                                                             forIndexPath:indexPath];
        
        /*Set the delegate*/
        cell.delegate = self;
        finalCell = cell;
    }
    
    return finalCell;
}

- (void)setupCell:(MTTagCell *)cell forSectionType:(MTSettingsSectionType)sectionType{
    NSMutableArray *tags = nil;
    
    switch (sectionType) {
        case MTPlaceTypeSection: {
            tags = [[MTSettings sharedSettings] getPlaceTypes];
            break;
        }
        case MTFoodTypeSection: {
            tags = [[MTSettings sharedSettings] getFoodTypes];
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

- (void)setupSwitchCell:(MTSwitchCell *)cell forCellType:(MTSwitchCellType)type {
    if(type == MTSwitchCellOnlyOpenNow) {
        cell.captionLabel.text = @"Only open now";
        [cell.cellSwitch setOn: [[MTSettings sharedSettings] getOnlyOpen]];

    }
    if(type == MTSwitchCellOnlyCheap) {
        cell.captionLabel.text = @"Only cheap";
        [cell.cellSwitch setOn: [[MTSettings sharedSettings] getOnlyCheap]];
    }
}

#pragma mark - MTSettingsAddTagProtocol

- (void)addButtonClicked:(MTSettingsSectionType)sectionType {
    self.cellBeingEdited = sectionType;
    NSString *title = @"";
    
    switch (sectionType) {
        case MTPlaceTypeSection: {
            title = @"Select the place type to add";
            break;
        }
        case MTFoodTypeSection: {
            title = @"Select meal to add";
            break;
        }
            
        default:
            break;
    }
    
    /*Show the picker*/
    [self presentPicker:title];
}

#pragma mark - MTSettingsDeleteTagProtocol

- (void)deleteButtonClicked:(NSString *)tag sectiontype:(MTSettingsSectionType)sectionType {
    if(sectionType == MTPlaceTypeSection) {
        [[MTSettings sharedSettings] removePlaceType:tag];
    }
    if(sectionType == MTFoodTypeSection) {
        [[MTSettings sharedSettings] removeFoodType:tag];
    }
}

#pragma mark - MTSwitchCellProtocol

- (void)switchStateChanged:(Boolean)state forCellType:(MTSwitchCellType)cellType {
    if(cellType == MTSwitchCellOnlyOpenNow) {
       [[MTSettings sharedSettings] setOnlyOpen:state];
    }
    
    if(cellType == MTSwitchCellOnlyCheap) {
        [[MTSettings sharedSettings] setOnlyCheap:state];
    }
}

#pragma mark - rating protocol
- (void)ratingChanged:(float)rating {
    [[MTSettings sharedSettings] setRating:rating];
}

#pragma mark - Slider Touch delegate
- (void)distanceChanged:(float)distance {
    [[MTSettings sharedSettings] setDistance:distance];
}
                                                                               
@end
