//
//  UIViewController+Alert.swift
//  International Jokes
//
//  Created by Ephrem Beaino on 7/4/20.
//  Copyright © 2020 ephrembeaino. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
