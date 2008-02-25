/* TaggerController */

#import <Cocoa/Cocoa.h>
#import "TagAutoCompleteController.h"
#import "NNTagging/NNTaggableObject.h"
#import "PATypeAheadFind.h"
#import "PADropManager.h"
#import "PATaggerItemCell.h"
#import "PATaggerHeaderCell.h"
#import "PAThumbnailItem.h"
#import "PAStatusBar.h"

@interface TaggerController : NSWindowController
{	
	IBOutlet NSTableView				*tableView;
	IBOutlet PAStatusBar				*statusBar;
	
	IBOutlet NSButton					*manageFilesButton;
	
	IBOutlet TagAutoCompleteController	*tagAutoCompleteController;
	
	NSArray								*initialTags;						/**< Tags that are present before editing. */
	
	BOOL								manageFiles;
	BOOL								manageFilesAutomatically;
	BOOL								showsManageFiles;
	
	PATaggerItemCell					*fileCell;
	PATaggerHeaderCell					*headerCell;
	
	NSMutableArray						*taggableObjects;

	PADropManager						*dropManager;
	
}

- (void)addTaggableObject:(NNTaggableObject *)anObject;
- (void)addTaggableObjects:(NSArray *)theObjects;
- (void)setTaggableObjects:(NSArray *)theObjects;

- (void)resizeTokenField;

- (IBAction)changeManageFilesFlag:(id)sender;

- (void)setManageFiles:(BOOL)flag;
- (void)setShowsManageFiles:(BOOL)flag;
- (BOOL)isEditingTagsOnFiles;

@end
