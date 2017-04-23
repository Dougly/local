//
//  PZSettingsPreferences.m
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "PZSettingsPreferences.h"

@interface PZSettingsPreferences()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation PZSettingsPreferences
NSString *const POSTING_TYPE_KEY = @"POSTING_TYPE_KEY";
NSString *const DISIPLINE_KEY = @"DISIPLINE_KEY";
NSString *const SOFTWARE_KEY = @"SOFTWARE_KEY";
NSString *const LANGUAGE_PAIR_KEY = @"LANGUAGE_PAIR_KEY";
NSString *const I_CAN_QOUTE_KEY = @"I_CAN_QUOTE_KEY";
NSString *const SHOW_POSTS_IN_MY_LANG_PAIRS_KEY = @"SHOW_POSTS_IN_MY_LANG_PAIRS_KEY";

- (id)init {
    self = [super init];
    _defaults = [NSUserDefaults standardUserDefaults];
    [self setupInitialValues];
    return self;
}

- (void)setupInitialValues {
    if(![_defaults valueForKey:POSTING_TYPE_KEY]) {
        [self addJobPostingType:POSTING_TYPE_TRANSLATION];
        [self addJobPostingType:POSTING_TYPE_INTERPRET];
        [self addJobPostingType:POSTING_TYPE_POTENTIAL];
    }
}

#pragma mark - language pair

- (NSArray *)getLanguagePairs {
    return [self getArrayOfEntries:LANGUAGE_PAIR_KEY];
}

- (void)removeLanguagePair:(NSString *)languagePair {
    [self removeEntry:languagePair atKey:LANGUAGE_PAIR_KEY];
}

- (void)addLanguagePair:(NSString *)languagePair {
    [self addEntry:languagePair forKey:LANGUAGE_PAIR_KEY];
}

#pragma mark - job posting type

- (NSArray *)getJobPostingTypes {
    return [self getArrayOfEntries:POSTING_TYPE_KEY];
}

- (void)removeJobPostingType:(NSString *)jobPostingType {
    [self removeEntry:jobPostingType atKey:POSTING_TYPE_KEY];
}

- (void)addJobPostingType:(NSString *)jobPostingType {
    [self addEntry:jobPostingType forKey:POSTING_TYPE_KEY];
}

#pragma mark - Disciplines

- (NSArray *)getDisciplines {
    return [self getArrayOfEntries:DISIPLINE_KEY];
}

- (void)removeDiscipline:(NSString *)discipline {
    [self removeEntry:discipline atKey:DISIPLINE_KEY];
}

- (void)addDiscipline:(NSString *)discipline {
    [self addEntry:discipline forKey:DISIPLINE_KEY];
}

#pragma mark - Softwares

- (NSArray *)getSoftwares {
    return [self getArrayOfEntries:SOFTWARE_KEY];
}

- (void)removeSoftware:(NSString *)software {
    [self removeEntry:software atKey:SOFTWARE_KEY];
}

- (void)addSoftware:(NSString *)sotftware {
    [self addEntry:sotftware forKey:SOFTWARE_KEY];
}

#pragma mark - Show job postings in native language pairs

- (void)setShowPostsInNativeLanguagePairs:(BOOL)showPostsInNativeLanguage {
    [self.defaults setValue:@(showPostsInNativeLanguage) forKey:SHOW_POSTS_IN_MY_LANG_PAIRS_KEY];
}

- (BOOL)getShowPostsInNativeLanguagePairs {
    return [[self.defaults valueForKey:SHOW_POSTS_IN_MY_LANG_PAIRS_KEY] boolValue];
}

#pragma mark - I can quote

- (void)setICanQuote:(BOOL)iCanQuote {
    [self.defaults setValue:@(iCanQuote) forKey:I_CAN_QOUTE_KEY];
}

- (BOOL)getICanQuote {
    return [[self.defaults valueForKey:I_CAN_QOUTE_KEY] boolValue];
}


#pragma mark - string processing

- (NSArray *)getArrayOfEntries:(NSString *)key {
    NSString *entities = [self.defaults valueForKey:key];
    if(entities && entities.length > 0) {
        return [entities componentsSeparatedByString:DELIMITER];
    }
    else {
        return [[NSArray alloc] init];
    }
}

- (void)removeEntry:(NSString *)entry atKey:(NSString *)key {
    NSString *entires = [self.defaults valueForKey:key];
    if(entires) {
        if([entires rangeOfString:DELIMITER].location != NSNotFound) {
            /*Its the first element in the string, so remove it and the delimiter following this element*/
            if([entires rangeOfString:entry].location == 0) {
                entires = [entires stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@", entry, DELIMITER] withString:@""];
            }
            else {
                /*Its not the first element. So remove the delimiter in front of it and the element*/
                entires = [entires stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@", DELIMITER, entry] withString:@""];
            }
        }
        else {
            entires = [entires stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", entry] withString:@""];
        }
        [self.defaults setValue:entires forKey:key];
        [self.defaults synchronize];
    }
}

- (void)addEntry:(NSString *)entry forKey:(NSString *)key {
    NSString *entries = [self.defaults valueForKey:key];
    if(!entries) {
        entries = @"";
    }
    
    Boolean elementAlreadyExits = false;
    
    if([entries rangeOfString:entry].location != NSNotFound) {
        /*We got match. It means either the element exists or its just a part of anotehr element*/
        NSArray *elements = [entries componentsSeparatedByString:DELIMITER];
        if([elements containsObject:entry]) {
            elementAlreadyExits = YES;
        }
    }
    
    if(!elementAlreadyExits) {
        if(entries.length > 0) {
            entries = [entries stringByAppendingString:[NSString stringWithFormat:@"%@%@", DELIMITER, entry]];
        }
        else {
            entries = entry;
        }
        
        [self.defaults setValue:entries forKey:key];
        [self.defaults synchronize];
    }
}

@end
