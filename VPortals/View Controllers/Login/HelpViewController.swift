//
//  HelpViewController.swift
//  VPortals
//
//  Created by Nadeem Khan on 08/01/21.
//

import UIKit

class HelpViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imgScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var arrImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrImages.removeAll()
        
        arrImages.append(UIImage(named:"help_one.png")!)
        arrImages.append(UIImage(named:"help_two.png")!)
        pageControl.transform = CGAffineTransform(scaleX:1.2, y:1.2);
        loadScrollView()
    }
    
    func loadScrollView() {
            let pageCount = arrImages.count
            imgScrollView.frame = view.bounds
            imgScrollView.delegate = self
            imgScrollView.backgroundColor = UIColor.clear
            imgScrollView.isPagingEnabled = true
            imgScrollView.showsHorizontalScrollIndicator = false
            imgScrollView.showsVerticalScrollIndicator = false
            //pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
            pageControl.numberOfPages = pageCount
            pageControl.currentPage = 0
            //pageControl.transform = CGAffineTransform(scaleX: 2, y: 2);
            for i in (0..<pageCount) {
                let imageView = UIImageView()
                imageView.frame = CGRect(x: i * Int(self.view.frame.size.width) , y: 0 , width:
                    Int(self.view.frame.size.width) , height: Int(self.view.frame.size.height/1.3))
                imageView.contentMode = .scaleAspectFit
                imageView.image = arrImages[i]
    //            imageView.backgroundColor = UIColor.white
                self.imgScrollView.addSubview(imageView)
            }
            
            let width1 = (Float(arrImages.count) * Float(self.view.frame.size.width))
            imgScrollView.contentSize = CGSize(width: CGFloat(width1), height: self.view.frame.size.height)
            self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
                    
        }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imgScrollView.contentOffset.y = 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
//        print(pageNumber)
//        if  pageControl.currentPage == arrImages.count - 1{
//            print("1")
//        }
//        else{
//            print("2")
//        }


    }
    
    @objc func pageChanged(sender:AnyObject)
    {
        let xVal = CGFloat(pageControl.currentPage) * imgScrollView.frame.size.width
        imgScrollView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
        
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
