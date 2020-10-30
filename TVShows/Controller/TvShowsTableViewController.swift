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
        tvShowService.consulta(callBack: { (callBack) in
            self.tvShows = callBack
            self.tableView.reloadData()
        }) { (errorCall) in
            self.alertaRecarga()
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
    
    private func alerta(status: Bool, eliminar: Bool) -> Void {
        let titulo = status ? (eliminar ? "Eliminado" : "Guardado") : "Oops, algo salió mal!"
        let mensaje = status ? (eliminar ? "Se elimino de favoritos" : "Se agrego a favoritos") : "Hubo un problema al guardar este show de TV"
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alerta, animated: true, completion: nil)
    }
    
    private func alertaRecarga() -> Void {
        DispatchQueue.main.async {
            let alerta = UIAlertController(title: "Oops, algo salió mal!", message: "Hubo un error al consultar el servicio. ¿Quieres intentar nuevamente?", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
                let tvShowService = TvShowService()
                tvShowService.consulta(callBack: { (callBack) in
                    self.tvShows = callBack
                    self.tableView.reloadData()
                }) { (errorCall) in
                    print(errorCall)
                }
            })
            alerta.addAction(UIAlertAction(title: "Cancelar", style: .destructive))
            self.present(alerta, animated: true, completion: nil)
        }
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
        let serie = self.tvShows[indexPath.row]
        
        let serieEncontrada = ShowsRepository.consultar(id: serie.id!)
        
        var swipeActions = UISwipeActionsConfiguration()
        
        let accion = UIContextualAction(style: .normal, title: serieEncontrada == nil ? "Favoritos" : "Eliminar") {  (contextualAction, view, boolValue) in
            let res = serieEncontrada == nil ? ShowsRepository.guardar(tvShow: self.tvShows[indexPath.row]) : ShowsRepository.eliminar(id: serie.id!)
            self.alerta(status: res, eliminar: serieEncontrada != nil)
        }
        accion.backgroundColor = serieEncontrada == nil ? .green : .red
        swipeActions = UISwipeActionsConfiguration(actions: [accion])
        
        return swipeActions
    }
    
    //MARK: Delegados
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleccion = indexPath.row
        performSegue(withIdentifier: "detalle", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let detalle = segue.destination as! DetalleViewController
            let serie = tvShows[seleccion]
            detalle.idTvShow = serie.id
            detalle.tvShowRes = serie
        }
    }
    
}
