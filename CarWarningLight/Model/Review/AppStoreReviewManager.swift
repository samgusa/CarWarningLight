import StoreKit

// File to have the app store pop up appear

enum AppStoreReviewManager {
    
    //1. declare constant value to specify the number of times that user must perform a review-worthy action
    static let minimumReviewWorthyActionCount = 10
    
    static func requestReviewIfAppropriate() {
        //Next we need to ask StoreKit to request a review from the user.
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        //2. Read the current number of actions that the user has performed since the last requested review from User Defaults
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        
        //3. Increment the action count value read from User Defaults
        actionCount += 1
        
        //4. Set the incremented count back into the user defaults for the next time that you trigger the function
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)
        
        //5. Check if the action count has now exceeded the minimum threshold to trigger a review. If it hasn't, the function will now return
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        //6. Read the current bundle version and the last bundle version used during the last prompt (if any)
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        
        //7. Check if this is the first request for this version of the app before continuing
        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
        //8. Ask StoreKit to request a review
        SKStoreReviewController.requestReview()
        
        //9. Reset the action count and store the current version in User Defaults so that you don't request again on this version of the app
        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}
