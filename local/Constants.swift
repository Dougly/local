//
//  Constants.swift
//  Local
//
//  Created by Douglas Galante on 7/19/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

import Foundation
import Firebase

struct Constants {
    
    static let foreground = NSNotification.Name("AppToForegroundNotification")
    static let keywordChanged = NSNotification.Name("KeyWordsChangedNotification")
    static let googleMapAPIKey = "AIzaSyBim_-bgtrgl7sp7C4p_76kaLVgyWpBvYY"
    
    
    //MARK: Analytics
    static let searchEvent = AnalyticsEventSearch
    static let loginEvent = AnalyticsEventLogin
    static let shareButtonTappedEvent = "share_button_tapped"
    static let selectedListItemEvent = "selected_list_item"
    static let selectedMapPopupEvent = "selected_map_popup"
    static let tappedMapPinEvent = "tapped_map_pin"
    static let tappedMapClusterEvent = "tapped_map_cluster"
    
    //sign in can be replaced with AnalyticeEventSignUp once bigQuery is setup
    //let signUpEvent = AnalyticsEventSignUp
    static let facebookSignInEvent = "signed_in_with_facebook"
    static let googleSignInEvent = "signed_in_with_google"
    
    //Once these are different view controllers can use screen_view instead of custom events
    //Use Analytics.setScreenName(screenName, screenClass: screenClass) for each VC to set name automatically
    static let switchedToMapViewEvent: String = "switched_to_map_view"
    static let switchedToListViewEvent: String = "switched_to_list_view"
    static let openedFilterMenuEvent = "opened_filter_menu"
    
    //Need to be more specific with filters
    let selectedFilterEvent = "selected_filter"
    
    
}
