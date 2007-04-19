//
//  PASourceItemCell.m
//  punakea
//
//  Created by Daniel on 29.03.07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PASourceItemCell.h"


@implementation PASourceItemCell

#pragma mark Init + Dealloc
- (id)initTextCell:(NSString *)aText
{
	self = [super initTextCell:aText];
	if (self)
	{
		// Nothing
	}	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}


#pragma mark Drawing
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{			
	// Font attributes
	NSMutableDictionary *fontAttributes = [NSMutableDictionary dictionaryWithCapacity:3];
	
	if(!([item isKindOfClass:[PASourceItem class]] &&
		 [item isHeading])) 
	{
		NSColor *textColor = [NSColor blackColor];
		NSFont *font = [NSFont systemFontOfSize:11];
		
		if([self isHighlighted]) 
		{
			// This depends on whether it is used in an OutlineView or a TableView or somewhere else
			if([controlView isKindOfClass:[NSOutlineView class]])
			{
				if(![[(NSOutlineView *)controlView itemAtRow:[controlView editedRow]] isEqualTo:item])
				{
					textColor = [NSColor whiteColor];
					font = [NSFont boldSystemFontOfSize:11];
				}
			}
		}
		
		[fontAttributes setObject:textColor forKey:NSForegroundColorAttributeName];	
		[fontAttributes setObject:font forKey:NSFontAttributeName];
		
		// Draw display name	
		NSAttributedString *label = [[NSAttributedString alloc] initWithString:[item displayName]
																	attributes:fontAttributes];	
		
		[label drawInRect:NSMakeRect(cellFrame.origin.x,
									 cellFrame.origin.y + (cellFrame.size.height - [label size].height) / 2,
									 cellFrame.size.width,
									 cellFrame.size.height)];
	} 
	else
	{
		NSColor *textColor = [NSColor colorWithDeviceRed:(57.0/255.0) green:(67.0/255.0) blue:(81.0/255.0) alpha:1.0];
		NSFont *font = [NSFont systemFontOfSize:11];
		
		[fontAttributes setObject:textColor forKey:NSForegroundColorAttributeName];	
		[fontAttributes setObject:font forKey:NSFontAttributeName];
		
		// Draw display name	
		NSAttributedString *label = [[NSAttributedString alloc] initWithString:[[item displayName] uppercaseString]
																	attributes:fontAttributes];	
		
		[label drawInRect:NSMakeRect(cellFrame.origin.x,
									 cellFrame.origin.y + cellFrame.size.height - [label size].height - 3,
									 cellFrame.size.width,
									 cellFrame.size.height)];
	}
}


#pragma mark Renaming Stuff
- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	NSLog(@"editWithFrame");
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(int)selStart length:(int)selLength
{	
	NSRect frame = aRect;
	/*frame.origin.x += 25;
	frame.origin.y += 1;
	frame.size.width -= 180 + 25; 
	frame.size.height -= 3;*/
	
	[super selectWithFrame:frame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
	
	[textObj setFont:[NSFont systemFontOfSize:11]];
	[textObj setString:[item displayName]];
	
	[textObj selectAll:self];
}


#pragma mark Accessors
- (id)objectValue
{
	return item;
}

- (void)setObjectValue:(id <NSCopying>)object
{
	// weak reference
	item = object;
}

@end