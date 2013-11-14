
//
//  FriendSuggestionViewController.h
//  Sterling_iOS
//
//  Created by Adam Gluck on 9/9/13.
//  Copyright (c) 2013 Sterling. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CloseFriendsDataAccess.h"
/**
 This allows you to respond to events in the friendSuggestionViewController
 */
@protocol FriendSuggestionViewControllerDelegate <NSObject>
@optional
/**
@abstract This is called when the user posts an invitation through our servers.  
@param FBIDs an array of NSStrings containing the Facebook IDs that the user posted to.
@discussion It returns the Facebook IDs that the user posted the request to.  This may be useful if you are implementing a coupon system or internal reward system for invitations posted.
*/
-(void)invitationPostedToIDs:(NSArray *)FBIDs;
/**
@abstract This is called when the user exits the view through pressing the cancel button.
 */
-(void)cancelPressed;

/**
@abstract This is called when the user enters the view but is not logged in through Facebook.
@discussion Use this method in order to open or create a session.  Possible responses are
*/
-(void)facebookErrorResponse:(SterlingRequestServerResponse)response;

@end
@interface FriendSuggestionViewController : UIViewController

/**
 @abstract The class delegate.
 */
@property (weak, nonatomic) id <FriendSuggestionViewControllerDelegate> delegate;

/**
 @abstract The UIFont of the buttons on the bottom of the view
*/
@property (strong, nonatomic) UIFont * buttonFont;

/**
 @abstract The UIFont of the name labels.
*/
@property (strong, nonatomic) UIFont * labelFont;

/**
@abstract Possible selection colors for selecting friends.
@discussion This is an array of colors that will overlay the images when the user selects them.  They are randomly selected.  It defaults to [UIColor blueColor]
*/
@property (strong, nonatomic) NSArray * selectionColors;
/**
 @abstract This is the background of the view. 
 @discussion You can set the color of the status bar by setting backgroundView.backgroundColor property.
 */
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

/**
@abstract This exposes the search button.
@discussion Used to modifying apperance.
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

/**
@abstract This exposes the cancel button.
@discussion Used to modify appearance.
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
/**
 @abstract This exposes the navigationBar.
 @discussion Used to modify appearance.
 */
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
/**
@abstract The backAndNext button colors.  
@discussion They default to [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:.7f] (light gray)
 */
@property (strong, nonatomic) UIColor * backAndNextButtonColor;
/**
@abstract The enter button color.  
@discussion Defaults to [UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:.7f] (dark gray).
*/
@property (strong, nonatomic) UIColor * enterButtonColor;

/**
@abstract Returns a FriendSugestionViewController with the views loaded.
@discussion Normal use case:
   FriendSuggestionViewController * vc = [FriendSuggestionViewController initializeFriendSuggestionViewController];
   // configure properties
   [self presentViewController:dst animated:YES completion:nil];
*/
+(FriendSuggestionViewController*)initializeFriendSuggestionViewController;

/**
@abstract Loads a friends list into the viewController.
@discussion This will be called automatically in the view when it appears.  The use case for this is in response to the delegate method facebookErrorResponse: once you open a session to reload the view.  If this is your first time creating a facebook session, you may also want to use sterlingUserLogin and wait for a callback before calling this.
*/
-(void)friendsListForCurrentFacebookUser;


@end
