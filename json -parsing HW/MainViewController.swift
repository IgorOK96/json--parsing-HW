//
//  ViewController.swift
//  json -parsing HW
//
//  Created by user246073 on 9/22/24.
//

import UIKit

enum Link {
    case postURL
    case CommentURl
    case userURL
    
    var url: URL {
        switch self {
        case .postURL:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .CommentURl:
            return URL(string: "https://jsonplaceholder.typicode.com/comments")!
        case .userURL:
            return URL(string: "https://jsonplaceholder.typicode.com/users")!
        }
    }
}

enum UserAction: CaseIterable {
    case showPost
    case showComment
    case showUser
    
    var title: String {
        switch self {
        case .showPost:
            return "Show Post"
        case .showComment:
            return "Show Comment"
        case .showUser:
            return "Show User"
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failde"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the result in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

final class MainViewController: UICollectionViewController {
    private let userActions = UserAction.allCases

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath)
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        cell.userActionLabel.text = userActions[indexPath.item].title
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        switch userAction {
        case .showPost: fetchPost()
        case .showComment: fetchComment()
        case .showUser: fetchUser()
        }
    }
    
    //MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

//MARK: - MainViewControllerDelegate - Size Frame
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48 , height: 100)
    }
}

    //MARK: - Networking
extension MainViewController {
    
    private func fetchPost() {
        URLSession.shared.dataTask(with: Link.postURL.url) { [weak self] data, _, error in
            guard let self else { return }
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                var resultString = ""
                
                for post in posts {
                    resultString += "ID: \(post.id)\n"
                    resultString += "UserID: \(post.userId)\n"
                    resultString += "Title: \(post.title)\n"
                    resultString += "Body: \(post.body)\n\n"
                }
                print(resultString)
                showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                showAlert(withStatus: .failed)
            }
        }.resume()
    }

    private func fetchComment() {
        URLSession.shared.dataTask(with: Link.CommentURl.url) { [weak self] data, _, error in
            guard let self else { return }
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let comments = try JSONDecoder().decode([Comments].self, from: data)
                var resultString = ""
                for comment in comments {
                    resultString += "ID: \(comment.id)\n"
                    resultString += "PostID: \(comment.postId)\n"
                    resultString += "Name: \(comment.name)\n"
                    resultString += "Email: \(comment.email)\n"
                    resultString += "Body: \(comment.body)\n\n"
                }
                print(resultString)
                showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                showAlert(withStatus: .failed)
            }
        }.resume()
    }
    
    private func fetchUser() {
        URLSession.shared.dataTask(with: Link.userURL.url) { [weak self] data, _, error in
            guard let self else { return }
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                var resultString = ""
                
                for user in users {
                    resultString += "ID: \(user.id)\n"
                    resultString += "Name: \(user.name)\n"
                    resultString += "Username: \(user.username)\n"
                    resultString += "Email: \(user.email)\n"
                    resultString += "Phone: \(user.phone)\n"
                    resultString += "Website: \(user.website)\n"
                    resultString += "Company: \(user.company.name)\n"
                    resultString += "Address: \(user.address.street), \(user.address.suite), \(user.address.city)\n\n"
                }
                print(resultString)
                showAlert(withStatus: .success)
            } catch {
                print(error.localizedDescription)
                showAlert(withStatus: .failed)
            }
        }.resume()
    }
}

