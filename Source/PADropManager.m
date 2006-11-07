//
//  PADropManager.m
//  punakea
//
//  Created by Johannes Hoffart on 08.09.06.
//  Copyright 2006 nudge:nudge. All rights reserved.
//

#import "PADropManager.h"

@interface PADropManager (PrivateAPI)



@end

@implementation PADropManager

//this is where the sharedInstance is held
static PADropManager *sharedInstance = nil;
NSString *ext = @"pudh";
NSString *appSupportSubpath = @"Application Support/Punakea/PlugIns";

#pragma mark init
//constructor - only called by sharedInstance
- (id)sharedInstanceInit {
	if (self = [super init])
	{
		// load all drophandlers
		dropHandlers = [[NSMutableArray alloc] init];
		[self loadAllPlugins];
	}
	return self;
}

- (void)dealloc
{
	[dropHandlers release];
	[super dealloc];
}

- (void)registerDropHandler:(PADropHandler*)handler
{
	[dropHandlers addObject:handler];
}
	
- (void)removeDropHandler:(PADropHandler*)handler
{
	[dropHandlers removeObject:handler];
}

- (NSArray*)handledPboardTypes
{
	NSMutableArray *handledTypes = [NSMutableArray array];
	
	NSEnumerator *e = [dropHandlers objectEnumerator];
	PADropHandler *dropHandler;
	
	while (dropHandler = [e nextObject])
	{
		[handledTypes addObject:[dropHandler pboardType]];
	}
	
	return handledTypes;
}

- (NSArray*)handleDrop:(NSPasteboard*)pasteboard
{
	NSArray *result = nil;
	
	NSEnumerator *e = [dropHandlers objectEnumerator];
	PADropHandler *dropHandler;
	
	// all dropHandlers are queried if they handle the needed pboardType
	while (dropHandler = [e nextObject])
	{
		if ([dropHandler willHandleDrop:pasteboard])
		{
			result = [dropHandler handleDrop:pasteboard];
		}
	}

	return [PAFile filesWithFilepaths:result];
}

- (NSDragOperation)performedDragOperation:(NSPasteboard*)pasteboard
{
	NSDragOperation op = NSDragOperationNone;
	
	NSEnumerator *e = [dropHandlers objectEnumerator];
	PADropHandler *dropHandler;
	
	while (dropHandler = [e nextObject])
	{
		if ([dropHandler willHandleDrop:pasteboard])
			op = [dropHandler performedDragOperation:pasteboard];
	}
	
	return op;
}

#pragma mark plugin stuff
- (void)loadAllPlugins
{
    NSMutableArray *bundlePaths;
    NSEnumerator *pathEnum;
    NSString *currPath;
    NSBundle *currBundle;
    Class currPrincipalClass;
    id currInstance;
    
    bundlePaths = [NSMutableArray array];
   
    [bundlePaths addObjectsFromArray:[self allBundles]];
    
    pathEnum = [bundlePaths objectEnumerator];
    while(currPath = [pathEnum nextObject])
    {
        currBundle = [NSBundle bundleWithPath:currPath];
        if(currBundle)
        {
            currPrincipalClass = [currBundle principalClass];
            if(currPrincipalClass &&
               [self plugInClassIsValid:currPrincipalClass])  // Validation
            {
                currInstance = [[currPrincipalClass alloc] init];
                if(currInstance)
                {
					NSLog(@"dropHandler %@ registered",currInstance);
                    [dropHandlers addObject:[currInstance autorelease]];
                }
            }
        }
    }
}

- (NSMutableArray *)allBundles
{
    NSArray *librarySearchPaths;
    NSEnumerator *searchPathEnum;
    NSString *currPath;
    NSMutableArray *bundleSearchPaths = [NSMutableArray array];
    NSMutableArray *allBundles = [NSMutableArray array];
    
    librarySearchPaths = NSSearchPathForDirectoriesInDomains(
															 NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
    
    searchPathEnum = [librarySearchPaths objectEnumerator];
    while(currPath = [searchPathEnum nextObject])
    {
        [bundleSearchPaths addObject:
            [currPath stringByAppendingPathComponent:appSupportSubpath]];
    }
    [bundleSearchPaths addObject:
        [[NSBundle mainBundle] builtInPlugInsPath]];
    
    searchPathEnum = [bundleSearchPaths objectEnumerator];
    while(currPath = [searchPathEnum nextObject])
    {
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        if(bundleEnum)
        {
            while(currBundlePath = [bundleEnum nextObject])
            {
                if([[currBundlePath pathExtension] isEqualToString:ext])
                {
					[allBundles addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
                }
            }
        }
    }
    
    return allBundles;
}

- (BOOL)plugInClassIsValid:(Class)plugInClass
{
    if([plugInClass isSubclassOfClass:[PADropHandler class]])
    {
        return YES;
    }
    
    return NO;
}


#pragma mark singleton stuff
+ (PADropManager*)sharedInstance {
	@synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] sharedInstanceInit];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
        }
    }
    return sharedInstance;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
