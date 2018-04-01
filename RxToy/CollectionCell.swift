//
//  CollectionCell.swift
//  RxToy
//
//  Created by Dmytro Nasyrov on 4/1/18.
//  Copyright © 2018 Pharos Production Inc. All rights reserved.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String?
    
    // MARK: - Life
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.text = "..."
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = "..."
        title = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.text = title
    }
}
