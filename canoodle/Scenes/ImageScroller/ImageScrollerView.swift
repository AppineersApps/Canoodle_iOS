//  
//  ImageScrollerView.swift
//  HIMG
//
//  Copyright © 2018 hb. All rights reserved.


import UIKit

class ImageScrollerView: BaseViewController {

    // OUTLETS HERE
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var clnView: UICollectionView!
    @IBOutlet weak var btnUnsave: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var images : [String]!
    var filteredImages : [String] = []
    var aIndex = 0
    
    var currIndex = 0
    deinit {

    }

    class func instance() -> ImageScrollerView? {
        return UIStoryboard(name: "ImageScrollerView", bundle: nil).instantiateViewController(withIdentifier: "ImageScrollerView") as? ImageScrollerView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // filterImages()
        clnView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let aIndPath = IndexPath(item: self.aIndex, section: 0)
            self.clnView.scrollToItem(at: aIndPath, at: .left, animated: false)
        }
    }
    
    func filterImages() {
        images.forEach() { image in
            if(image.contains("png") || image.contains("jpg")) {
                filteredImages.append(image)
            }
            
        }
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clnView.reloadData()
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension ImageScrollerView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageScrollerCell
        aCell.imgViewBanner.setImage(with: filteredImages[indexPath.row],placeHolder: #imageLiteral(resourceName: "800x800_no-_image"))
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currIndex = indexPath.row
    }
    
}


class ImageScrollerCell : UICollectionViewCell,UIScrollViewDelegate {
    
    @IBOutlet weak var imgViewBanner: UIImageView!
    @IBOutlet weak var scrView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let aTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTapScrollView(recognizer:)))
        imgViewBanner.addGestureRecognizer(aTapGesture)
        aTapGesture.numberOfTapsRequired = 2
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgViewBanner
    }
    
   
    @IBAction func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrView.zoomScale == 1 {
            scrView.zoom(to: zoomRectForScale(scale: scrView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrView.setZoomScale(1, animated: true)
        }
    }
    
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgViewBanner.frame.size.height / scale
        zoomRect.size.width  = imgViewBanner.frame.size.width  / scale
        let newCenter = imgViewBanner.convert(center, from: scrView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

