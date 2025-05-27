//
//  MapListView.swift
//  FruitWalk
//
//  Created by Claire S on 3/21/25.
//

import SwiftUI
import UIKit
import MapKit

/// UIViewRepresentable used to create and manage a UITableView used to show a list `FruitLocation` items on the map
struct MapListView: UIViewRepresentable {
    @Environment(MapStore.self) var mapStore
    @Environment(LocationManager.self) var locationManager
    @Binding var filter: FruitFilter?
    let startCoordinate: CLLocationCoordinate2D?
    var tableView: UITableView?
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(MapListViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        
        context.coordinator.tableView = tableView
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        let groupedLocations = groupAndSortFruit(at: mapStore.data.locations)
        return Coordinator(tableView: tableView, groupedLocations: groupedLocations, startCoordinate: startCoordinate, filter: $filter)
    }
    
    /// Takes an array of `FruitLocations` and returns them grouped by display name and sorted alphabetically
    /// The creation of the groups is O(n) and the sorting of the groups is O(n log n) complexity
    /// - Parameter locations: an array of individual `FruitLocation`s`
    /// - Returns: and array of `MapListGroup`s each with an array of `FruitLocation`s, a title and a expanded in the UI flag
    private func groupAndSortFruit(at locations: [FruitLocation]) -> [MapListGroup] {
        var groupedLocations = [MapListGroup]()
        
        let locationMap = Dictionary(grouping: locations, by: {$0.displayName} )
        for (title, locations) in locationMap {
            let group = MapListGroup(title: title, locations: locations, isExpanded: locations.count == 1)
            groupedLocations.append(group)
        }
        
        groupedLocations.sort{$0.title < $1.title}
        return groupedLocations
    }
    
    final class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var filter: Binding<FruitFilter?>
        var tableView: UITableView?
        var groupedLocations: [MapListGroup]
        let startCoordinate: CLLocationCoordinate2D?
        
        init(tableView: UITableView?, groupedLocations: [MapListGroup], startCoordinate:CLLocationCoordinate2D?, filter: Binding<FruitFilter?>) {
            self.tableView = tableView
            self.groupedLocations = groupedLocations
            self.startCoordinate = startCoordinate
            self.filter = filter
        }
        
        // MARK: UITableViewDataSource
        func numberOfSections(in tableView: UITableView) -> Int {
            return groupedLocations.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if groupedLocations[section].isExpanded {
                return groupedLocations[section].locations.count
            } else {
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let location = groupedLocations[indexPath.section].locations[indexPath.row]
            // use a SWiftUI view for each item. It shares common widgets with other parts of the app.
            cell.contentConfiguration = UIHostingConfiguration {
                MapListViewItem(location: location, filter: filter, startCoordinate: startCoordinate)
            }
            cell.selectionStyle = .none
            return cell
        }
        
        // MARK: UITableViewDelegate
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! MapListViewSectionHeader
            
            // for groups of 1 just use the section header as a divider
            view.title.isHidden = groupedLocations[section].locations.count < 2
            view.button.isHidden = groupedLocations[section].locations.count < 2
            
            if groupedLocations[section].locations.count > 1 {
                view.title.text = groupedLocations[section].title
                view.button.setAttributedTitle(getSectionHeaderButtonTitle(fruitCount: groupedLocations[section].locations.count, sectionIsExpanded: groupedLocations[section].isExpanded), for: .normal)
                view.button.addTarget(self, action: #selector(handleExpandCollapse(button:)), for: .touchUpInside)
                view.button.isExclusiveTouch = true
            }
            
            view.button.tag = section
            return view
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return nil
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if groupedLocations[section].locations.count > 1 {
                return 50 // TODO remove hard code
            } else {
                return 10 // TODO remove hard code
            }
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 1
        }
        
        // MARK: Actions
        @objc private func handleExpandCollapse(button: UIButton) {
            let section = button.tag
            var indexPaths = [IndexPath]()
            
            for row in groupedLocations[section].locations.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
            
            let isExpanded = groupedLocations[section].isExpanded
            groupedLocations[section].isExpanded = !isExpanded
            
            button.setAttributedTitle(getSectionHeaderButtonTitle(fruitCount: groupedLocations[section].locations.count, sectionIsExpanded: groupedLocations[section].isExpanded), for: .normal)
            if isExpanded {
                tableView?.deleteRows(at: indexPaths, with: UITableView.RowAnimation.fade)
            } else {
                tableView?.insertRows(at: indexPaths, with: .fade)
            }
        }
        
        // MARK: functions
        func getSectionHeaderButtonTitle(fruitCount count: Int, sectionIsExpanded expanded: Bool) -> NSAttributedString {
            let textString = NSMutableAttributedString(string: "(\(count.description)) ",
                                                       attributes: [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption1),
                                                                    NSAttributedString.Key.foregroundColor: UIColor.label])
            let attachment = NSTextAttachment()
            attachment.image = UIImage(systemName: expanded ? "chevron.up" : "chevron.down")
            let imageString = NSAttributedString(attachment: attachment)
            textString.append(imageString)
            
            return textString
        }
    }
}
