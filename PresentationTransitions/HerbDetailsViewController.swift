//
//  HerbDetailsViewController.swift
//  PresentationTransitions
//
//  Created by Timur Saidov on 04/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class HerbDetailsViewController: UIViewController {
    
    
    // MARK: Public Properties
    
    var herb: HerbModel!
    
    
    // MARK: Outlets

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    
    // MARK: Overriding
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bgImage.image = UIImage(named: herb.image)
        titleView.text = herb.name
        descriptionView.text = herb.description
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
    }
    
    
    // MARK: Actions
    
    @objc func actionClose(_ tap: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
