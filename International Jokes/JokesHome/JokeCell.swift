//
//  JokeCell.swift
//  International Jokes
//
//  Created by Ephrem Beaino on 7/4/20.
//  Copyright © 2020 ephrembeaino. All rights reserved.
//

import UIKit

class JokeCell: UITableViewCell {
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeImage: UIImageView!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    var joke: Joke? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.likeLabel.text = "Like"
        self.dislikeLabel.text = "Dislike"
    }
    
    func updateUI() {
        guard let joke = joke else { return }
        self.jokeLabel.text = joke.description ?? ""
        self.likeLabel.text = String(joke.likes ?? 0)
        self.dislikeLabel.text = String(joke.dislikes ?? 0)
    }
}
