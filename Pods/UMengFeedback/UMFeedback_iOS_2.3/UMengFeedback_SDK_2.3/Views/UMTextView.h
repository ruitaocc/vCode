//
//  UMTextView.h
//  UMFeedback
//
//  Created by amoblin on 14/10/9.
//
//

#import <UIKit/UIKit.h>

@interface UMTextView : UITextView

/** The placeholder text string. */
@property (nonatomic, readwrite) NSString *placeholder;

/** The placeholder color. */
@property (nonatomic, readwrite) UIColor *placeholderColor;
@end
