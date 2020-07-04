//
//  Joke.swift
//  International Jokes
//
//  Created by Ephrem Beaino on 7/4/20.
//  Copyright © 2020 ephrembeaino. All rights reserved.
//

import UIKit

class Joke {
    var id: String
    var description: String?
    var likes: Int?
    var dislikes: Int?
    
    init(dictionary: [String: Any], id: String) {
        self.description = dictionary["description"] as? String
        self.likes = dictionary["likes"] as? Int
        self.dislikes = dictionary["dislikes"] as? Int
        self.id = id
    }
}
