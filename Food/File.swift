//
//  File.swift
//  Food
//
//  Created by Gouthami Reddy on 8/17/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import os.log

class Meal : NSObject, NSCoding {
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("unable to decode the name for a Meal object", log: OSLog.default, type: .debug)
                return nil
        }
        let photo  = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating)
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
   

        init?(name: String, photo: UIImage?, rating: Int) {
            
            guard !name.isEmpty else {
                return nil
        }
            guard (rating >= 0) && (rating <= 5) else {
                return nil 
            }
    
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        
    }
    
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("meals")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
}
