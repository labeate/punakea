//
//  PARegistrationManager.h
//  punakea
//
//  Created by Daniel on 21.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//ka #import "PASingleton.h"

#import "PALicense.h"
#import "PATrialLicense.h"
#import "PARegisteredLicense.h"



@interface PARegistrationManager : NSWindowController {

	NSUserDefaults						*userDefaults;
	
	PALicense							*license;
	NSDate								*timeLimitedBetaExpirationDate;
	
	IBOutlet NSWindow					*licenseKeyWindow;
	IBOutlet NSWindow					*expirationWindow;
	
	IBOutlet NSProgressIndicator		*licenseKeyWindowProgressIndicator;
	IBOutlet NSTextField				*licenseKeyWindowNameTextField;
	IBOutlet NSTextField				*licenseKeyWindowKeyTextField;
	
}

+ (PARegistrationManager *)defaultManager;

- (IBAction)confirmNewLicenseKey:(id)sender;
- (void)writeLicenseToDefaults:(PALicense *)license;

- (IBAction)showEnterLicenseKeyWindow:(id)sender;
- (IBAction)showVersionHasExpiredWindow:(id)sender;
- (IBAction)stopModal:(id)sender;
- (IBAction)terminate:(id)sender;

- (BOOL)hasRegisteredLicense;
- (BOOL)hasTrialLicense;
- (BOOL)isTimeLimitedBeta;

- (BOOL)hasExpired;

- (PALicense *)license;
- (void)setLicense:(PALicense *)aLicense;

@end
