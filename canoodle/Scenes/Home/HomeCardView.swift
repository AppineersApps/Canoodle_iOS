//
//  HomeCardView.swift
//  MadCollab
//
//  Created by Appineers India on 28/04/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

protocol HomeCardViewProtocol: AnyObject {
    func swipedCard(user: User.ViewModel, type: SwipeType)
}

enum SwipeType : String {
    /// - Type: Left
    case Left
    /// - Type: Right
    case Right
}


class HomeCardView: UIView {
    @IBOutlet weak var mediaHolderView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var watermarkView: UIView!
    
    public weak var delegate: HomeCardViewProtocol?


    var currPageIndex:Int = 0
    
    var breedArray = ["Cocker Spaniel", "Great Dane", "Pomeranian", "Saint Bernard", "Labrador", "German Shepherd", "Doberman", "Boxer", "Bull Terrier", "Greyhound", "Great Dane", "Wolfhound", "Poodle", "Siberian Husky", "Cocker Spaniel", "Great Dane", "Pomeranian", "Saint Bernard", "Labrador", "Cocker Spaniel", "Great Dane", "Pomeranian", "Saint Bernard", "Labrador", "German Shepherd", "Doberman", "Boxer", "Bull Terrier", "Greyhound", "Great Dane", "Wolfhound", "Poodle", "Siberian Husky", "Cocker Spaniel", "Great Dane", "Pomeranian", "Saint Bernard", "Labrador", "Cocker Spaniel", "Great Dane", "Pomeranian", "Saint Bernard", "Labrador", "German Shepherd", "Doberman", "Boxer", "Bull Terrier", "Greyhound", "Great Dane", "Wolfhound", "Poodle", "Siberian Husky", "Cocker Spaniel", "Great Dane", "Pomeranian", "Saint Bernard", "Labrador"]

    var mediaViews: [UIView] = []
    
    var user: User.ViewModel!
    var medias: [Media.ViewModel] = []
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.setCornerRadiusAndShadow(cornerRe: 16)
    }
    
    func loadMedia() {
        mediaViews.removeAll()
        var count = 5
        for n in 0...count - 1 {
            let mediaView: UIView = UIView.init(frame: CGRect(x: 0, y: 0 , width: mediaHolderView.frame.size.width, height: mediaHolderView.frame.size.height))
            mediaHolderView.addSubview(mediaView)
            mediaView.isHidden = true
            mediaViews.append(mediaView)
        }
    }
    
    func initCard(index: Int, user: User.ViewModel) {
        self.user = user
        self.setCornerRadiusAndShadow(cornerRe: 16)
        nameLabel.text = "\(user.userName!), \(user.age!) years"
        locationLabel.text = "\(user.city!), \(user.state!)"
        if(user.breed != "" && user.petAge != "") {
            petNameLabel.text = "\(user.breed!), \(user.petAge!) years"
        } else if(user.breed != "") {
            petNameLabel.text = "\(user.breed!)"
        } else  {
            petNameLabel.text = "--"
        }
        
        filterMedia()
        if(medias.count == 0) {
            watermarkView.isHidden = false
        }
        //bgImageView.image = UIImage.init(named: "homecard\(index + 1)")
        let frame: CGRect = pageControl.frame
        let topCenter: CGPoint = CGPoint(x: frame.midX, y: frame.minY)
        pageControl.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        pageControl.layer.position = topCenter
        let angle = CGFloat.pi/2
        pageControl.transform = CGAffineTransform(rotationAngle: angle)
        pageControl.numberOfPages = medias.count
        pageControl.frame = CGRect(x: self.frame.width - 20, y: CGFloat(10 + (pageControl.numberOfPages * 10)), width: pageControl.frame.width, height: pageControl.frame.height)
        //loadMedia()
        
         let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
         let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
         let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
         let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
             
         upSwipe.direction = .up
         downSwipe.direction = .down
         leftSwipe.direction = .left
         rightSwipe.direction = .right

         self.addGestureRecognizer(upSwipe)
         self.addGestureRecognizer(downSwipe)
         self.addGestureRecognizer(leftSwipe)
         self.addGestureRecognizer(rightSwipe)

        displayMedia(tag: 0)
    }
    
    func filterMedia() {
        medias.removeAll()
        self.user.media?.forEach() { media in
            if(media.mediaType == "image/png") {
                medias.append(media)
            }
            
        }
    }
    
    func displayMedia(tag: Int) {
        var index: Int = 0
        var count = 5
        mediaViews.forEach {
            let mediaView: UIView = $0
            if(index == currPageIndex) {
                mediaView.isHidden = false
            }
            else {
                mediaView.isHidden = true
            }
            index += 1
        }
        if( medias.count > 0 && (currPageIndex < medias.count)) {
            let media: Media.ViewModel = medias[currPageIndex]
            bgImageView.setImage(with: "\(media.mediaImages!)", placeHolder: UIImage.init(named: "placeholder"))
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {

            var count = 5
        if (sender.direction == .up) {
            if(count == 0) {
                return
            }
                print("Swipe up")
            if(currPageIndex < count - 1) {
                currPageIndex += 1
                displayMedia(tag: 0)
            }
        }
            
        if (sender.direction == .down) {
            print("Swipe down")
            if(currPageIndex > 0) {
                currPageIndex -= 1
                displayMedia(tag: 0)
            }
        }
        
        if (sender.direction == .left) {
            print("Swipe left")
            swipedLeft()
        }
        
        if (sender.direction == .right) {
                print("Swipe right")
                swipedRight()
        }
        pageControl.currentPage = currPageIndex
    }
    
    func swipedLeft() {
        showUnLikeAnimation()
        self.alpha = 0.9
        let angle: CGFloat = -0.1
        self.transform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        self.alpha = 0.1
                        self.frame = CGRect(x: -self.frame.size.width, y: 120, width: self.frame.size.width, height: self.frame.size.height)
        },
         completion: { _ in
            self.removeFromSuperview()
            self.delegate?.swipedCard(user: self.user, type: SwipeType.Left)
        })
    }
    
    func swipedRight() {
        showLikeAnimation()
        self.alpha = 0.9
        let angle: CGFloat = 0.1
        self.transform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        self.alpha = 0.1
                        self.frame = CGRect(x: self.frame.size.width, y: 120, width: self.frame.size.width, height: self.frame.size.height)
        },
         completion: { _ in
            self.removeFromSuperview()
            self.delegate?.swipedCard(user: self.user, type: SwipeType.Right)
        })
    }
    
    func showLikeAnimation() {
        let imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "like"))
        imageView.frame = CGRect.init(x: self.frame.width/2 - 60, y: self.frame.height/2 - 60, width: 120, height:  120)
        self.addSubview(imageView)
    }
    
    func showUnLikeAnimation() {
        let imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "unlike"))
        imageView.frame = CGRect.init(x: self.frame.width/2 - 60, y: self.frame.height/2 - 60, width: 120, height:  120)
        self.addSubview(imageView)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        self.alpha = 0.1
        },
         completion: { _ in
            self.removeFromSuperview()
        })
    }
}
