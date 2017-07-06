//
//  UtilityFunctions.swift
//  Hijinnks
//
//  Created by adeiji on 4/3/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Parse

class UtilityFunctions {
    
    /**
     * - Description Check to see if a user is Current user or not
     * - Parameter user PFUser - The user we're checking to see if is current or not
     * - Returns Bool - Whether or not the user is the current user
     ```
        UtilityFunctions.isCurrent(user: self.user)
     ```
     */
    class func isCurrent (user: PFUser) -> Bool {
        if user.objectId == PFUser.current()?.objectId {
            return true
        }
        
        return false
    }
    
    class func getParseUserObjectsFromObjectIds (user: PFUser, objectIds: [String]) -> [PFUser]! {
        let query = PFUser.query()
        // Get all the Users that have ObjectIds stored on the device as friends object ids
        query?.whereKey(ParseObjectColumns.ObjectId.rawValue, containedIn: user.object(forKey: ParseObjectColumns.Friends.rawValue) as! [Any])
        do {
            let users = try query?.findObjects()
            return users as? [PFUser]
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    class func hideNavBar () {
        UINavigationBar.appearance().setBackgroundImage(nil, for: .default)
    }
    
    /**
     * - Description Get a view with an interest icon and it's corresponding text
     * - Parameter [String] interests
     * - Returns UIView! The view which will contain
     */
    class func getInterestIcon (interest: String) -> UIView! {
        let ARTS = 0, BARS = 1, CAFES = 2, COMEDY = 3, CULTURE = 4, DANCING = 5, MOVIES = 6, MUSIC = 7, OUTDOORS = 8, POOLS = 9, RESTAURANTS = 10, READING = 11, SHOWS = 12, GUNS = 13, SPORTS = 14, TRAVEL = 15
        if let path = Bundle.main.path(forResource: "interests", ofType: "plist") {
            let interestArray = NSArray(contentsOfFile: path) as? [String]!
            
            switch interest {
            case (interestArray?[ARTS])!:
                return getInterestView(interestIcon: InterestIcons.Arts.rawValue, interestString: InterestIcons.ArtsText.rawValue)
            case (interestArray?[BARS])!:
                return getInterestView(interestIcon: InterestIcons.BarsAndLounges.rawValue, interestString: InterestIcons.BarsAndLoungesText.rawValue)
            case (interestArray?[CAFES])!:
                return getInterestView(interestIcon: InterestIcons.Cafe.rawValue, interestString: InterestIcons.CafeText.rawValue)
            case (interestArray?[COMEDY])!:
                return getInterestView(interestIcon: InterestIcons.Comedy.rawValue, interestString: InterestIcons.ComedyText.rawValue)
            case (interestArray?[CULTURE])!:
                return getInterestView(interestIcon: InterestIcons.CulturePeopleWatching.rawValue, interestString: InterestIcons.CultureText.rawValue)
            case (interestArray?[DANCING])!:
                return getInterestView(interestIcon: InterestIcons.Dancing.rawValue, interestString: InterestIcons.DancingText.rawValue)
            case (interestArray?[MOVIES])!:
                return getInterestView(interestIcon: InterestIcons.Movies.rawValue, interestString: InterestIcons.MoviesText.rawValue)
            case (interestArray?[MUSIC])!:
                return getInterestView(interestIcon: InterestIcons.Music.rawValue, interestString: InterestIcons.MusicText.rawValue)
            case (interestArray?[OUTDOORS])!:
                return getInterestView(interestIcon: InterestIcons.Outdoors.rawValue, interestString: InterestIcons.OutdoorsText.rawValue)
            case (interestArray?[POOLS])!:
                return getInterestView(interestIcon: InterestIcons.Pools.rawValue, interestString: InterestIcons.PoolsText.rawValue)
            case (interestArray?[RESTAURANTS])!:
                return getInterestView(interestIcon: InterestIcons.Restaurants.rawValue, interestString: InterestIcons.RestaurantsText.rawValue)
            case (interestArray?[READING])!:
                return getInterestView(interestIcon: InterestIcons.Reading.rawValue, interestString: InterestIcons.ReadingText.rawValue)
            case (interestArray?[SHOWS])!:
                return getInterestView(interestIcon: InterestIcons.Shows.rawValue, interestString: InterestIcons.ShowsText.rawValue)
            case (interestArray?[GUNS])!:
                return getInterestView(interestIcon: InterestIcons.Shooting.rawValue, interestString: InterestIcons.ShootingText.rawValue)
            case (interestArray?[SPORTS])!:
                return getInterestView(interestIcon: InterestIcons.Exercise.rawValue, interestString: InterestIcons.ExerciseText.rawValue)
            case (interestArray?[TRAVEL])!:
                return getInterestView(interestIcon: InterestIcons.Travel.rawValue, interestString: InterestIcons.TraveText.rawValue)
            default:
                return getInterestView(interestIcon: InterestIcons.Restaurants.rawValue, interestString: InterestIcons.RestaurantsText.rawValue)
            }
        }
        return nil
    }
    
    class func getInterestView (interestIcon: String, interestString: String) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        let iconLabel = UILabel()
        iconLabel.text = interestIcon
        view.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.centerX.equalTo(view)
        }
        let interestLabel = UILabel()
        interestLabel.text = interestString
        interestLabel.font = UIFont.systemFont(ofSize: 14.0)
        view.addSubview(interestLabel)
        interestLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconLabel.snp.bottom).offset(5)
            make.centerX.equalTo(view)
        }
        
        return view
    }
    
    
    
}
