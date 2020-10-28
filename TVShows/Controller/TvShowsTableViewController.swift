import UIKit

class TvShowsTableViewController: UITableViewController {
    
    //MARK: Propiedades
    private let cellName: String = "CeldaPeliculaTableViewCell"
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CeldaPeliculaTableViewCell
        celda.llenarInfo()
        return celda
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
