//
//  BookmarkListVC.swift
//  RedditModRank
//
//  Created by Work on 28/02/2020.
//  Copyright © 2020 JotCode. All rights reserved.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    let tableView               = UITableView()
    var favorites: [Subreddit]  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.resuseID)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let favorites):
                    if favorites.isEmpty {
                        self.showEmptyState(with: "No Favorites\nAdd one on the subreddit screen.", in: self.view)
                    } else {
                        self.favorites = favorites
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.view.bringSubviewToFront(self.tableView)
                        }
                    }
                    self.favorites = favorites
                case .failure(let error):
                    self.presentMRAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    

}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.resuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite        = favorites[indexPath.row]
        let destVC          =  ModListVC()
        destVC.subreddit    = favorite.displayName
        destVC.title        = favorite.displayName
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let favorite  = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentMRAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
