//
//  RecommendationCollectionViewCell.swift
//  MovieRecommender
//
//  Image attribute to <a href='https://www.freepik.com/vectors/icons'>Icons vector created by ikaika - www.freepik.com</a>
//  Created by Sitare Arslanturk on 16.01.2022.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    static let identifier = "recommenderCell"
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "preview")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func configureCell(movieTitle:String){
        movieLabel.text = movieTitle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 10.0
        movieImageView.layer.masksToBounds = true
        movieImageView.clipsToBounds = true
        contentView.backgroundColor = .systemOrange
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieLabel.frame = CGRect(x: 5, y: contentView.frame.size.height-100, width: contentView.frame.size.width-10, height: 100)
        movieImageView.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.height-10, height: contentView.frame.size.height-100)
    }
}
