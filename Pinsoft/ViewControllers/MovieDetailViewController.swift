//
//  MovieDetailViewController.swift
//  Pinsoft
//
//  Created by Ege Sucu on 4.08.2021.
//

import UIKit
import FirebaseAnalytics
import NVActivityIndicatorView

class MovieDetailViewController: UIViewController {
    
//    MARK: Variable definitions
    var movieID = ""
    var dataManager = DataManager.shared
    var singleMovie : Movie?
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var ratingsCollection: UICollectionView!
    
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100, height: 100), type: .ballScaleMultiple, color: .systemBlue, padding: 10)
    var errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        setupLoadingView()
        setupLabelView()
        
        loadMovie(withID: movieID)
    }
    
    private func setupLabelView(){
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    private func setupLoadingView(){
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    
    private func setupLayout() {
        if let movie = self.singleMovie{
            self.posterImageView.isHidden = false
            self.titleLabel.isHidden = false
            self.descriptionLabel.isHidden = false
            self.ratingsCollection.isHidden = false
            
            self.posterImageView.layer.cornerRadius = 15
            
            self.titleLabel.text = movie.title
            if movie.description == "N/A"{
                self.descriptionLabel.text = "The movie has no description"
            } else {
                self.descriptionLabel.text = movie.description
            }
            guard let imageURL = URL(string: movie.image) else {
                self.posterImageView.image = UIImage(named: "placeholder-image")
                return
            }
            self.posterImageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "placeholder-image"),options: [.transition(.fade(1))])
            self.ratingsCollection.reloadData()
            
        } else {
            errorLabel.isHidden = false
            errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            errorLabel.text = "An error occured. Please try again."
            errorLabel.textAlignment = .center
            errorLabel.font = .preferredFont(forTextStyle: .body)
            
        }
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
        logEvents()
        
    }
    
    private func logEvents(){
        if let movie = singleMovie{
            
            //            Reducing 100 chars for Poster and Details in order to satisfy Google Analytics Log character limits.
            
            var ratings = ""
            
            if movie.ratings.count > 0{
                movie.ratings.forEach { rating in
                    ratings.append("\(rating.source):\(rating.value) | ")
                }
            }
            
            
            let parameters : [String: Any] = [
                "Title": movie.title,
                "Year": movie.year,
                "Poster": String(movie.image.prefix(100)),
                "Details": String(movie.description.prefix(100)),
                "Ratings": ratings
            ]
            
            Analytics.logEvent("movie_data", parameters: parameters)
        } else {
            Analytics.logEvent("empty_movie", parameters: nil)
        }
    }
    
    private func loadMovie(withID id: String){
        
        self.loadingView.startAnimating()
        
        dataManager.getMovie(with: id) { result in
            
            switch result{
            
            case .success(let movie):
                self.singleMovie = movie
                DispatchQueue.main.async {
                    self.setupLayout()
                }
            case .failure(let error):
                switch error {
                case .parseError:
                    print(error)
                case .invalidData:
                    print(error)
                case .invalidURL:
                    print(error)
                case .unknownError(let string):
                    DispatchQueue.main.async {
                        self.createAlert(context: string)
                    }
                }
            }
        }
    }
    
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movie = singleMovie{
            return movie.ratings.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let movie = singleMovie{
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rating", for: indexPath) as? RateCell{
                
                guard movie.ratings.count > 0 else {
                    return UICollectionViewCell()
                }
                
                let rating = movie.ratings[indexPath.row]
                cell.rateLabel.text = rating.value
                cell.sourceLabel.text = rating.source
                
                return cell
            } else {
                return UICollectionViewCell()
            }
            
        } else {
            return UICollectionViewCell()
        }
    }
    
}
