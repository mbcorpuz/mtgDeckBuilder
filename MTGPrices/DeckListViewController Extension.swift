//
//  DeckListViewController Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/28/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import UIKit

extension DeckListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Data Source & Delegate Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "\(decks.count) Decks"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return decks.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.section == 0 {
            // Add Deck
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.addDeckCellIdentifier, for: indexPath)
            cell.textLabel?.text = "Add Deck"
        } else {
            // Show Deck
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.showDeckCellIdentifier, for: indexPath)
            let deck = decks[indexPath.row]
            cell.textLabel?.text = deck.name
            cell.detailTextLabel?.text = "\(deck.format)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Add Deck
            store.dispatch(AddNewDeck(name: nil, format: "Modern"))
        } else {
            // Show Deck
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DeckViewController") as? DeckViewController {
                vc.deck = decks[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        store.dispatch(EditDeck(deck: decks[indexPath.row], name: "Changed deck name", format: "Legacy"))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.dispatch(DeleteDeck(deck: decks[indexPath.row], index: indexPath.row))
        }
    }
    
    
    // MARK: - Supporting Functionality
    
    struct Cell {
        static let addDeckCellIdentifier = "Add Deck"
        static let showDeckCellIdentifier = "Show Deck"
    }
    
}
