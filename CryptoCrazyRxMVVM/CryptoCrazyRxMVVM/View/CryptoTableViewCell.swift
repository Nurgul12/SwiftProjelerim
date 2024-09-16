//
//  CryptoTableViewCell.swift
//  CryptoCrazyRxMVVM
//
//  Created by Nurgül Ergünöz on 1.05.2024.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public var item: Crypto! {
              didSet {
                  self.nameLabel.text = item.currency
                  self.priceLabel.text = item.price

              }
          }

}
