//
//  AdvancedSearchTableViewController Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/2/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import UIKit

extension AdvancedSearchTableViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cardName = textField.text
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // Name
        case 1: return 2 // Color
        case 2: return 2 // Rarity
        case 3: return 3 // Type
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, _): // Name Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.nameCell, for: indexPath) as! NameTableViewCell
            cell.cardName.delegate = self
            cell.cardName.text = cardName
            cell.configure()
            return cell
        case (1, 0): // Color Selection Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.colorSelectionCell, for: indexPath) as! ColorSelectionTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.colorSelection, selector: #selector(colorSelectionButtonSelected))
            return cell
        case (1, 1): // Color Constraints Cell 
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.colorConstraintCell, for: indexPath) as! ColorConstraintsTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.colorConstraint, selector: #selector(colorConstraintsButtonSelected))
            return cell
        case (2, 0): // First Rarity Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.firstRarityCell, for: indexPath) as! FirstRarityTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.raritySelection, selector: #selector(rarityButtonSelected))
            return cell
        case (2, 1): // Second Rarity Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.secondRarityCell, for: indexPath) as! SecondRarityTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.raritySelection, selector: #selector(rarityButtonSelected))
            return cell
        case (3, 0): // First Type Selection Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.firstTypeSelectionCell, for: indexPath) as! FirstTypeSelectionTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.typeSelection, selector: #selector(typeSelectionButtonSelected))
            return cell
        case (3, 1): // Second Type Selection Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.secondTypeSelectionCell, for: indexPath) as! SecondTypeSelectionTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.typeSelection, selector: #selector(typeSelectionButtonSelected))
            return cell
        default:
//        case (3, 2): // Third Type Selection Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.thirdTypeSelectionCell, for: indexPath) as! ThirdTypeSelectionTableViewCell
            configureButtons(cell.buttons, tag: ButtonTags.typeSelection, selector: #selector(typeSelectionButtonSelected))
            return cell
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Name"
        case 1: return "Colors"
        case 2: return "Rarity"
        case 3: return "Type"
        default: return nil
        }
    }
    
    
    // MARK: - Supporting Functionality
    
    func configureButtons(_ buttons: [UIButton], tag: Int, selector: Selector) {
        for button in buttons {
            button.tag = tag
            button.addTarget(self, action: selector, for: .touchUpInside)
        }
    }
    
    struct Cell {
        static let nameCell = "Name Cell"
        static let colorSelectionCell = "Color Selection Cell"
        static let colorConstraintCell = "Color Constraint Cell"
        static let firstRarityCell = "First Rarity Cell"
        static let secondRarityCell = "Second Rarity Cell"
        static let firstTypeSelectionCell = "First Type Selection Cell"
        static let secondTypeSelectionCell = "Second Type Selection Cell"
        static let thirdTypeSelectionCell = "Third Type Selection Cell"
        static let typeConstraintCell = "Type Constraint Cell"
    }
    
}
