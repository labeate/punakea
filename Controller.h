/* Controller */

#import <Cocoa/Cocoa.h>
#import "PATagger.h"
#import "PARelatedTags.h"
#import "PAFileMatrix.h"
#import "SubViewController.h"
#import "PATagger.h"

@interface Controller : NSWindowController
{
    IBOutlet id drawer;
    IBOutlet NSOutlineView *outlineView;
	IBOutlet PAFileMatrix *fileMatrix;
	IBOutlet NSArrayController *relatedTagsController;
	IBOutlet NSArrayController *selectedTagsController;
	
	NSView *sidebarNibView;
	
	PATagger *tagger;
	
	NSMutableArray *tags;
	PARelatedTags *relatedTags;
	
	// Renamed from query to _query due to binding issues (like Spotlighter Sample does)
	NSMetadataQuery *_query;
}

- (IBAction)hoffartTest:(id)sender;

//saving and loading
- (NSString*)pathForDataFile;
- (void)saveDataToDisk;
- (void)loadDataFromDisk;
- (void)applicationWillTerminate:(NSNotification *)note;

//accessors
- (NSMutableArray*)tags;

//for NSMetadataQuery
- (NSMetadataQuery *)query;
- (void)selectedTagsHaveChanged;

//for adding to selected
- (void)addToSelectedTags;
- (IBAction)clearSelectedTags:(id)sender;

// For OutlineView Bindings
// - (NSMutableArray *) fileGroups;
@end
