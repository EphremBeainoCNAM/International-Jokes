//
//  NewJokeCell.swift
//  International Jokes
//
//  Created by Ephrem Beaino on 7/4/20.
//  Copyright © 2020 ephrembeaino. All rights reserved.
//

import UIKit

class NewJokeCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesLabel: UILabel!
    
    var joke: Joke? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI() {
        guard let joke = joke else { return }
        self.descriptionLabel.text = joke.description
        self.likesLabel.text = "\(String(joke.likes ?? 0)) likes"
        self.dislikesLabel.text = "\(String(joke.dislikes ?? 0)) dislikes"
    }
}
