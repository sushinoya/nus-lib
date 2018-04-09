//
//  SplashController.swift
//  NUSLib
//
//  Created by wongkf on 9/4/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {

    let api: LibraryAPI = CentralLibrary()
    let disposeBag = DisposeBag()
    let state = StateController()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        FirebaseDataSource().getPopularItems(completionHandler: {ids in
            self.api.getBooks(byIds: ids, completionHandler: { (popularItems) in
                let popular: Variable<[BookItem]> = Variable(popularItems)
                
                Observable
                    .zip(popular.asObservable(), self.api.getBooks(byTitle: "university"))
                    .subscribe(onNext: { (popularBooks, recommendedBooks) in
                        self.state.popularBooks = popularBooks
                        self.state.recommendedBooks = recommendedBooks
                        self.performSegue(withIdentifier: "SplashToNavigation", sender: self)
                    })
                    .disposed(by: self.disposeBag)
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? HomeViewController
        destination?.state = state
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
