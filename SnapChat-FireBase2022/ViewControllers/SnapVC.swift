//
//  SnapVC.swift
//  SnapChat-FireBase2022
//
//  Created by Murat Sağlam on 16.02.2022.
//

import UIKit
import ImageSlideshow
import Kingfisher

class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Time Fonk.
        
        
        
        //Image Slide Wep Cod. -> Resime tıklandığında farklı bir sayfaya yönlendirme
        if let snap = selectedSnap
        {
            
            timeLabel.text = "Time Left : \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray
            {
                
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
                
                
            }
            //Code to make Snap Image appear larger on screen when clicked
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
        
        
    }
    

}
