//
//  CardTableViewCell.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/7/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    private var imageConfigured = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageLabel.text = "Loading image..."
    }

    func downloadImage(from urlOptionalString: String?) {
        if let urlString = urlOptionalString {
            let url = URL(string: urlString)!
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.cardImageView.image = UIImage(data: data)
                        self.imageLabel.isHidden = true
                        self.configureFrame()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.cardImageView.isHidden = true
                        self.imageLabel.text = "Loading failed"
                    }
                }
            }
        } else {
            cardImageView.isHidden = true
            imageLabel.text = "No image"
        }
    }
    
    func configureFrame() {
        guard imageConfigured == false else { return }
        
        imageConfigured = true
        cardImageView.clipsToBounds = true
        cardImageView.contentMode = .scaleAspectFill
        cardImageView.layer.cornerRadius = cardImageView.frame.size.height / 5
        cardImageView.layer.contentsRect = cardImageView.layer.contentsRect.offsetBy(dx: 0, dy: -0.21).insetBy(dx: 0.12, dy: 0.1)
    }

}
