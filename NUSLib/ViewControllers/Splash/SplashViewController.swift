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
        
        api.getBooks(byTitle: "popular")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (books) in
                self.state.popularBooks = books
                self.performSegue(withIdentifier: "SplashToNavigation", sender: self)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? HomeViewController
        destination?.state = state
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
