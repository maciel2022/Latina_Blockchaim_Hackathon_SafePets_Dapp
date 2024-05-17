document.addEventListener('DOMContentLoaded', () => {
    App.init();
})

const tspForm = document.querySelector('#tspForm');

tspForm.addEventListener('submit', async (e) => {
    e.preventDefault();
  
    try {
      // Llamar a createTask y esperar el resultado
      await App.createTSP(tspForm['nombre'].value, tspForm['clase'].value, tspForm['genero'].value, tspForm['nombreD'].value, tspForm['walletD'].value);
  
      // Recargar la página luego de una espera (opcional)
      setTimeout(function() {
        window.location.reload();
      }, 500);  // Ejemplo de retraso de 500 milisegundos
    } catch (error) {
      // Manejar posibles errores durante la creación de la tarea
      console.error("Error creando la tarea:", error);
      // Puedes mostrar un mensaje de error al usuario aquí
    }
  });