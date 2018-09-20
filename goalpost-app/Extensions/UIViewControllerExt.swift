//
//  UIViewControllerExt.swift
//  goalpost-app
//
//  Created by James Ullom on 9/19/18.
//  Copyright © 2018 Hammer of the Gods Software. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ vcToPresent: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        // Use 'false' for animation as we do not want the default animation style
        present(vcToPresent, animated: false, completion: nil)

    }
    
    // This function dismisses the current VC and then loads a new (secondary) VC into view
    // Created to solve opening GoalsVC->CreateGoalsVC->FinsihGoalVC and wanting to bounce back to the GoalsVC when done in FinishGoalVC.
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController) {
    
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight

        guard let presentedVC = presentedViewController else { return }
        presentedVC.dismiss(animated: false, completion: {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        })
    }
    
    func dismissDetail() {

        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)

    }
    
}
