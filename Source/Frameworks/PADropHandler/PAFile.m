//
//  PAFile.m
//  punakea
//
//  Created by Johannes Hoffart on 15.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PAFile.h"

@interface PAFile (PrivateAPI)

- (void)setPath:(NSString*)path; /**< checks for illegal characters */
- (BOOL)isEqualToFile:(PAFile*)otherFile;

@end

@implementation PAFile

#pragma mark init+dealloc
// designated initializer
- (id)initWithPath:(NSString*)aPath
{
	if (self = [super init])
	{
		[self setPath:aPath];
		workspace = [NSWorkspace sharedWorkspace];
		fileManager = [NSFileManager defaultManager];
	}
	return self;
}

- (id)initWithFileURL:(NSURL*)url
{
	if ([url isFileURL])
	{
		return [self initWithPath:[url path]];
	}
	else
	{
		NSLog(@"error: %@ is not a file URL",url);
		return nil;
	}
}
	
- (void)dealloc
{
	[path release];
	[super dealloc];
}

- (void)setPath:(NSString*)aPath
{
	NSMutableString *copy = [aPath mutableCopy];
	[copy replaceOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0,[path length])];
	[copy replaceOccurrencesOfString:@"/" withString:@"_" options:0 range:NSMakeRange(0,[path length])];
	
	[path release];
	path = [[NSString alloc] initWithString:copy];
	[copy release];
}

+ (PAFile*)fileWithPath:(NSString*)aPath
{
	PAFile *file = [[PAFile alloc] initWithPath:aPath];
	return [file autorelease];
}

+ (NSArray*)filesWithFilepaths:(NSArray*)filepaths
{
	NSMutableArray *files = [NSMutableArray array];
	
	NSEnumerator *e = [filepaths objectEnumerator];
	NSString *path;
	
	while (path = [e nextObject])
	{
		[files addObject:[self fileWithPath:path]];
	}
	
	return files;
}
	
+ (PAFile*)fileWithFileURL:(NSURL*)url
{
	PAFile *file = [[PAFile alloc] initWithFileURL:url];
	return [file autorelease];
}

#pragma mark accessors
- (NSString*)path
{
	return path;
}

- (NSString*)standardizedPath
{
	return [path stringByStandardizingPath];
}

- (NSString*)name
{
	return [path lastPathComponent];
}

- (NSString*)nameWithoutExtension
{
	return [[self name] stringByDeletingPathExtension];
}

- (NSString*)extension
{
	return [path pathExtension];
}

- (NSString*)directory
{
	return [path stringByDeletingLastPathComponent];
}

- (BOOL)isDirectory
{
	BOOL isDirectory;
	[fileManager fileExistsAtPath:[self standardizedPath] isDirectory:&isDirectory];
	return isDirectory;
}

- (NSImage*)icon
{
	return [workspace iconForFile:path];
}

- (NSString *)description
{
	return [@"file:" stringByAppendingString:path];
}

#pragma mark euality testing
- (BOOL)isEqual:(id)other 
{
	if (!other || ![other isKindOfClass:[self class]]) 
        return NO;
    if (other == self)
        return YES;
	
    return [self isEqualToFile:other];
}

- (BOOL)isEqualToFile:(PAFile*)otherFile 
{
	if ([path isEqual:[otherFile path]])
		return YES;
	else
		return NO;
}


@end