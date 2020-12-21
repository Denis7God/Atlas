//
//  CountryTableViewCell.swift
//  Atlas
//
//  Created by Denis Godovaniuk on 09.12.2020.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    var country: Country? {
        didSet {
            self.configure()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nativeNameLabel: UILabel!
    @IBOutlet weak var flagEmojiLabel: UILabel!
    
    private func configure() {
        nameLabel.text = country?.name
        nativeNameLabel.text = country?.nativeName
        flagEmojiLabel.text = country?.flagEmoji
    }
}
