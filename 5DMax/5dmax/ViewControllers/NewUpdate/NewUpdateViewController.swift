//
//  NewUpdateViewController.swift
//  5dmax
//
//  Created by Admin on 9/10/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class NewUpdateViewController: BaseCollectionViewController {
    var filmService = FilmService()
    var playlistId: String = "4"
    var listMovies: [FilmModel] = []
    var titleScreen: String? = String.moi_cap_nhat
    
    init(title: String?, playID: String?) {
        super.init(nibName: "NewUpdateViewController", bundle: nil)
        titleScreen = title
        if let value = playID {
            playlistId = value
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func doSomethingOnload() {
        super.doSomethingOnload()
        self.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpView() {
        self.title = titleScreen
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
    }

    override func getData(offset: Int, limit: Int, _ completion: @escaping (Result<Any>) -> Void) {
        filmService.getCollectionPlayList(playListID: playlistId, offset: offset, limit: limit, completion: completion)
    }
    
    deinit {
        
    }
}
