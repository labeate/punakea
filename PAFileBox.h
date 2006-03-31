/* PAFileBox */

#import <Cocoa/Cocoa.h>
#import "PATagger.h"
#import "PATag.h"

@interface PAFileBox : NSImageView
{
	NSArray *files;
	NSImage *fileIcon;
	BOOL highlight;
}

- (void)setFiles:(NSArray*)fileArray;
- (NSArray*)files;
- (void)setFileIcon:(NSImage*)newIcon;
- (NSImage*)fileIcon;

@end