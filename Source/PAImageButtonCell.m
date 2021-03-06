// Copyright (c) 2006-2012 nudge:nudge (Johannes Hoffart & Daniel Bär). All rights reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PAImageButtonCell.h"


@interface PAImageButtonCell (PrivateAPI)

- (PAButtonState)state;
- (void)setState:(PAButtonState)aState;
- (NSString*)stringForState:(PAButtonState)aState;

@end


@implementation PAImageButtonCell

#pragma mark Init + Dealloc
- (id)initImageCell:(NSImage *)anImage
{	
	self = [super initImageCell:anImage];
	if(self)
	{
		images = [[NSMutableDictionary alloc] init];
		if (anImage) [self setImage:anImage forState:PAOffState];
		state = PAOffState;
		type = PAMomentaryLightButton;	
		tag = [[NSMutableDictionary alloc] init];
		[self setAction:@selector(action:)];
		
		// For mouse move events
		[self setBordered:NO];
		//[self setShowsBorderOnlyWhileMouseInside:YES];
	}	
	return self;
}

- (id)initTextCell:(NSString *)aText
{	
	self = [super initTextCell:aText];
	if(self)
	{
		images = [[NSMutableDictionary alloc] init];
		state = PAOffState;
		type = PAMomentaryLightButton;	
		tag = [[NSMutableDictionary alloc] init];
		[self setAction:@selector(action:)];
		
		// For mouse move events
		[self setBordered:NO];
		//[self setShowsBorderOnlyWhileMouseInside:YES];
	}
	return self;
}

- (void)dealloc
{
	if(images) [images release];
	if(tag) [tag release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	// TODO
	return [super copyWithZone:zone];
}


#pragma mark Data Source
- (void)setImage:(NSImage *)anImage forState:(PAButtonState)aState
{
	[images setObject:anImage forKey:[self stringForState:aState]];
}

- (void)setButtonType:(PAButtonType)aType
{
	type = aType;
}

#pragma mark Drawing
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	PAButtonState thisState = [self state];
	if(![[controlView window] isKeyWindow])
	{
		if([self state] == PAOnState) 
			if([images objectForKey:[self stringForState:PAOnDisabledState]])
				thisState = PAOnDisabledState;
		if([self state] == PAOffState) 
			if([images objectForKey:[self stringForState:PAOffDisabledState]])
				thisState = PAOffDisabledState;
	}

	NSImage *image = [images objectForKey:[self stringForState:thisState]];
	
	NSRect imageRect;
	imageRect.origin = NSZeroPoint;
	imageRect.size = [image size];
	
	if([image scalesWhenResized])
		[image drawInRect:cellFrame fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
	else
		[image drawAtPoint:cellFrame.origin
				  fromRect:imageRect
				 operation:NSCompositeSourceOver
				  fraction:1.0];
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}


#pragma mark Mouse Tracking
/**
	Ensure to activate sending mouse moved events by setting
	setShowsBorderOnlyWhileMouseInside:YES for self
*/
- (void)mouseEntered:(NSEvent *)event
{
	previousState = state;
	if([self state] == PAOnState ||
	   [self state] == PAOnHighlightedState)
	{
		if([images objectForKey:[self stringForState:PAOnHoveredState]])
			[self setState:PAOnHoveredState];
	}
	if([self state] == PAOffState ||
	   [self state] == PAOffHighlightedState)
	{
		if([images objectForKey:[self stringForState:PAOffHoveredState]])
			[self setState:PAOffHoveredState];
	}
}

- (void)mouseExited:(NSEvent *)event
{
	[self setState:previousState];	
	[[self controlView] setNeedsDisplay:YES];	
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
	return [super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:YES];
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{	
	PAButtonState newHighlightedState;
	PAButtonState newState;
	
	if(type == PAMomentaryLightButton)
	{
		newHighlightedState = PAOffHighlightedState;
		newState = PAOnState;
	}
	else
	{
		if(state == PAOnState)
		{
			newHighlightedState = PAOnHighlightedState;
			newState = PAOffState;
		}
		else
		{
			newHighlightedState = PAOffHighlightedState;
			newState = PAOnState;
		}
	}
	
	if([images objectForKey:[self stringForState:newHighlightedState]])
		[self setState:newHighlightedState];
	else
		[self setState:newState];

	return YES;
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView
{
	return YES;
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag
{
	// Action
	//[[self target] performSelector:[self action] withObject:self];
	
	// all following states need to be the inverse ones? seems so...	
	if(type == PAMomentaryLightButton)
	{
		[self setState:PAOnState];
	}
	else
	{
		PAButtonState newState;
		if(state == PAOffState || state == PAOnHighlightedState) { newState = PAOnState; }
		if(state == PAOnState || state == PAOffHighlightedState) { newState = PAOffState; }
		[self setState:newState];
	}
}

#pragma mark Private Helpers
/**
	NSDictionary needs to get an object for key, so I can't use just the enum value...
*/
- (NSString*)stringForState:(PAButtonState)aState
{
	NSString *name;
	switch(aState)
	{
		case PAOnState:
			name = @"PAOnState"; break;
		case PAOffState:
			name = @"PAOffState"; break;
		case PAOnHighlightedState:
			name = @"PAOnHighlightedState"; break;
		case PAOffHighlightedState:
			name = @"PAOffHighlightedState"; break;
		case PAOnDisabledState:
			name = @"PAOnDisabledState"; break;
		case PAOffDisabledState:
			name = @"PAOffDisabledState"; break;
		case PAOnHoveredState:
			name = @"PAOnHoveredState"; break;
		case PAOffHoveredState:
			name = @"PAOffHoveredState"; break;
	}	
	
	return name;
}

#pragma mark Accessors
- (PAButtonState)state
{
	return state;
}

- (void)setState:(PAButtonState)aState
{
	PAButtonState formerState = [self state];
	state = aState;
	if(formerState != state) [[self controlView] setNeedsDisplay:YES];
}

- (BOOL)isHighlighted
{	
	// Always return NO, so we can handle all drawing ourselves!
	return NO;
}

- (void)setHighlighted:(BOOL)flag
{
	if(!flag)
		[self setState:PAOffState];
	else
		[self setState:PAOnState];
}

- (NSMutableDictionary *)tag
{
	return tag;
}

- (void)setTag:(NSMutableDictionary *)aTag
{
	tag = [aTag retain];
}

@end
