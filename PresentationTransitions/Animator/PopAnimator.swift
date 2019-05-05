//
//  PopAnimator.swift
//  PresentationTransitions
//
//  Created by Timur Saidov on 05/05/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    // MARK: Public Properties
    
    var presenting = true
    var originFrame = CGRect.zero // the default value of originFrame has the origin at (0, 0) -> that's your animation starts from the top-left corner.
    var dismissCompletion: (()->Void)?
    
    
    // MARK: Private Properties
    
    private let duration = 10.0
    
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        let toView = transitionContext.view(forKey: .to)!
//
//        containerView.addSubview(toView)
//
//        toView.alpha = 0.0
//        UIView.animate(withDuration: duration,
//                       animations: {
//                        toView.alpha = 1.0
//        },
//                       completion: { _ in
//                        transitionContext.completeTransition(true)
//        }
//        )
        
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let herbView = presenting ? toView : transitionContext.view(forKey: .from)! // For both presenting and dismissing, herbView will always be the view that you animate.
//        print(herbView)
        
        // When you present the details controller view, it will grow to take up the entire screen. When dismissed, it will shrink to the image’s original frame.
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(herbView) // You need to make sure the herbView is on top since that’s the only view you’re animating. Remember that when dismissing, toView is the original view so in the first line, you’ll be adding it on top of everything else, and your animation will be hidden away unless you bring herbView to the front.
        // When presenting: toView - "to" view (HerbDetails), herbView - "to" view (HerbDetails).
        // When dismissing: to view = "to" view (ViewController), herbView = "from" view (HerbDetails).
//        print(toView)
//        print(herbView)
        
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
                       animations: {
                        herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        },
                       completion: { _ in
                        if !self.presenting {
                            self.dismissCompletion?()
                        }
                        transitionContext.completeTransition(true)
        }
        )
    }
}
