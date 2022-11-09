//
//  OnboardingCollectionViewCell.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 8.11.2022.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    //MARK: - Setup
    func setup(_ slide: OnboardingSlide) {
        imageView.image = slide.image
        titleLabel.text = slide.title
        bodyLabel.text = slide.description
    }
}
