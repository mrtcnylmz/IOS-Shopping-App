//
//  SearchCollectionViewCell.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 6.11.2022.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
