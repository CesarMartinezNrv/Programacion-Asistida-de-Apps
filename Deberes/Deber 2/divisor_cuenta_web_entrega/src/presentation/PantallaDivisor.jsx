import { useDivisor } from './useDivisor.js'
import './estilos.css'

/** Describe la pantalla y conecta eventos; el hook realiza la coordinación. */
export function PantallaDivisor({ dependencias }) {
  const { campos, cambiar, ejecutar, resultado, error } = useDivisor(dependencias)
  return (
    <main className="contenedor">
      <header className="encabezado">
        <span className="marca" aria-hidden="true">÷</span>
        <div><p className="antetitulo">Una cuenta, un reparto justo</p><h1>Divisor de cuenta</h1></div>
      </header>
      <section className="tarjeta" aria-label="Dividir una cuenta">
        <div className="intro"><h2>¿Cuánto paga cada persona?</h2><p>Ingresa la cuenta y elige cómo redondear el reparto.</p></div>
        <form onSubmit={evento => { evento.preventDefault(); ejecutar() }} noValidate>
          <label className="campo" htmlFor="monto">Monto
            <input id="monto" inputMode="decimal" placeholder="Ej. 100,00" value={campos.monto}
              onChange={evento => cambiar('monto', evento.target.value)} />
          </label>
          <div className="dos-columnas">
            <label className="campo" htmlFor="personas">Personas
              <input id="personas" inputMode="numeric" value={campos.personas}
                onChange={evento => cambiar('personas', evento.target.value)} />
            </label>
            <label className="campo" htmlFor="propina">Propina (%)
              <input id="propina" inputMode="decimal" value={campos.propina}
                onChange={evento => cambiar('propina', evento.target.value)} />
            </label>
          </div>
          <label className="campo" htmlFor="modo">Redondeo
            <select id="modo" value={campos.modo} onChange={evento => cambiar('modo', evento.target.value)}>
              <option value="exacto">Exacto · a dos decimales</option>
              <option value="arriba">Hacia arriba · al entero siguiente</option>
            </select>
          </label>
          <button type="submit">Calcular <span aria-hidden="true">→</span></button>
        </form>
        <div className="salida" aria-live="polite" aria-atomic="true">
          {error !== null && <p className="error" role="alert">{error}</p>}
          {resultado !== null && <div className="resultado"><p>Pago por persona</p><output data-testid="resultado">{resultado}</output></div>}
          {error === null && resultado === null && <p className="espera">El pago por persona aparecerá aquí.</p>}
        </div>
      </section>
      <footer>Sin conexión durante el uso. Sin guardar tus datos.</footer>
    </main>
  )
}
