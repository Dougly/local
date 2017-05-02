
#ifndef iOSUILib_MDDatePickerDialog_h
#define iOSUILib_MDDatePickerDialog_h

#import <UIKit/UIKit.h>

@protocol MDDatePickerDialogDelegate <NSObject>

- (void)datePickerDialogDidSelectDate:(nonnull NSDate *)date;

@end

@class MDButton;

@interface MDDatePickerDialog : UIControl

@property (nullable, strong, nonatomic) NSDate *selectedDate;
@property (nonnull, strong, nonatomic ) NSDate *minimumDate;
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (assign, nonatomic) BOOL isAnimation;

@property (weak, nullable ,nonatomic) id <MDDatePickerDialogDelegate> delegate;

- (void)show;
- (void)setTitleOk:(nonnull NSString *)okTitle andTitleCancel:(nonnull NSString *)cancelTitle;
@end
#endif
