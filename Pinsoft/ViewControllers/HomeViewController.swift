//
//  HomeViewController.swift
//  Pinsoft
//
//  Created by Ege Sucu on 4.08.2021.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
//    MARK: Variable Definitions
    @IBOutlet weak var movieListView : UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataManager = DataManager.shared
    var movieID : String? = nil
    var movies = [ShortMovie]()
    var errorString = "Start typing to find movies."
    let loadingView = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100, height: 100), type: .ballScaleMultiple, color: .systemBlue, padding: 10)
    
    //    MARK: UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loadingView)
        
        setupLoading()
        
    }
    
    //MARK: Design
    
    private func setupLoading(){
        loadingView.isHidden = true
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.movieListView.isHidden = false
            self.loadingView.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.movieListView.reloadData()
        }
    }
    
}

//MARK: Helper functions
extension HomeViewController {
    private func loadMovies(withQuery: String?){
        
        guard let string = withQuery, !string.isEmpty else {
            return
        }
        
        movies.removeAll()
        
        movieListView.isHidden = true
        
        loadingView.startAnimating()
        
        dataManager.getMovieArray( string) { result in
            switch result {
            case .success(let movies):
                self.movies = movies.search ?? [ShortMovie]()
                self.stopLoading()
            case .failure(let error):
                switch error {
                case .parseError:
                    print(error)
                case .invalidData:
                    print(error)
                case .invalidURL:
                    print(error)
                case .unknownError(let string):
                    self.createAlert(context: string)
                }
            }
        }
        
    }
}

//MARK: Table View Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard movies.count > 0  else {
            return 1
        }
        
        return movies.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if movies.count == 0 {
            return 0
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        Edge case where there are no movie in the list, show an empty View.
        guard movies.count > 0 else {
            
            
            let emptyLabel = UILabel()
            emptyLabel.text = errorString
            emptyLabel.textAlignment = .center
            emptyLabel.font = .preferredFont(forTextStyle: .headline)
            
            tableView.isScrollEnabled = false
            tableView.tableFooterView = nil
            tableView.backgroundView = emptyLabel
            
            
            
            return UITableViewCell(frame: .zero)
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieCell {
            
            let movie = movies[indexPath.row]
            tableView.isScrollEnabled = true
            tableView.backgroundView = nil
            tableView.backgroundColor = .systemGroupedBackground
            
            cell.titleLabel.text = movie.title
            cell.yearLabel.text = movie.year
            
            if movie.image != "N/A",
               let url = URL(string: movie.image)
            {
                
                DispatchQueue.main.async {
                    cell.thumbnailView.kf.setImage(with: url,placeholder: UIImage(named: "placeholder-image"))
                }
                
            } else {
                cell.thumbnailView.image = UIImage(named: "placeholder-image")
            }
            
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if movies.count > 0 {
            return "Total of \(movies.count) movies found."
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if movies.count > 0 {
            return "Results"
        } else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard movies.count > 0 else {
            return
        }
        
        movieID = movies[indexPath.row].imdbID
        
        self.performSegue(withIdentifier: "showDetail", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            if let vc = segue.destination as? MovieDetailViewController{
                if let movieID = movieID{
                    vc.movieID = movieID
                    vc.dataManager = dataManager
                }
            }
        }
    }
    
}

//MARK: Search Bar Delegate
extension HomeViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text,
           text.trimmingCharacters(in: .whitespacesAndNewlines).count > 2{
            searchBar.resignFirstResponder()
            loadMovies(withQuery: searchBar.text)
        } else {
            self.errorString = "Please enter more character"
        }
        
    }
    
}
