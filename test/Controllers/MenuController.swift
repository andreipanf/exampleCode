//
//  MenuController.swift
//  OishiSushi
//
//  Created by Andrey on 05.07.16.
//  Base on Tof Templates
//  Copyright © 2016 AndreyPanfilov. All rights reserved.
//

import UIKit
import Haneke
import PKHUD

class MenuControllerCell : UICollectionViewCell {
    
    var date:MenuItem?{
        didSet {
            self.setupCell()
        }
    }
    
    func setupCell() {
        
        self.layer.borderColor =  UIColor(red:0.996,  green:0.976,  blue:0.929, alpha:1).CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
        if let menuItem = date {
            self.menuTitle.text = menuItem.title
            self.menuPrice.text = "\(menuItem.priceString) р."
            if let urlString = menuItem.imageUrl {
                if let url = NSURL(string: urlString) {
                    self.menuImage.hnk_setImageFromURL(url)
                }
            }
            
        }
    
    }
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuPrice: UILabel!
    @IBOutlet weak var menuTitle: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.menuImage.image = nil
    }
}

class MenuController: UIViewController {
  
    // MARK: Properties
    var arrayOfMenuItems:Array<MenuItem>?
    
    // MARK: Outlets
    
    @IBOutlet weak var scrollPagerHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Actions

    func addButtonPressed(sender: UIButton){
        
        let menuItem = arrayOfMenuItems![sender.tag]
        let alert = UIAlertController(title: "Placeholder", message: "После нажатия этой кнопки итем \(menuItem.title) добавляется в корзину", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        showViewController(alert, sender: self);
        
        //OrderHelper.sharedInstance.addItem(menuItem)
        
        //let badgeInt:Int = OrderHelper.sharedInstance.getCountItems()
        //tabBarController?.tabBar.items?[2].badgeValue = "\(badgeInt)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataWithSlug("rolls")
    }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    
    }
    
    func loadDataWithSlug(slug:String) {
        arrayOfMenuItems = []
        
        HUD.show(.Progress)
        NetworkHelper().getMenuFromServer(slug) { (success: Bool, menuArray:Array<MenuItem>?) in
            
            HUD.hide()
            
            if success == true {
                self.arrayOfMenuItems = menuArray
                self.collectionView.reloadData()
            }else{
                let alert = UIAlertController(title: "Placeholder", message: "Что-то пошло не так, скорей всего не правильные api ключи в файле NetworkHelper", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                
                self.showViewController(alert, sender: self);
                
            }
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMenuItems!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuControllerCell", forIndexPath: indexPath) as! MenuControllerCell
    
        let menuItem = arrayOfMenuItems![indexPath.row]
        cell.date = menuItem
        
        cell.addButton.addTarget(self, action: #selector(MenuController.addButtonPressed(_:)), forControlEvents: .TouchUpInside)
        cell.addButton.tag = indexPath.row
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var width = UIScreen.mainScreen().bounds.size.width
        width = width / 2 - 15;
        var height = UIScreen.mainScreen().bounds.size.height
        height = height / 4.4
        
        return CGSizeMake(width, height)
    }
    
    
}
