import UIKit
import CoreData

class FavoriteShowsTableViewController: UITableViewController {
    
    //MARK: Propiedades
    private let cellName: String = "CeldaPeliculaTableViewCell"
    private var seleccion: Int!
    private var tvShows: Array<NSManagedObject> = []

    //MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargaDatos()
    }
    
    //MARK: Metodos
    private func cargaDatos() -> Void {
        disenoBarra()
        let datos = ShowsRepository.consultar()
        if datos.count > 0 {
            tvShows = datos
            self.tableView.reloadData()
        }
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    private func disenoBarra() -> Void {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = UIColor(named: "Barras")
            UIApplication.shared.windows.first?.addSubview(statusBar)
        }
    }

    // MARK: Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CeldaPeliculaTableViewCell
        let serie = tvShows[indexPath.row] as! Series
        celda.llenarDatosBase(tvShow: serie)
        return celda
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let eliminar = UIContextualAction(style: .destructive, title: "Eliminar") {  (contextualAction, view, boolValue) in
            Alertas.preguntaEliminar(controlador: self) { (res) in
                if res {
                    let serie = self.tvShows[indexPath.row] as! Series
                    let elimina = ShowsRepository.eliminar(id: Int(serie.id))
                    self.present(Alertas.eliminaGuarda(status: elimina, eliminar: true), animated: true, completion: nil)
                    if elimina {
                        self.tvShows.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [eliminar])
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    //MARK: Delegados
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = indexPath.row
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detalle" {
            let detalle = segue.destination as! DetalleViewController
            detalle.tvShowDelegate = self
            let serie = tvShows[seleccion] as! Series
            detalle.tvShow = serie
        }
    }
    
}

extension FavoriteShowsTableViewController: TvShowsDelegate {
    
    func respuestaGuardato(favorito: Bool?) {
        if let respFavo = favorito, !respFavo {
            self.tableView.reloadData()
        }
    }
    
}
