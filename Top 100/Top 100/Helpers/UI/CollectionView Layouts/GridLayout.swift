import UIKit

//: A subclass of UICollectionView Flow Layout to layout multiple columns In a CollectionView as a grid of square cells.
final public class GridLayout: UICollectionViewFlowLayout {
    
    private let spacing: CGFloat = 8.0
    private let minColumnWidth = CGFloat(152.0)
    
    override public func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            fatalError("ColumnFlowLayout requires a CollectionView")
        }
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down) - (minimumInteritemSpacing)
        itemSize = CGSize(width: cellWidth, height: cellWidth)
        sectionInset = UIEdgeInsets(top: collectionView.layoutMargins.top,
                                    left: collectionView.layoutMargins.left + (spacing/2.0),
                                    bottom: collectionView.layoutMargins.bottom,
                                    right: collectionView.layoutMargins.right + (spacing/2.0))
        sectionInsetReference = .fromSafeArea
    }
}
