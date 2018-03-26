//
//  HomeViewController.swift
//  NUSLib
//
//  Created by wongkf on 14/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import Neon
import ZFRippleButton
import RxSwift
import RxCocoa
import RxGesture
import SideMenu
import Kingfisher

class HomeViewController: BaseViewController, UIScrollViewDelegate {
    
    // UI are initialized by closure for compactness.
    // This technique simplify the method in viewDidLoad(), as well as eliminating Optionals.
    
    // IMPORTANT: remember to put unowned self to avoid retaining strong cycles if self is referenced in closure!
    lazy var scrollView: UIScrollView = { [unowned self] in
        let this = UIScrollView(frame: view.bounds)
        return this
    }()
    
    lazy var popularTitle: UILabel = {
        let this = UILabel()
        this.textColor = UIColor.primary
        this.text = "POPULAR"
        this.textAlignment = .left
        this.font = UIFont.primary
        return this
    }()
    
    lazy var popularSeparator: Separator = { [unowned self] in
        let this = Separator(width: view.bounds.width)
        return this
    }()
    
    lazy var popularSubtitle: UILabel = {
        let this = UILabel()
        this.textColor = UIColor.gray
        this.text = "WHAT EVERYONE'S READING"
        this.textAlignment = .left
        this.font = UIFont.subtitle
        return this
    }()
    
    lazy var popularCollection: HorizontalCollectionView<ThumbnailCell> = {
        let this = HorizontalCollectionView<ThumbnailCell>(frame: CGRect.zero,
                                                           cellCount: 10,
                                                           cellSize: CGSize(width: 320, height: 240),
                                                           cellSpacing: 20,
                                                           sectionPadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        this.isPagingEnabled = true
        return this
    }()
    
    lazy var recommendTitle: UILabel = {
        let this = UILabel()
        this.textColor = UIColor.primary
        this.text = "RECOMMEND"
        this.textAlignment = .left
        this.font = UIFont.primary
        return this
    }()
    
    lazy var recommendSeparator: Separator = { [unowned self] in
        let this = Separator(width: view.bounds.width)
        return this
    }()
    
    lazy var recommendSubtitle: UILabel = {
        let this = UILabel()
        this.textColor = UIColor.gray
        this.text = "JUST FOR YOU"
        this.textAlignment = .left
        this.font = UIFont.subtitle
        return this
    }()
    
    lazy var recommendCollectionLeft: VerticalCollectionView<ThumbnailCell> = { [unowned self] in
        let this = VerticalCollectionView<ThumbnailCell>(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: view.bounds.width/2, height: view.bounds.height)),
                                                         cellCount: 5,
                                                         cellHeight: 600,
                                                         cellSpacing: 20,
                                                         columnPadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10))
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        this.isScrollEnabled = false
        return this
    }()
    
    lazy var recommendCollectionRight: VerticalCollectionView<ThumbnailCell> = { [unowned self] in
        let this = VerticalCollectionView<ThumbnailCell>(frame: CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: view.bounds.width/2, height: view.bounds.height)),
                                                          cellCount: 5,
                                                          cellHeight: 600,
                                                          cellSpacing: 20,
                                                          columnPadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10))
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        this.isScrollEnabled = false
        return this
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        scrollView.addSubview(popularTitle)
        scrollView.addSubview(popularSeparator)
        scrollView.addSubview(popularSubtitle)
        scrollView.addSubview(popularCollection)
        scrollView.addSubview(recommendTitle)
        scrollView.addSubview(recommendSeparator)
        scrollView.addSubview(recommendSubtitle)
        scrollView.addSubview(recommendCollectionLeft)
        scrollView.addSubview(recommendCollectionRight)
        
        view.addSubview(scrollView)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // initial layout
        scrollView.fillSuperview()
        
        popularTitle.anchorAndFillEdge(.top, xPad: 20, yPad: 0, otherSize: 70)
        popularSeparator.alignAndFillWidth(align: .underCentered, relativeTo: popularTitle, padding: 0, height: 0.5)
        popularSubtitle.alignAndFillWidth(align: .underCentered, relativeTo: popularSeparator, padding: 0, height: 40)
        popularCollection.alignAndFillWidth(align: .underCentered, relativeTo: popularSubtitle, padding: 0, height: 280, offset: 0)
        recommendTitle.alignAndFillWidth(align: .underCentered, relativeTo: popularCollection, padding: 0, height: 70, offset: 0)
        recommendSeparator.alignAndFillWidth(align: .underCentered, relativeTo: recommendTitle, padding: 0, height: 0.5)
        recommendSubtitle.alignAndFillWidth(align: .underCentered, relativeTo: recommendSeparator, padding: 0, height: 40)
        recommendCollectionLeft.align(.underMatchingLeft, relativeTo: recommendSubtitle, padding: 0, width: view.bounds.width/2, height: recommendCollectionLeft.collectionViewLayout.collectionViewContentSize.height)
        recommendCollectionRight.align(.underMatchingRight, relativeTo: recommendSubtitle, padding: 0, width: view.bounds.width/2, height: recommendCollectionLeft.collectionViewLayout.collectionViewContentSize.height)
        
        // padding adjustment
        recommendTitle.bounds = recommendTitle.frame.insetBy(dx: 20, dy: 0)
        popularSeparator.bounds = popularSeparator.frame.insetBy(dx: 20, dy: 0)
        popularSubtitle.bounds = popularSubtitle.frame.insetBy(dx: 20, dy: 0)
        recommendSeparator.bounds = recommendSeparator.frame.insetBy(dx: 20, dy: 0)
        recommendSubtitle.bounds = recommendSubtitle.frame.insetBy(dx: 20, dy: 0)
        
        // compaction
        scrollView.fitToContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.HomeTitle
    }

}

class ThumbnailCell: UICollectionViewCell {
    
    private lazy var thumbnail: ZFRippleButton = {
        let this = ZFRippleButton()
        this.kf.setImage(with: URL(string: "https://res.cloudinary.com/national-university-of-singapore/image/upload/v1521804170/NUSLib/BookCover\(Int(arc4random_uniform(30)+1)).jpg"),
                              for: .normal,
                              options: [.transition(.fade(0.2))])
        this.kf.base.imageView?.contentMode = .scaleAspectFill
        this.layer.masksToBounds = true
        this.layer.cornerRadius = 20
        this.clipsToBounds = true
        this.rippleColor = UIColor.white.withAlphaComponent(0.2)
        this.rippleBackgroundColor = UIColor.clear
        return this
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbnail)
        
        // layout must come after adding ui to the scene
        thumbnail.fillSuperview()
        
        backgroundColor = UIColor.clear
        clipsToBounds = false
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
