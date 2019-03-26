import UIKit

/// An object that adopts the DataProvidable protocol is responsible for vending information to an item view as needed. It also handles the creation and configuration of cells used by the item view to display data.
final class DataSourceProvider<Item>: DataSourceProvidable  {
    
    // MARK: - Public Properties
    
    /// An array of arrays to hold our data
    var items: [[Item]]
    
    // MARK: - Initialization
    
    /// Our initializer
    /// - Parameters:
    ///    - items : the items to be stored.
    public init(items: [[Item]]) {
        self.items = items
    }
    
    // MARK: - Instance Functions
    
    public func numberOfSections() -> Int {
        return items.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        return items[section].count
    }
    
    public func sequenceView<Cell>(_ sequnceView: CellDequeable, cellForItemAt indexPath: IndexPath) -> Cell where Cell: Reusable, Cell: Configurable, Item == Cell.Item {
        let cell = sequnceView.dequeueReusableCell(forIndexPath: indexPath) as Cell
        let item = items[indexPath.section][indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

