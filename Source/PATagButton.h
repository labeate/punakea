/* PATagButton */

#import <Cocoa/Cocoa.h>
#import "PATag.h"
#import "PATagButtonCell.h"

@interface PATagButton : NSButton

- (id)initWithFrame:(NSRect)frame Tag:(PATag*)tag attributes:(NSDictionary*)attributes;

- (PATag*)fileTag;
- (void)setFileTag:(PATag*)aTag;

- (BOOL)isHovered;
- (void)setHovered:(BOOL)flag;

- (void)setTitleAttributes:(NSDictionary*)attributes;

@end
