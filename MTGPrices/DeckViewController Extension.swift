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
        switch indexPath.section {
        case 0:
            // Add Card
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.addCard, for: indexPath)
            cell.textLabel?.text = "Add Card"
            return cell
        case 1:
            // Creature
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.creatureCell, for: indexPath) as! CardTableViewCell
            let creature = creatures[indexPath.row]
            cell.amountLabel.text = "\(creature.amount)"
            cell.title.text = creature.name
            cell.subtitle.text = creature.type
            cell.downloadImage(from: creature.imageUrl)
            print("calling configureCost from cellForRow")
            cell.configureCost(from: creature.manaCost!.createCmcImages())
            return cell
        case 2:
            // Spell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.spellCell, for: indexPath)  as! CardTableViewCell
            let spell = spells[indexPath.row]
            cell.title.text = "\(spell.amount) \(spell.name)"
            cell.subtitle.text = "\(spell.type), Cost: \(spell.cmc), Colors: \(spell.colors!)"
            cell.downloadImage(from: spell.imageUrl)
            return cell
        default:
            // Land
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.landCell, for: indexPath) as! CardTableViewCell
            let land = lands[indexPath.row]
            cell.title.text = "\(land.amount) \(land.name)"
            cell.subtitle.text = "\(land.type)"
            cell.downloadImage(from: land.imageUrl)
            return cell
        }
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
