//
//  MoviesViewController.swift
//  MovieRecommender
//
//  Created by Sitare Arslanturk on 12.01.2022.
//

import UIKit

extension MoviesViewController: MovieDataSourceDelegate {
    func moviesRecommended(movieList: [String]) {
        let recommendationVC = RecommendationViewController()
        recommendationVC.recommendations = movieList
        dismiss(animated: false, completion: nil)
        self.navigationController?.pushViewController(recommendationVC, animated: true)
    }
}

class MoviesViewController: UIViewController {
//    var recommendations: [String] = []
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
    let movieDataSource = MovieDataSource()
    var movies = loadCSV(from: "movies") //.sorted { $0.title.lowercased() < $1.title.lowercased() }
    var chosenMovies = [String:Int]()
    private var filtered:[Movie] = []
    private var searching : Bool = false
    private let tableView = UITableView()
    private let recommendButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("RECOMMEND", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.addTarget(self, action: #selector(recommendTapped), for: .touchUpInside)
        return btn
    }()
    private let searchBar = UISearchBar()
    private let navigationBar = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    
    @objc func recommendTapped(){
        let userInput = ["movies":chosenMovies]
        movieDataSource.postChosenMovies(userInput)
        showLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Search Movies"
//        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        movieDataSource.delegate = self
        setupView()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset()
    }
    
    func reset(){
        movies = loadCSV(from: "movies")
        chosenMovies = [:]
        filtered = []
        searching = false
        tableView.reloadData()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    
    func setupView() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navigationBar.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor).isActive = true
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        view.addSubview(recommendButton)
        recommendButton.translatesAutoresizingMaskIntoConstraints = false
        recommendButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        recommendButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        recommendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        recommendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        alert.view.tintColor = UIColor.black
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filtered.count
        }
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        var currentMovie = movies[indexPath.row]
        if searching {
            currentMovie = filtered[indexPath.row]
        }
        cell.configure(movieTitle: currentMovie.title, rating: currentMovie.rating)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        if searchText.isEmpty {
            searching = false
            tableView.reloadData()
            return
        }
        filtered = movies
            .filter { $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            .sorted { $0.title.lowercased() < $1.title.lowercased() }
        if(filtered.count == 0){
            searching = false
        } else {
            searching = true
        }
        self.tableView.reloadData()
    }
}

extension MoviesViewController: MyCellViewDelegate {
    func movieRated(movieTitle: String, userRating: Double) {
        if userRating != 0.0 {
            chosenMovies[movieTitle] = Int(userRating)
        } else {
            chosenMovies[movieTitle] = nil
        }
        
        if let i = movies.firstIndex(where: { $0.title == movieTitle }) {
            movies[i].rating = userRating
        }
        if let i = filtered.firstIndex(where: { $0.title == movieTitle }) {
            filtered[i].rating = userRating
        }
        searchBar.resignFirstResponder()
        print(chosenMovies)
    }
}
