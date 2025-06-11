# subasta
  Este es un contrato de **subasta** hecho en Solidity.  
La idea es que varias personas puedan ofertar con dinero (ETH), y quien ofrezca más gana.

---

## 👤 ¿Quién puede usarlo?

- **El dueño**: es quien crea la subasta.
- **Los usuarios**: son los que hacen ofertas con ETH.

---

## ⏰ ¿Cómo funciona?

1. El contrato empieza con una duración (por ejemplo, 3600 segundos para 1hs).
2. Cualquier persona puede hacer una oferta.
3. Cada nueva oferta tiene que ser al menos **5% más alta** que la anterior.
4. Si alguien oferta y faltan menos de 10 minutos, se agregan 10 minutos más.
5. Cuando se termina el tiempo, **ya no se puede ofertar**.
6. El dueño puede finalizar la subasta y quedarse con el dinero del ganador.
7. Los que no ganaron pueden retirar su dinero (con una pequeña comisión del 2%).

---

## 🔧 Variables (datos que guarda el contrato)

- `owner`: la persona que creó la subasta.
- `expires`: el momento en que la subasta termina.
- `mayorOferta`: la oferta más alta que alguien ha hecho.
- `ganador`: la persona que hizo la mejor oferta.
- `depositos`: cuánto dinero ofreció cada persona.
- `historial`: una lista de todas las ofertas que se hicieron.

---

## ⚙️ Funciones

### `constructor(_duracionSegundos)`
Se ejecuta al crear el contrato.  
Guarda quién es el dueño y cuánto tiempo va a durar la subasta.

---

### `ofertar()`
Sirve para hacer una oferta.  
- Se necesita enviar ETH.
- La oferta debe ser más alta que la anterior.
- Se guarda en el historial.
- Se actualiza el ganador.

---

### `mostrarGanador()`
Devuelve quién va ganando y cuánto ofertó.

---

### `mostrarOfertas()`
Devuelve todas las ofertas que se hicieron.

---

### `claimOferta()`
Sirve para **recuperar el dinero** si no ganaste.  
- Solo funciona si la subasta ya terminó.
- El ganador **no** puede usar esta función.
- Te devuelve el 98% de tu dinero (el 2% es comisión).

---

### `finalizarSubasta()`
Solo el dueño puede usar esta función.  
Termina la subasta y le envía el dinero del ganador al dueño.  
También lanza un mensaje (evento) con el resultado.

---

## 📢 Eventos

Los eventos son como mensajes que avisan lo que pasó:

- `nuevaOferta`: se lanza cuando alguien hace una oferta.
- `subastaFinalizada`: se lanza cuando termina la subasta.
