//
//  ViewController.swift
//  PresentationTransitions
//
//  Created by Timur Saidov on 04/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: Private Properties
    
    private let herbs = HerbModel.all()
    private var selectedImage: UIImageView?
    private let transition = PopAnimator()

    
    // MARK: Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var listView: UIScrollView!
    
    
    // MARK: Overriding
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transition.dismissCompletion = {
            self.selectedImage!.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if listView.subviews.count < herbs.count {
            listView.viewWithTag(0)?.tag = 1000 // Prevent confusion when looking up images.
            setupList()
        }
    }

    
    // MARK: Private
    
    private func setupList() {
        for i in herbs.indices {
            // Сreate image view.
            let imageView = UIImageView(image: UIImage(named: herbs[i].image))
            imageView.tag = i
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 20.0
            imageView.layer.masksToBounds = true
            listView.addSubview(imageView)
            // Attach tap detector.
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        }
        
        listView.backgroundColor = UIColor.clear
        positionListItems()
    }
    
    private func positionListItems() {
        let listHeight = listView.frame.height
        let itemHeight: CGFloat = listHeight * 1.33
        let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let itemWidth: CGFloat = itemHeight / aspectRatio
        
        let horizontalPadding: CGFloat = 10.0
        
        listView.contentSize = CGSize(width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding, height: 0)
        
        for i in herbs.indices {
            let imageView = listView.viewWithTag(i) as! UIImageView
            imageView.frame = CGRect(x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding, y: 0.0, width: itemWidth, height: itemHeight)
        }
    }
    
    
    // MARK: Actions
    
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        selectedImage = tap.view as? UIImageView
        
        let index = tap.view!.tag
        let selectedHerb = herbs[index]
        
        // Present details view controller.
        let herbDetails = storyboard!.instantiateViewController(withIdentifier: "HerbDetailsViewController") as! HerbDetailsViewController
        herbDetails.herb = selectedHerb
        herbDetails.transitioningDelegate = self
        present(herbDetails, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // This sets the originFrame of the transition to the frame of selectedImage, which is the image view you last tapped. Then you set presenting to true and hide the tapped image during the animation.
        transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
        transition.presenting = true
        selectedImage!.isHidden = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
