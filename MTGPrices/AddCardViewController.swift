//
//  AddCardViewController.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/30/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit
import ReSwift

class AddCardViewController: UIViewController, StoreSubscriber {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var deck: Deck!
    var cardResults = [CardResult]()
    var searchedText: String?
    var parameters: [String: Any] = [:]
    
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Card Search"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(advancedSearchButtonTapped))
        
        searchBar.scopeButtonTitles = ["Alphabetical", "Color", "CMC"]
        searchBar.showsScopeBar = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        searchBar.selectedScopeButtonIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    
    func configureParameters() {
        self.searchBar.resignFirstResponder()
        if let cardName = searchBar.text {
            parameters["name"] = cardName
            submitSearch()
        }
    }
    
    @objc private func advancedSearchButtonTapped() {
        self.searchBar.resignFirstResponder()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchTableViewController") as? AdvancedSearchTableViewController {
            vc.cardName = searchBar.text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func submitSearch() {
        store.dispatch(searchForCardsActionCreator(url: "https://api.magicthegathering.io/v1/cards", parameters: parameters))
    }
    
    
    // MARK: - StoreSubscriber Delegate Methods
    
    func newState(state: State) {
        if let newParameters = state.parameters {
            self.parameters = newParameters
        }
        
        if state.shouldSearch {
            submitSearch()
        } else {
            searchBar.text = (parameters["name"] as? String) ?? nil
            if let result = state.cardResults {
                if result.isSuccess {
                    self.cardResults = result.value!
                    tableView.reloadData()
                } else {
                    if let error = result.error {
                        print("error: \(error)")
                    }
                }
            }
        }
    }
    

}
