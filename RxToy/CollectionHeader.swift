//
//  CollectionHeader.swift
//  RxToy
//
//  Created by Dmytro Nasyrov on 4/1/18.
//  Copyright © 2018 Pharos Production Inc. All rights reserved.
//

import UIKit

final class CollectionHeader: UICollectionReusableView {
    
    // MARK: - Variables
    
    @IBOutlet weak var headerLabel: UILabel!
    
    var text: String?
    
    // MARK: - Life
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headerLabel.text = "..."
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        headerLabel.text = "..."
        text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.text = text
    }
}
