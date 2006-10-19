//
//  PABrowserSplitView.m
//  punakea
//
//  Created by Johannes Hoffart on 17.10.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PABrowserSplitView.h"


@implementation PABrowserSplitView

- (float)dividerThickness
{
	return 0.5;
}

- (void)drawDividerInRect:(NSRect)aRect
{
	[[NSColor grayColor] set];
	NSRectFill(aRect);
}

@end