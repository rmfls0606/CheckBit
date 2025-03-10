//
//  PopularSearchesView.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit
import SnapKit

class PopularSearchesView: BaseView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(popularTitleLable)
        view.addSubview(dateLabel)
        return view
    }()
    
    private let popularTitleLable: UILabel = {
        let label = UILabel()
        label.text = "인기 검색어"
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "02.16 00:30 기준"
        label.textColor = UIColor(resource: .secondary)
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private(set) lazy var popularCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(containerView)
        self.addSubview(popularCollectionView)
    }
    
    override func configureLayout() {
        
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.popularTitleLable.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(16)
        }
        
        self.popularCollectionView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<String, TrendingCoinItem>!
    
    override func configureView() {
        configureDataSource()
        updateSnapshot(trendingList: [])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let leftGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(40)
        )
        let leftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: leftGroupSize,
            subitems: Array(repeating: item, count: 7)
        )
        
        let rightGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(40)
        )
        
        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: rightGroupSize,
            subitems: Array(repeating: item, count: 7)
        )
        
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [leftGroup, rightGroup]
        )
        
        horizontalGroup.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.interGroupSpacing = 20
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource(){
        let cellRegistraion = UICollectionView.CellRegistration<PopularCollectionViewCell, TrendingCoinItem> { cell, indexPath, itemIdentifier in
            cell.insertData(rank: indexPath.row + 1, data: itemIdentifier)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: popularCollectionView,
            cellProvider: {
                collectionView,
                indexPath,
                itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistraion,
                    for: indexPath,
                    item: itemIdentifier
                )
                return cell
            }
        )
    }
    
    func updateSnapshot(trendingList: [TrendingCoinItem]){
        var snapshot = NSDiffableDataSourceSnapshot<String, TrendingCoinItem>()
        snapshot.appendSections(["PopularSearches"])
        snapshot.appendItems(trendingList, toSection: "PopularSearches")
        
        DispatchQueue.main.async{
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func updateDateString(date: String){
        self.dateLabel.text = date
    }
}
