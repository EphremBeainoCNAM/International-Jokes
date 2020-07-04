//
//  HomeViewController.swift
//  International Jokes
//
//  Created by Ephrem Beaino on 7/4/20.
//  Copyright © 2020 ephrembeaino. All rights reserved.
//

import UIKit
import FirebaseFirestore

let FIREBASE_COLLECTION_NAME: String = "Jokes"

class HomeViewController: UITableViewController {
    
    var jokes: [Joke] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "International Jokes"
        self.tableView.register(UINib(nibName: "NewJokeCell", bundle: nil), forCellReuseIdentifier: "NewJokeCell")
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutUser))
        
        self.getAllJokes()
    }
    
    @objc func logoutUser() {
        let sb = UIStoryboard(name: "Auth", bundle: nil)
        let chosenVC = sb.instantiateInitialViewController()
        guard let authVC = chosenVC else { return }
        self.navigationController?.setViewControllers([authVC], animated: true)
    }
    
    func getAllJokes() {
        self.jokes = []
        db.collection(FIREBASE_COLLECTION_NAME).getDocuments { (response, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else if let response = response {
                for document in response.documents {
                    let joke = Joke(dictionary: document.data(), id: document.documentID)
                    self.jokes.append(joke)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewJokeCell? = tableView.dequeueReusableCell(withIdentifier: "NewJokeCell", for: indexPath) as? NewJokeCell
        if let cell = cell {
            let joke = self.jokes[indexPath.row]
            cell.joke = joke
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func addButtonPressed() {
        let alert = UIAlertController(title: "Add Joke!", message: "Write your joke!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //add joke
            let jokeStr = alert.textFields?[0].text ?? ""
            if jokeStr.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                self.db.collection(FIREBASE_COLLECTION_NAME).addDocument(data: ["description" : jokeStr, "likes" : 0, "dislikes" : 0]) { (error) in
                    if let error = error {
                        self.showAlert(title: "Error adding joke", message: error.localizedDescription)
                    } else {
                        self.getAllJokes()
                    }
                }
            } else {
                self.showAlert(title: "Error!", message: "Joke field cannot be empty")
            }
        }
        alert.addAction(addAction)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your joke here!"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

//Swipe gestures
extension HomeViewController {
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let likeAction = UIContextualAction(style: .normal, title: "Like") { (action, view, onSuccess) in
            let joke = self.jokes[indexPath.row]
            let likes = (joke.likes ?? 0) + 1
            self.db.collection(FIREBASE_COLLECTION_NAME).document(joke.id).updateData(["likes": likes]) { (error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.getAllJokes()
                }
            }
            onSuccess(true)
        }
        likeAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [likeAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dislikeAction = UIContextualAction(style: .normal, title: "Dislike") { (action, view, onSuccess) in
            let joke = self.jokes[indexPath.row]
            let dislikes = (joke.dislikes ?? 0) + 1
            self.db.collection(FIREBASE_COLLECTION_NAME).document(joke.id).updateData(["dislikes": dislikes]) { (error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.getAllJokes()
                }
            }
            onSuccess(true)
        }
        dislikeAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [dislikeAction])
    }
}
