//
//  NameTableViewCell.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/2/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {

    @IBOutlet weak var cardName: UITextField!
    
    func configure() {
        cardName.placeholder = "Card Name"
        cardName.autocorrectionType = .no
        cardName.autocapitalizationType = .sentences
    }

}
