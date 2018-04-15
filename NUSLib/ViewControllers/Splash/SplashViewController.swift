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

    // MARK: - Variables
    let api: LibraryAPI = CentralLibrary()
    let disposeBag = DisposeBag()
    let state = StateController()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Setup Data
    private func setupData() {
        FirebaseDataSource().getPopularItems(completionHandler: {ids in
            self.api.getBooks(byIds: ids, completionHandler: { (popularItems) in
                let popular: Variable<[BookItem]> = Variable(popularItems)

                Observable
                    .zip(popular.asObservable(), self.api.getBooks(byTitle: "amphibians"))
                    .subscribe(onNext: { (popularBooks, recommendedBooks) in
                        self.state.popularBooks = popularBooks
                        self.state.recommendedBooks = recommendedBooks
                        self.performSegue(withIdentifier: "SplashToNavigation", sender: self)
                    })
                    .disposed(by: self.disposeBag)
            })
        })
    }

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? HomeViewController
        destination?.state = state
    }

}
