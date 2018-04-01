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
        Contributor(name: "Pharos Production", githubId: "pharosproduction"),
    ])
    
    //MARK: - Variables
    
    @IBOutlet weak var table: UITableView!
    
    private lazy var disposeBag = DisposeBag()
    
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
    }
    
    private func selectContributor(_ contributor: Contributor) {
        print("Selected row: \(contributor)")
        
        let basics = BasicsController.create()
        navigationController?.pushViewController(basics, animated: true)
    }
}
