//
//  VerticalCollectionView.swift
//  NUSLib
//
//  Created by wongkf on 23/3/18.
//  Copyright © 2018 nus.cs3217.nuslib. All rights reserved.
//

import UIKit

class VerticalCollectionView<T: UICollectionViewCell>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    internal var cellWidth: CGFloat?
    internal var cellHeight: CGFloat?
    internal var columnPadding: UIEdgeInsets!
    internal var cellSpacing: CGFloat!

    internal var data: [Any] = []

    internal var onDequeue: ((T, [Any], Int) -> Void)?

    init(build: (VerticalCollectionView) -> Void) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1)), collectionViewLayout: layout)
        build(self)

        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1000.0

        self.delegate = self
        self.dataSource = self

        // automatically infer reusable identifier from the class name and register it
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T

        onDequeue?(cell, data, indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cellWidth ?? 300) - columnPadding.left - columnPadding.right, height: cellHeight ?? 600)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return columnPadding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
