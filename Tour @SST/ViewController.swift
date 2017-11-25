//
//  ViewController.swift
//  Tour @SST
//
//  Created by Storm Lim on 17/10/16.
//  Copyright © 2016 J.Lim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var width = CGFloat()
    var height = CGFloat()
    var opened = false
    var tour = 0
    var searching = false
    
    var areas = [loc]()
    var filered = [loc]()
    
    var edu = [loc]()
    var phy = [loc]()
    var oth = [loc]()
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dark: UIView!
    @IBOutlet weak var menu: UIView!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var eduBtn: UIButton!
    @IBOutlet weak var phyBtn: UIButton!
    @IBOutlet weak var othBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        height = view.frame.height
        
        setup()
        
        if tour == 0 {
            areas = edu + phy + oth
        } else if tour == 1 {
            areas = edu
        } else if tour == 2 {
            areas = phy
        } else if tour == 3 {
            areas = oth
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        menu.layer.shadowOffset.height = -5
        menu.layer.shadowOpacity = 0.1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismiss(sender:)))
        bg.addGestureRecognizer(tap)
        
        let close = UITapGestureRecognizer(target: self, action: #selector(ViewController.close(sender:)))
        dark.addGestureRecognizer(close)
    }
    
    func setup() {
        edu = [loc(nameII: "Info Hub", locII: "Block A, Level 4", desII: ""),
               loc(nameII: "Lvl 1 Labs", locII: "Block C, Level 1", desII: "Opportunities for independent and joint research experiment about in our Science Lab, which comprises twelve laboratories (four dedicated to the Applied Sciences), as well as tissue culture room, a research lab and an engineering lab."),
               loc(nameII: "Lvl 2 Labs", locII: "Block C, Level 2", desII: "The unique multifunctional NAWIS® system in the Physics laboratories allows for more flexibility and mobility in these spaces. Special research equipment is also available in the laboraties to support student’s explorations in the fields of analytical chemistry, biomedical sciences and sensor technology.")]
        
        phy = [loc(nameII: "Field", locII: "Center Of School, Level 1", desII: ""),
               loc(nameII: "ISH", locII: "Block D, Level 1", desII: "")]
        
        oth = [loc(nameII: "Atrium", locII: "Block A, Level 1", desII: ""),
               loc(nameII: "Weed Garden", locII: "Block B & C, Level 1", desII: ""),
               loc(nameII: "Canteen", locII: "Block C, Level 1", desII: ""),
               loc(nameII: "Giant Staircase", locII: "Block C, Level 3", desII: ""),
               loc(nameII: "iMac Lab", locII: "Block C, Level 3", desII: ""),
               loc(nameII: "INC HQ", locII: "Block C, Level 3", desII: "SST INC Headquarters is a unique space for aspiring entrepreneurs, SST INC is a state-of-the-art business incubator which hosts start-up companies run by our Information and Communication Technology Talent Development Programme (ICT TDP) students. Computers workshops, exhibitions and project discussions are held here on a regular basis, and the venue has been the nerve of centre for project discussions and held here on a regular basis, and the venue has been the nerve centre for project discussions which have yielded notable results.")]
    }
    
    func dismiss(sender: UITapGestureRecognizer) {
        if searching {
            searchBar.resignFirstResponder()
            searching = !(filered.isEmpty && searchBar.text == "")
            search()
        }
    }
    
    func close(sender:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dark.alpha = 0
            self.menu.frame.origin.y = self.height - 50
        }) { (Bool) in
            self.dark.isHidden = self.opened
            self.opened = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searching = true
        collectionView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searching = !(filered.isEmpty && textField.text == "")
        search()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        search()
        searching = !(filered.isEmpty && textField.text == "")
        return true
    }
    
    func search() {
        if !searching {
            collectionView.reloadData()
            return
        }
        
        filered.removeAll()
        for i in 0..<areas.count {
            if areas[i].name.contains(searchBar.text!) {
                filered.append(areas[i])
            }
        }
        collectionView.reloadData()
    }
    
    func openMenu() {
        dark.isHidden = opened
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dark.alpha = 0.75
            self.menu.frame.origin.y = self.height - 200
            }) { (Bool) in
                self.opened = true
        }
    }
    
    func closeMenu(selected: UIButton, rest: [UIButton]) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dark.alpha = 0
            selected.frame.origin.y = 0
            for i in 0..<3 {
                rest[i].frame.origin.y = 50 * (CGFloat(i)+1)
            }
            self.menu.frame.origin.y = self.height - 50
            }) { (Bool) in
                self.dark.isHidden = self.opened
                self.opened = false
        }
        
        if tour == 0 {
            areas = edu + phy + oth
        } else if tour == 1 {
            areas = edu
        } else if tour == 2 {
            areas = phy
        } else if tour == 3 {
            areas = oth
        }
        collectionView.reloadData()
    }
    
    @IBAction func all(_ sender: AnyObject) {
        if !opened {
            openMenu()
        } else {
            tour = 0
            closeMenu(selected: allBtn, rest: [eduBtn, phyBtn, othBtn])
        }
    }
    
    @IBAction func edu(_ sender: AnyObject) {
        if !opened {
            openMenu()
        } else {
            tour = 1
            closeMenu(selected: eduBtn, rest: [allBtn, phyBtn, othBtn])
        }
    }
    
    @IBAction func phy(_ sender: AnyObject) {
        if !opened {
            openMenu()
        } else {
            tour = 2
            closeMenu(selected: phyBtn, rest: [allBtn, eduBtn, othBtn])
        }
    }
    
    @IBAction func oth(_ sender: AnyObject) {
        if !opened {
            openMenu()
        } else {
            tour = 3
            closeMenu(selected: othBtn, rest: [allBtn, eduBtn, phyBtn])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width - 75, height: width - 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return filered.count
        }
        
        return areas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let row = indexPath.row
        
        var name = String()
        
        if searching {
            name = filered[row].name
        } else {
            name = areas[row].name
        }
        
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowOpacity = 0.5
        cell.clipsToBounds = false
        
        let imgWidth = UIImage(named: name)?.size.width
        let imgHeight = UIImage(named: name)?.size.height
        
        let image = UIImage(named: name)!
        let crop = CGRect(x: ((width - 75) - imgWidth!)/2, y: 0, width: imgWidth!, height: imgHeight!)
        let imageRef: CGImage = image.cgImage!.cropping(to: crop)!
        cell.image.image = UIImage(cgImage: imageRef)
        
        cell.locName.text = name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let destinationVC = segue.destination as! DetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! CollectionViewCell) {
                let row = indexPath.row
                var data = areas[row]
                if searching {
                    data = filered[row]
                }
                destinationVC.name = data.name
                destinationVC.loc = data.loc
                destinationVC.des = data.des
            }
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {
        
    }

}
