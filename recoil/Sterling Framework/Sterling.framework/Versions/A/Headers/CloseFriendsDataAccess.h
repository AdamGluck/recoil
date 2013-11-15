//
//  CloseFriendsDataAccess.h
//  Sterling_iOS
//
//  Created by Adam Gluck on 9/9/13.
//  Copyright (c) 2013 Sterling. All rights reserved.
//
#import <Foundation/Foundation.h>
@class FriendSuggestionViewController;

/*!
 @discussion Delegate protocol to handle responses from the Sterling server.  The DataAccessObject calls sterlingServerResponse: on the delegate in response to actions from the server.  Possible values for the SterlingRequestServerResponse type are
 
 SterlingRequestFailed, the request failed, something was passed incorrectly or some other error occured not related to connectivity.  Make sure you have requested all permissions and that.

 SterlingRequestNoResponse, No response from the server, this likely means there is an internet connectivity issue on the user end

 SterlingLoginSucceded, the server returns a success message
 
 SterlingFacebookSessionFailedToOpen, We attempted to open the FBSession and it didn't work.
 
 SterlingFacebookSessionIsNotTokenLoaded, User hasn't logged in, make sure to have them do that.
*/

@protocol CloseFriendsDataAccessDelegate <NSObject>
/**
 Possible responses from the server.
 */
typedef NS_ENUM(NSInteger, SterlingRequestServerResponse){
    SterlingRequestFailed, /**< the request failed, something was passed incorrectly or some other error occured not related to connectivity.  Make sure you have requested all permissions and that  */
    SterlingRequestNoResponse, /**< No response from the server, this likely means there is an internet connectivity issue on the user end */
    SterlingLoginSucceded, /**< sterlingUserLogin method succeeded */
    SterlingFacebookSessionFailedToOpen, /**< We attempted to open the FBSession and it didn't work. */
    SterlingFacebookSessionIsNotTokenLoaded, /**<User hasn't logged in, make sure to have them do that.*/
    SterlingRequestProcessing, /**< This returns when the server is still processing a request, currently not used */
    SterlingInvitationSucceeded, /**< Invitations were sent to user, currently not used publically */
    SterlingInvitationsFailed, /**< Invitation posting failed for some reason */
};
@optional
/**
 These are the responses from the server.
 @param response this is the server response, see SterlingRequestServerResponse for the protocol.
 */
-(void)sterlingServerResponse: (SterlingRequestServerResponse) response;
/**
 The methods that get this response are hidden for now, but will likely open in the future.
 */
-(void)closeFriendsList:(NSDictionary *)list;
@end

/*!
Exposes methods to allow you to interact with the Sterling server.  We can then generate a list of their top friends to be used later!
The most common use case will be as follows (put the following code in the AppDelegate method applicationDidBecomeActive and in any sort of delegate or block methods that handle the user logging in):
 
        [[CloseFriendsDataAccess sharedSterling] sterlingUserLogin];
 
In order to guarantee that these functions work properly make sure that you have fulfilled these requirements, which are typical of anyone using the Facebook SDK.
 
1) Your FBSession is open.  We do manage this under the hood, but it's better for you to manage it yourself relative to your own control flow.
 
2) You are using the FBSession.activeSession (or [FBSession activeSession]) singleton to manage your FBSessions.  Some older versions of the FacebookSDK included sample code where the appDelegate holds onto the session, and you invoke that session throughout the code.  If you are using code like this, that is fine, you will just have to add one line of code before calling these methods:  [FBSession setActiveSession: session] where session is the session you are setting in the AppDelegate.  If you are using FBLoginView, then the activeSession is already set.
 
(Note: You should maybe think about refactoring your code to conform to this paradigm as a number of tools (such as FBFriendPickerController) use this, and it is also cleaner. For more: https://developers.facebook.com/docs/reference/ios/current/class/FBSession/ )
 */
@interface CloseFriendsDataAccess : NSObject

/*!
@abstract Class Singleton.
@discussion Always use this method to access class methods, underlying implementation details make it so that you are at risk for indeterminant behavior if you do not use this.
*/
+(CloseFriendsDataAccess *)sharedSterling;
/*!
@abstract The class delegate.
 */
@property (weak, nonatomic) id <CloseFriendsDataAccessDelegate> delegate;
/*!
@abstract Indicates to our server that a user has started the app.
@discussion Sends a message to our server so that we can begin to construct an intelligent list of your friends.  Returns messages through the sterlingServerResponse: delegate method.  This method is the same as sterlingUserLoginWithFirstPrompt:reoccursAt: at its defaults.
 */
-(void)sterlingUserLogin;
/*!
@abstract Indicates to our server that a user has started the app and allows you to set prompts to invite friends.
@discussion Sends a message to our server so that we can begin to construct an intelligent list of your friends.  Returns messages through the sterlingServerResponse: delegate method.
@param first this is the first time that the prompt will appear, defaults to 5 if you enter 0 or nil
@param reoccurs this is the number of logins before the prompt reoccurs after the first time it occurs, defaults to 10 if you enter 0 or nil
 */
-(void)sterlingUserLoginWithFirstPrompt: (NSInteger) first reoccursAt: (NSInteger) reoccurs;
/*!
@abstract Indicates if the user should be prompted
@discussion If this property is set to NO and sterlingUserLogin is called, it will not prompt the user ever.  Defaults to YES.
 */
@property (assign, nonatomic) BOOL shouldPrompt;

/*!
 @abstract class friendSuggestionViewController
 @discussion Set this to maintain the viewController automatically presented.
 */
@property (strong, nonatomic) FriendSuggestionViewController * suggestionController;


/*!
@abstract Returns the facebookID of the current user.
*/
+(NSString *)fb_id;
/*!
@abstract Tests to see if the user is loggedIn under the Sterling system.
*/
+(BOOL)loggedIn;

@end
