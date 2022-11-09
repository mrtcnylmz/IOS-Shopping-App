//
//  OnboardingViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 8.11.2022.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pageControlBar: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControlBar.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started!", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 10
        
        self.collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "onboardingCollectionViewCell")
        
        let firstSlide = OnboardingSlide(title: "HI!", description: "Here you can start by registering or if you already have an account sign in.", image: UIImage(named: "e10")!)
        let secondSlide = OnboardingSlide(title: "Main Market Page", description: "Here you can browse our shops main product page. ", image: UIImage(named: "e12")!)
        let thirdSlide = OnboardingSlide(title: "Profile Page", description: "You may check your profile here.", image: UIImage(named: "e7")!)
        let fourtSlide = OnboardingSlide(title: "Basket", description: "And finally your basket page with all your desired products.", image: UIImage(named: "e8")!)
        slides = [firstSlide,
                  secondSlide,
                  thirdSlide,
                  fourtSlide]
    }
    
    //MARK: - NextButtonAction
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if currentPage == slides.count - 1{
            self.dismiss(animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

//MARK: Extension
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - NumberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    //MARK: - CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell else {return UICollectionViewCell()}
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    //MARK: - SizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    //MARK: - ScrollViewDidEndDecelerating
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
