//
//  DetailViewController.swift
//  Tour @SST
//
//  Created by Storm Lim on 24/10/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var opened = false
    
    var defaults = UserDefaults.standard
    var first: NSNumber!

    var width = CGFloat()
    var height = CGFloat()
    
    var imgWidth = CGFloat()
    var imgHeight = CGFloat()
    
    @IBOutlet weak var nav: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var desTxt: UITextView!
    @IBOutlet weak var darken: UIView!
    @IBOutlet weak var expandBtn: UIButton!
    
    var name = String()
    var loc = String()
    var des = String()
    
    var x = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        height = view.frame.height
        
        imgWidth = (UIImage(named: name)?.size.width)!
        imgHeight = (UIImage(named: name)?.size.height)!
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentOffset.x = width
        collectionView.layer.shadowOffset.height = 7.5
        collectionView.layer.shadowOpacity = 0.25
        collectionView.clipsToBounds = false
        
        nameLbl.text = name
        locLbl.text = loc
        if des == "" {
            desTxt.text = "No Description"
        } else {
            desTxt.text = des
        }
        
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.swipe(sender:)))
        swipe.direction = .up
        collectionView.addGestureRecognizer(swipe)
        
        let close = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.close(sender:)))
        close.direction = .down
        darken.addGestureRecognizer(close)
        
        let unwind = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.unwind(sender:)))
        unwind.direction = .down
        collectionView.addGestureRecognizer(unwind)
    }
    
    @IBAction func moreDet(_ sender: AnyObject) {
        openDetail()
    }
    
    func swipe(sender: UISwipeGestureRecognizer) {
        openDetail()
    }
    
    func close(sender: UISwipeGestureRecognizer) {
        openDetail()
    }
    
    func unwind(sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "exit", sender: self)
    }
    
    func openDetail() {
        if opened {
            UIView.animate(withDuration: 0.5, animations: {
                self.darken.alpha = 0
                self.desTxt.frame.origin.y = self.height
                self.locLbl.frame.origin.y = self.height - 25 - 32.5
                self.nameLbl.frame.origin.y = self.height - 25 - 32.5 - 73.5
                self.expandBtn.transform = CGAffineTransform(rotationAngle: 0)
            }) { (Bool) in
                self.opened = false
                self.darken.isHidden = true
            }
        } else {
            darken.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.darken.alpha = 0.75
                self.desTxt.frame.origin.y = self.height - 73 - 200
                self.locLbl.frame.origin.y = self.height - 73 - 200 - 25 - 32.5
                self.nameLbl.frame.origin.y = self.height - 73 - 200 - 25 - 32.5 - 73.5
                self.expandBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.nav.alpha = 0
            }) { (Bool) in
                self.opened = true
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == (height/imgHeight) * imgWidth * 3 - width{
            scrollView.contentOffset.x = (height/imgHeight) * imgWidth - width
        } else if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = (height/imgHeight) * imgWidth * 2
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.25, animations: {
            self.nav.alpha = 0
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == (height/imgHeight) * imgWidth * 3 - width{
            scrollView.contentOffset.x = (height/imgHeight) * imgWidth - width
        } else if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = (height/imgHeight) * imgWidth * 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (height/imgHeight) * imgWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailCollectionViewCell
        
        cell.image.frame = CGRect(x: 0, y: 0, width: (height/imgHeight) * imgWidth, height: height)
        cell.image.image = UIImage(named: name)
        
        return cell
    }

}
