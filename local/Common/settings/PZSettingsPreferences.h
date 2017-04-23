//
//  PZSettingsPreferences.h
//  Proz
//
//  Created by RostyslavStepanyak on 3/17/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZSettingsPreferences : NSObject
extern NSString *const POSTING_TYPE_KEY;
extern NSString *const DISIPLINE_KEY;
extern NSString *const SOFTWARE_KEY;
extern NSString *const LANGUAGE_PAIR_KEY;
extern NSString *const SHOW_POSTS_IN_MY_LANG_PAIRS_KEY;
extern NSString *const I_CAN_QUOTE_KEY;

/*Language pairs*/
- (NSArray *)getLanguagePairs;
- (void)removeLanguagePair:(NSString *)languagePair;
- (void)addLanguagePair:(NSString *)languagePair;


/*Job posting type*/
- (NSArray *)getJobPostingTypes;
- (void)removeJobPostingType:(NSString *)jobPostingType;
- (void)addJobPostingType:(NSString *)jobPostingType;

/*Disciplines*/
- (NSArray *)getDisciplines;
- (void)removeDiscipline:(NSString *)discipline;
- (void)addDiscipline:(NSString *)discipline;

/*Software*/
- (NSArray *)getSoftwares;
- (void)removeSoftware:(NSString *)software;
- (void)addSoftware:(NSString *)sotftware;

/*Show job postings in my native language pairs*/
- (void)setShowPostsInNativeLanguagePairs:(BOOL)showPostsInNativeLanguage;
- (BOOL)getShowPostsInNativeLanguagePairs;

/*I can quote*/
- (void)setICanQuote:(BOOL)iCanQuote;
- (BOOL)getICanQuote;

@end
