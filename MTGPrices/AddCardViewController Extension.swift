//
//  AddCardViewController Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/30/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import UIKit

extension AddCardViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        parameters.removeAll()
        configureParameters()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0: parameters["orderBy"] = "name"
        case 1: parameters["orderBy"] = "colors"
        default: parameters["orderBy"] = "cmc"
        }
        configureParameters()
    }
    
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.resultCell, for: indexPath)
        let result = cardResults[indexPath.row]
        
        cell.textLabel?.text = result.name
        cell.detailTextLabel?.text = "Type: \(result.types.joined(separator: " ")), Cost: \(result.manaCost ?? "none"), Set: \(result.set!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        
        let card = cardResults[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController {
            vc.cardResult = card
            vc.deck = deck
            vc.shouldUseResult = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        var card = cardResults[indexPath.row]
//        let ac = UIAlertController(title: "Add \(card.name!)", message: "Select amount", preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        for i in 1...4 {
//            ac.addAction(UIAlertAction(title: String(i), style: .default, handler: { [unowned self] action in
//                card.amount = i
//                store.dispatch(AddCardResultToDeck(deck: self.deck, card: card))
//            }))
//        }
//        present(ac, animated: true)
    }
    
    
    // MARK: - Supporting Functionality
    
    struct Cell {
        static let resultCell = "Card Result"
    }
}
