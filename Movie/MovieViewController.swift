//
//  ViewController.swift
//  Movie
//
//  Created by Basma Alqethami on 13/03/1443 AH.
//

import UIKit
import Alamofire
import Kingfisher
import AlamofireImage

class MovieViewController: UICollectionViewController {

    var MovieList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilms()
    }
    
    func fetchFilms() {
            let url = "https://api.tvmaze.com/shows"
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                let jsondata = data as? [[String:Any]]
                DispatchQueue.main.async {
                    self.MovieList = (jsondata)!
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "img", for: indexPath) as! MovieCell
        
        cell.Image.layer.cornerRadius = 10.0
        
        cell.Title?.text = MovieList[indexPath.row]["name"] as? String
        let Rating = MovieList[indexPath.row]["rating"] as? [String: Any]

        cell.Rate?.text = "Rating: "+String(describing: Rating!["average"] as! Double)

        let urlImage = MovieList[indexPath.row]["image"] as? [String: Any]
        
        let imgURL = urlImage!["medium"] as? String
        
        AF.request(imgURL!).responseImage { response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async {
                    cell.Image.image = image
                }
                
            } else if case .failure(let error) = response.result {
                print(error.localizedDescription)
            }

        }
        return cell
    }

}

