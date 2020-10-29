import UIKit

class TvShowsTableViewController: UITableViewController {
    
    //MARK: Propiedades
    private let cellName: String = "CeldaPeliculaTableViewCell"
    private var tvShows: Array<TvShowRes> = []
    private var seleccion: Int!
    
    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        disenoBarra()
        let tvShowService = TvShowService()
        tvShowService.consulta { (callback) in
            self.tvShows = callback
            self.tableView.reloadData()
        }
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    //MARK: Metodos
    private func disenoBarra() -> Void {
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.backgroundColor = UIColor(named: "Barras")
            self.navigationController?.navigationBar.scrollEdgeAppearance = app
            self.navigationController?.navigationBar.compactAppearance = app
        }
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "Barras")
    }
    
    // MARK: - Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CeldaPeliculaTableViewCell
        celda.llenarInfo(tvShows: tvShows[indexPath.row])
        return celda
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoritos = UIContextualAction(style: .normal, title: "Favoritos") {  (contextualAction, view, boolValue) in
            
        }
        favoritos.backgroundColor = .green
        let swipeActions = UISwipeActionsConfiguration(actions: [favoritos])
        return swipeActions
    }
    
    //MARK: Delegados
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = indexPath.row + 1
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let detalle = segue.destination as! DetalleViewController
            detalle.id = seleccion
        }
    }
    
}
