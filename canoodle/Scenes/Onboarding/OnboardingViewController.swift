//
//  OnboardingViewController.swift
//  GetGoodIce
//
//  Created by Appineers India on 16/04/20.
//  Copyright © 2020 TheAppineers. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
   // @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    var titlesArray = ["Title 1", "Title 2", "Title 3"]
    var descriptionArray = ["Create your profile with your pet.", "Find people with love for pets near you.", "View who likes your profile with our Premium Membership.", "Match and Meet."]

    var currPageIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
       // imageView.layer.cornerRadius = 12
       // imageView.setCornerRadiusAndShadow(cornerRe: 12)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
            
        if (sender.direction == .left) {
                print("Swipe Left")
            if(currPageIndex < titlesArray.count - 1) {
                currPageIndex += 1
                titleLabel.text = titlesArray[currPageIndex]
                descLabel.text = descriptionArray[currPageIndex]
             //   imageView.image = UIImage.init(named: "onboarding\(currPageIndex+1)")
            }
        }
            
        if (sender.direction == .right) {
            print("Swipe Right")
            if(currPageIndex > 0) {
                currPageIndex -= 1
                titleLabel.text = titlesArray[currPageIndex]
                descLabel.text = descriptionArray[currPageIndex]
               // imageView.image = UIImage.init(named: "onboarding\(currPageIndex+1)")
            }
        }
        pageControl.currentPage = currPageIndex
        if(currPageIndex == titlesArray.count-1) {
            startButton.isHidden = false
        }
        else {
            startButton.isHidden = true
        }
    }
    
    /// Instance
    ///
    /// - Returns: SignUpViewController
    class func instance() -> OnboardingViewController? {
        return StoryBoard.Onboarding.board.instantiateViewController(withIdentifier: AppClass.OnboardingVC.rawValue) as? OnboardingViewController
    }

    
    @IBAction func doneButtonTapped(_ sender: Any) {
        UserDefaultsManager.onboardingDone = "Yes"
        GlobalUtility.redirectToLogin()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
