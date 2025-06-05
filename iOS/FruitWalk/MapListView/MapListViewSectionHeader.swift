//
//  MapListViewItem.swift
//  FruitWalk
//
//  Created by Claire S on 5/21/25.
//

import SwiftUI

/// MapListViewSectionHeader
/// UIKit TableView section header for the MapListView's UITableView
class MapListViewSectionHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let button = UIButton(type: .custom)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 1
        // set compression resistence low otherwise when the the title label text is too long it will push the button to the right
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label
        contentView.addSubview(title)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor( .label, for: .normal)
        contentView.addSubview(button)
        
        let titleLeft = title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        let buttonLeft = button.leadingAnchor.constraint(equalTo: title.trailingAnchor)
        let buttonRight = button.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        let titleCenterY = title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let buttonCenterY = button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        NSLayoutConstraint.activate([titleLeft, buttonLeft, buttonRight, titleCenterY, buttonCenterY])
    }
}
