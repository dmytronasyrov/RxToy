//
//  ListController.swift
//  RxToy
//
//  Created by Dmytro Nasyrov on 4/1/18.
//  Copyright © 2018 Pharos Production Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Contributor {
    
    let name: String
    let githubId: String
    var image: UIImage?
    
    init(name: String, githubId: String) {
        self.name = name
        self.githubId = githubId
        image = UIImage(named: githubId)
    }
}

extension Contributor: CustomStringConvertible {
    var description: String {
        return "Contributor: \(name), \(githubId)"
    }
}

final class ListController: UIViewController {
    
    //MARK: - Constants
    
    let data = Observable.just([
        Contributor(name: "Basic UI", githubId: "pharosproduction"),
        Contributor(name: "Collection View", githubId: "pharosproduction")
    ])
    
    //MARK: - Variables
    
    @IBOutlet weak var table: UITableView!
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
    }
    
    //MARK: - Private
    
    private func configureTable() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        data.bind(to: table.rx.items(cellIdentifier: "CellId")) { _, contributor, cell in
            cell.textLabel?.text = contributor.name
            cell.imageView?.image = contributor.image
        }.disposed(by: disposeBag)
        
        table.rx.modelSelected(Contributor.self)
            .subscribe(onNext: selectContributor, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        table.rx.itemSelected
            .subscribe(onNext: itemSelected, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    private func selectContributor(_ contributor: Contributor) {
        print("Selected row: \(contributor)")
    }
    
    private func itemSelected(_ index: IndexPath) {
        switch index.row {
        case 0:
            let basics = BasicsController.create()
            navigationController?.pushViewController(basics, animated: true)
            
        case 1:
            let collection = CollectionController.create()
            navigationController?.pushViewController(collection, animated: true)
            
        default: fatalError("Invalid row")
        }
    }
}
