//
//  MovieDetailsViewController.swift
//  Day6Lab1OnlineMovieList
//
//  Created by Hossam on 08/05/2023.
//

import UIKit
import Kingfisher
import JGProgressHUD

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var weekendLabel: UILabel!
    @IBOutlet weak var grossLabel: UILabel!
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    var sourceVC: String!
    var sourceIndex: Int!
    var currentMovie: Item? = nil
    
    let myDatabase = DBManager.sharedMovieDB
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sourceVC == "favorites" {
            deleteBtn.isHidden = true
            favBtn.isHidden = true
        }else{
            deleteBtn.isHidden = false
            favBtn.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = currentMovie?.header
        rankLabel.text = currentMovie?.rank
        weekendLabel.text = currentMovie?.weekend
        weeksLabel.text = currentMovie?.weeks
        grossLabel.text = currentMovie?.gross
        
        let url = URL(string: currentMovie?.image ?? "https://icon-library.com/images/no-image-icon/no-image-icon-20.jpg")
        
        let processor = DownsamplingImageProcessor(size: posterImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        
        posterImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading"),
            options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.flipFromLeft(0.5)),
                    .cacheOriginalImage
                ])
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteBtnClick(_ sender: Any) {
        
        let alert : UIAlertController = UIAlertController(title: "Confirm to delete", message: "Are you sure you want to delete this movie?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            
            self.myDatabase.deleteFromHome(id: (self.currentMovie?.id)!)
            self.navigationController?.popViewController(animated: true)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
//            tableView.reloadData()
        self.present(alert, animated: true)
        
        
    }
    
    @IBAction func addMovieToFavBtnClick(_ sender: Any) {
        self.myDatabase.insertToFav(movie: self.currentMovie!)
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = "Added to Favorites"
        hud.square = true
        hud.style = .dark
        hud.show(in: view)
//        hud.dismiss(afterDelay: 2)
        hud.dismiss(afterDelay: 1, animated: true){
            self.navigationController?.popViewController(animated: true)
        }
        
        
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
