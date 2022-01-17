//
//  MovieTableViewCell.swift
//  MovieRecommender
//
//  Created by Sitare Arslanturk on 14.01.2022.
//

import UIKit
import Cosmos

protocol MyCellViewDelegate {
    func movieRated(movieTitle: String, userRating: Double)
}

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    var delegate: MyCellViewDelegate?
    var movieRating = 0.0
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.rating = 0.0
        view.settings.fillMode = .full
        return view
    }()
    
    private let resetButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Reset", for: .normal)
        btn.backgroundColor = .clear
        btn.setTitleColor(.orange, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func resetButtonTapped(){
        cosmosView.rating = 0.0
        if let movieTitle = self.title.text {
            self.delegate?.movieRated(movieTitle: movieTitle, userRating: 0.0)
        }
    }
    
    public func configure(movieTitle:String, rating:Double){
        title.text = movieTitle
        cosmosView.rating = rating
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        cosmosView.rating = 0.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(title)
        contentView.addSubview(cosmosView)
        contentView.addSubview(resetButton)
        contentView.isUserInteractionEnabled = true
        cosmosView.didFinishTouchingCosmos = { rating in
            self.movieRating = rating
            if let movieTitle = self.title.text {
                self.delegate?.movieRated(movieTitle: movieTitle, userRating: self.movieRating)
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 5, height: 20)
        cosmosView.frame = CGRect(x: 5, y: 30, width: 100, height: 15)
        resetButton.frame = CGRect(x: contentView.frame.size.width - 55, y: 30, width: 50, height: 15)
    }
}
