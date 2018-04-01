//
//  CollectionController.swift
//  RxToy
//
//  Created by Dmytro Nasyrov on 4/1/18.
//  Copyright © 2018 Pharos Production Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct AnimatedSectionModel {
    let title: String
    var data: [String]
}

extension AnimatedSectionModel: AnimatableSectionModelType {
    
    typealias Item = String
    typealias Identity = String
    var identity: Identity { return title }
    var items: [Item] { return data }
    
    init(original: AnimatedSectionModel, items: [String]) {
        self = original
        data = items
    }
}

final class CollectionController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var addBt: UIBarButtonItem!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet var longRecognizer: UILongPressGestureRecognizer!
    
    private let disposeBag = DisposeBag()
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatedSectionModel>(configureCell: { _, collectionView, index, title in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: index) as! CollectionCell
        cell.title = title
        cell.setNeedsLayout()

        return cell
    }, configureSupplementaryView: { dataSource, collectionView, kind, index in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderId", for: index) as! CollectionHeader
        header.text = dataSource.sectionModels[index.section].title
        
        return header
    }, moveItem: { _, _, _ in }, canMoveItemAtIndexPath: { _, _ in
        return true
    })
    private let data = Variable<[AnimatedSectionModel]>([AnimatedSectionModel(title: "Section 0", data: ["0-0"])])
    
    // MARK: - Public
    
    static func create() -> CollectionController {
        return UIStoryboard(name: "CollectionController", bundle: nil).instantiateInitialViewController() as! CollectionController
    }
    
    // MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data.asDriver()
            .drive(collection.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        addBt.rx.tap.asDriver()
            .drive(onNext: onAddAction, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        collection.addGestureRecognizer(longRecognizer)
        longRecognizer.rx.event
            .subscribe(onNext: onLongAction, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    private func onAddAction() {
        let section = data.value.count
        let numOfItems = Int(arc4random_uniform(6)) + 1
        let items = (0...numOfItems).map { "\(section)-\($0)" }
        
        data.value += [AnimatedSectionModel(title: "Section: \(section)", data: items)]
    }
    
    private func onLongAction(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            guard let selectedIndex = collection.indexPathForItem(at: recognizer.location(in: collection)) else { break }
            collection.beginInteractiveMovementForItem(at: selectedIndex)
            
        case .changed: collection.updateInteractiveMovementTargetPosition(recognizer.location(in: recognizer.view!))
        case .ended: collection.endInteractiveMovement()
        default: collection.cancelInteractiveMovement()
        }
    }
}
