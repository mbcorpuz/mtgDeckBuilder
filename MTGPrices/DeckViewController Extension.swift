//
//  DeckViewController Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/30/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import UIKit

extension DeckViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate, UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Creatures"
        case 2: return "Spells"
        case 3: return "Lands"
        default: return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Add Card
            return 1
        case 1:
            // Creature
            return creatures.count
        case 2:
            // Spell
            return spells.count
        default:
            // Land
            return lands.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            // Add Card
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.addCard, for: indexPath)
            cell.textLabel?.text = "Add Card"
        case 1:
            // Creature
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.creatureCell, for: indexPath)
            let creature = creatures[indexPath.row]
            cell.textLabel?.text = "\(creature.amount) \(creature.name)"
            cell.detailTextLabel?.text = "\(creature.type), Cost: \(creature.cmc), Colors: \(creature.colors!)"
        case 2:
            // Spell
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.spellCell, for: indexPath)
            let spell = spells[indexPath.row]
            cell.textLabel?.text = "\(spell.amount) \(spell.name)"
            cell.detailTextLabel?.text = "\(spell.type), Cost: \(spell.cmc), Colors: \(spell.colors!)"
        default:
            // Land
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.landCell, for: indexPath)
            let land = lands[indexPath.row]
            cell.textLabel?.text = "\(land.amount) \(land.name)"
            cell.detailTextLabel?.text = "\(land.type)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Add Card
            if let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController {
                vc.deck = deck
                navigationController?.pushViewController(vc, animated: true)
            }
        } else { // Display Card
            if let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController {
                vc.deck = deck
                switch indexPath.section {
                case 1: vc.card = creatures[indexPath.row]
                case 2: vc.card = spells[indexPath.row]
                default: vc.card = lands[indexPath.row]
                }
                vc.shouldUseResult = false
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card = getCardAtIndexPath(indexPath)
            store.dispatch(RemoveCardFromDeck(card: card))
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let card = getCardAtIndexPath(indexPath)
        store.dispatch(IncrementCardAmount(card: card))
    }
    
    // MARK: - Supporting Functionality
    
    struct Cell {
        static let creatureCell = "Creature"
        static let spellCell = "Spell"
        static let landCell = "Land"
        static let addCard = "Add Card"
    }
    
    func getCardAtIndexPath(_ indexPath: IndexPath) -> Card {
        switch indexPath.section {
        case 1: return creatures[indexPath.row]
        case 2: return spells[indexPath.row]
        default: return lands[indexPath.row]
        }
    }

}
