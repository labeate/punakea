//
//  PAFilterSlice.m
//  punakea
//
//  Created by Daniel on 31.07.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PAFilterSlice.h"


@implementation PAFilterSlice

#pragma mark Init + Dealloc
- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if(self)
	{		
		buttons = [[NSMutableArray alloc] init];
			
		[self addFilterButtons];
	}
	return self;
}

- (void)dealloc
{
	if(buttons) [buttons release];
	[super dealloc];
}


#pragma mark Actions
- (void)addFilterButtons
{
	[buttons removeAllObjects];
	int x = 10;
	unsigned buttonIndex = 0;

	/*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *spotlightDict = [defaults persistentDomainForName:@"com.apple.spotlight"];
	
	NSMutableArray *orderedItems = [[spotlightDict objectForKey:@"orderedItems"] mutableCopy];*/
	
	// Define filters
	NSMutableArray *filters = [NSMutableArray array];
	
	NSMutableDictionary *filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"All" forKey:@"title"];
	[filters addObject:filter];
	
	filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"MUSIC" forKey:@"title"];
	[filters addObject:filter];
	
	filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"MOVIES" forKey:@"title"];
	[filters addObject:filter];
	
	filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"PDF" forKey:@"title"];
	[filters addObject:filter];
	
	filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"IMAGES" forKey:@"title"];
	[filters addObject:filter];
	
	filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"CONTACT" forKey:@"title"];
	[filters addObject:filter];
	
	filter = [NSMutableDictionary dictionaryWithCapacity:2];
	[filter setObject:@"BOOKMARKS" forKey:@"title"];
	[filters addObject:filter];	
	
	NSEnumerator *enumerator = [filters objectEnumerator];
	NSDictionary *item;
	while(item = [enumerator nextObject])
	{
		NSRect frame = [self frame];
		frame.origin.x = x;
		frame.origin.y = 3;
		frame.size.height = 19;
		
		// Determine button's title
		NSString *title = [[NSBundle mainBundle] localizedStringForKey:[item objectForKey:@"title"]
																 value:[item objectForKey:@"title"]
																 table:@"MDSimpleGrouping"];
	
		// TODO: Replace by PAButton!
		NSButton *button = [[NSButton alloc] initWithFrame:frame];
		[button setTitle:title];
		[button setAction:@selector(buttonClick:)];
		[button setTarget:self];
		[button setButtonType:NSPushOnPushOffButton];
		[button setBezelStyle:NSRecessedBezelStyle];
		[button setTag:buttonIndex++];
		[button sizeToFit];
		
		// Activate first button
		if(x == 10)
		{
			[button setBordered:YES];
			[button setState:NSOnState];
		}
		
		NSRect buttonFrame = [button frame];
		x += buttonFrame.size.width + 7;
		
		[self addSubview:button];
		[buttons addObject:button];
		
		[button setShowsBorderOnlyWhileMouseInside:YES];
	}
}

- (void)buttonClick:(id)sender
{
	NSEnumerator *enumerator = [buttons objectEnumerator];
	NSButton *button;
	while(button = [enumerator nextObject])
	{
		if(button != sender)
		{
			[button setState:NSOffState];
			[button setBordered:NO];
		} else {
			[button setBordered:YES];
		}
	}
	
	PAQuery *query = [controller query];
	
	// Bundlings attributes that we set here need to be wrapped into an PAQueryItem in 
	// PAQuery's bundleResults:byAttributes:objectWrapping!! Only a few are there yet! TODO!
	switch([sender tag])
	{
		case 0:		// All
			[query filterResults:NO usingValues:nil forBundlingAttribute:nil
					      newBundlingAttributes:nil];
			break;
		case 1:		// Music
			[query filterResults:YES usingValues:[NSArray arrayWithObject:@"MUSIC"]
			                forBundlingAttribute:@"kMDItemContentTypeTree"
						   newBundlingAttributes:[NSArray arrayWithObjects:(id)kMDItemAuthors, (id)kMDItemAlbum, nil]];
			break;
		case 3:		// PDF
			[query filterResults:YES usingValues:[NSArray arrayWithObject:@"PDF"]
			                forBundlingAttribute:@"kMDItemContentTypeTree"
						   newBundlingAttributes:nil];
			break;
		case 4:		// Images
			[query filterResults:YES usingValues:[NSArray arrayWithObject:@"IMAGES"]
			                forBundlingAttribute:@"kMDItemContentTypeTree"
						   newBundlingAttributes:nil];
			break;
	}
	
	[outlineView reloadData];
}


#pragma mark Drawing
- (void)drawRect:(NSRect)aRect
{
	// Draw background
	NSImage *backgroundImage = [NSImage imageNamed:@"SearchSliceViewBackground"];
	
	[backgroundImage setFlipped:YES];
	[backgroundImage setScalesWhenResized:YES];
	
	NSRect imageRect;
	imageRect.origin = NSZeroPoint;
	imageRect.size = [backgroundImage size];
	
	NSRect dirtyRect = [self bounds];
	dirtyRect.origin.x = aRect.origin.x;
	dirtyRect.size.width = aRect.size.width;
		
	[backgroundImage drawInRect:dirtyRect fromRect:imageRect operation:NSCompositeCopy fraction:1.0];

	// Super
	[super drawRect:aRect];
}


#pragma mark Misc
- (BOOL)isFlipped
{
	return YES;
}

@end