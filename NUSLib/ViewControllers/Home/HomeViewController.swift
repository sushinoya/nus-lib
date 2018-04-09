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
import BarcodeScanner

class HomeViewController: BaseViewController, UIScrollViewDelegate {
    
    let api: LibraryAPI = CentralLibrary()
    
    func addSubViews(){
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
        view.addSubview(scanBarcodeButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        self.addSubViews()
        self.setupNavigationBar()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToItemDetail" {
            if let vc = segue.destination as? BaseViewController {
                state?.itemDetail = BookItem {
                    $0.id = "1000001"
                }
                
                vc.state = state
            }
        }
        
        if let barcodeScannerVC = segue.destination as? BarcodeScannerViewController {
            barcodeScannerVC.codeDelegate = self
            barcodeScannerVC.errorDelegate = self
            barcodeScannerVC.dismissalDelegate = self
            barcodeScannerVC.title = "Scan a barcode"
            barcodeScannerVC.messageViewController.messages.processingText = "Looking for your book"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.NavigationBarTitle.HomeTitle
        
    }
    
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
    
    lazy var popularCollection: HorizontalCollectionView<ThumbnailCell> = { [unowned self] in
        
        let this = HorizontalCollectionView<ThumbnailCell> {
            $0.cellSize = CGSize(width: 320, height: 240)
            $0.cellSpacing = 20
            $0.sectionPadding =  UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            $0.data = self.state?.popularBooks ?? []
            $0.onDequeue = { cell, data, index in
                let items = data.map{ $0 as! BookItem }
                
                cell.title.text = items[index].title
                cell.subtitle.text = items[index].author
            }
        }
        
        this.showsVerticalScrollIndicator = false
        this.showsHorizontalScrollIndicator = false
        this.backgroundColor = UIColor.white
        this.isPagingEnabled = true
        
        this.rx
            .itemSelected
            .subscribe(onNext: { index in
                self.performSegue(withIdentifier: "HomeToItemDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
        return this
        }()
    
    lazy var recommendTitle: UILabel = {
        let this = UILabel()
        this.textColor = UIColor.primary
        this.text = "RECOMMENDED"
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
        
        this.rx
            .itemSelected
            .subscribe(onNext: { index in
                self.performSegue(withIdentifier: "HomeToItemDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
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
        
        this.rx
            .itemSelected
            .subscribe(onNext: { index in
                self.performSegue(withIdentifier: "HomeToItemDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
        return this
        }()
    
    lazy var scanBarcodeButton: UIButton = {
        let this = UIButton()
        this.setTitleColor(UIColor.primaryTint1, for: .normal)
        this.setTitle("Scan Barcode", for: .normal)
        this.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        this.addTarget(self, action: #selector(openBarcodeScanner), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: this)
        return this
    }()
    
    @objc func openBarcodeScanner() {
        self.performSegue(withIdentifier: "HomeToBarcodeScanner", sender: self)
    }

}
