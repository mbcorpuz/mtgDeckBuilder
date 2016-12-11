//
//  AdvancedSearchTableViewController.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/1/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit
import ReSwift

// Probably change this whole implementation to make it look something like Yelp's filter screen

class AdvancedSearchTableViewController: UITableViewController, StoreSubscriber {
    
    // MARK: - Stored Properties
    
    var cardName: String?
    var parameters = [String: Any]()
    var colors = [String]()
    var rarities = [String]()
    var types = [String]()
    
    var matchColorsExactly = false
    var andColors = false
    
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Filters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        tableView.register(ColorSelectionTableViewCell.self, forCellReuseIdentifier: Cell.colorSelectionCell)
        tableView.register(ColorConstraintsTableViewCell.self, forCellReuseIdentifier: Cell.colorConstraintCell)
        tableView.register(FirstRarityTableViewCell.self, forCellReuseIdentifier: Cell.firstRarityCell)
        tableView.register(SecondRarityTableViewCell.self, forCellReuseIdentifier: Cell.secondRarityCell)
        tableView.register(FirstTypeSelectionTableViewCell.self, forCellReuseIdentifier: Cell.firstTypeSelectionCell)
        tableView.register(SecondTypeSelectionTableViewCell.self, forCellReuseIdentifier: Cell.secondTypeSelectionCell)
        tableView.register(ThirdTypeSelectionTableViewCell.self, forCellReuseIdentifier: Cell.thirdTypeSelectionCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }
    
    // MARK: - Methods
    
    func searchButtonTapped() {
        configureParameters()
        store.dispatch(PrepareForSearch(parameters: parameters))
        _ = navigationController!.popViewController(animated: true)
    }
    
    func configureParameters() {
        parameters.removeAll()
        
        parameters["orderBy"] = "name"
        
        // Name
        if let name = cardName {
            parameters["name"] = name
        }
        
        // Colors
        if !colors.isEmpty {
            var colorString: String
            switch (matchColorsExactly, andColors) {
            case (true, _):
                colorString = colors.joined(separator: ",")
                colorString.insert("\"", at: colorString.startIndex)
                colorString.insert("\"", at: colorString.endIndex)
            case (false, true):
                colorString = colors.joined(separator: ",")
            case (false, false):
                colorString = colors.joined(separator: "|")
            }
            
            parameters["colors"] = colorString
        }
        
        // Rarities
        if !rarities.isEmpty {
            parameters["rarity"] = rarities.joined(separator: "|")
        }
        
        // Types
        if !types.isEmpty {
            parameters["types"] = types.joined(separator: "|")
        }
    }
    
    func colorSelectionButtonSelected(sender: UIButton!) {
        print("got color selection choice")
        guard sender.tag == ButtonTags.colorSelection else { return }
        
        let color = sender.titleLabel!.text!
        if sender.isSelected {
            colors.append(color)
        } else {
            colors.remove(at: colors.index(of: color)!)
        }
    }
    
    func colorConstraintsButtonSelected(sender: UIButton!) {
        guard sender.tag == ButtonTags.colorConstraint else { return }
        
        if sender.titleLabel!.text! == "Match Exactly" {
            matchColorsExactly = sender.isSelected
        } else {
            andColors = sender.isSelected
        }
    }
    
    func rarityButtonSelected(sender: UIButton!) {
        guard sender.tag == ButtonTags.raritySelection else { return }
        
        let rarity = sender.titleLabel!.text!
        if sender.isSelected {
            rarities.append(rarity)
        } else {
            rarities.remove(at: rarities.index(of: rarity)!)
        }
    }
    
    func typeSelectionButtonSelected(sender: UIButton!) {
        guard sender.tag == ButtonTags.typeSelection else { return }
        
        let type = sender.titleLabel!.text!
        if sender.isSelected {
            types.append(type)
        } else {
            types.remove(at: types.index(of: type)!)
        }
    }
    
    // TODO: - Implement this somehow
    private func restoreButtonSelections(parameters storeParameters: [String: Any]?) {
        
    }
    
    
    // MARK: - Supporting Functionality
    
    struct ButtonTags {
        static let colorSelection = 0
        static let colorConstraint = 1
        static let raritySelection = 2
        static let typeSelection = 3
        static let typeConstraint = 4
    }
    
    
    // MARK: - StoreSubscriber Delegate Methods
    
    func newState(state: State) {
        restoreButtonSelections(parameters: state.parameters)
    }
    
}
