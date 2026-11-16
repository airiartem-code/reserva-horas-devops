// Simula el envío del formulario: no envía ni guarda datos.
document.getElementById('form-reserva').addEventListener('submit', function (evento) {
  evento.preventDefault();
  document.getElementById('mensaje').hidden = false;
  this.reset();
});
