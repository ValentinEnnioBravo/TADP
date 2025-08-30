
## 🔒 Encapsulación: public, private, protected

```ruby
class CuentaBancaria
  attr_reader :numero_cuenta, :titular
  
  def initialize(titular, saldo_inicial = 0)
    @numero_cuenta = generar_numero_cuenta
    @titular = titular
    @saldo = saldo_inicial
  end
  
  # Métodos públicos (por defecto)
  def depositar(cantidad)
    return "Cantidad debe ser positiva" if cantidad <= 0
    @saldo += cantidad
    registrar_transaccion("Depósito", cantidad)
    "Depósito exitoso. Saldo actual: $#{@saldo}"
  end
  
  def retirar(cantidad)
    return "Cantidad debe ser positiva" if cantidad <= 0
    return "Fondos insuficientes" if cantidad > @saldo
    
    @saldo -= cantidad
    registrar_transaccion("Retiro", cantidad)
    "Retiro exitoso. Saldo actual: $#{@saldo}"
  end
  
  def consultar_saldo
    if saldo_autorizado?
      "Saldo actual: $#{@saldo}"
    else
      "No autorizado para consultar saldo"
    end
  end
  
  protected
  
  # Los métodos protected pueden ser llamados por objetos de la misma clase
  def transferir_a(otra_cuenta, cantidad)
    return "Fondos insuficientes" if cantidad > @saldo
    
    @saldo -= cantidad
    otra_cuenta.recibir_transferencia(cantidad, self)
    registrar_transaccion("Transferencia enviada", cantidad)
  end
  
  def recibir_transferencia(cantidad, cuenta_origen)
    @saldo += cantidad
    registrar_transaccion("Transferencia recibida de #{cuenta_origen.numero_cuenta}", cantidad)
  end
  
  private
  
  # Los métodos privados solo pueden ser llamados internamente
  def generar_numero_cuenta
    "ACC-#{rand(100000..999999)}"
  end
  
  def registrar_transaccion(tipo, cantidad)
    # En una aplicación real, esto guardaría en una base de datos
    puts "TRANSACCIÓN: #{tipo} por $#{cantidad} en cuenta #{@numero_cuenta}"
  end
  
  def saldo_autorizado?
    # Lógica de autorización (simplificada)
    true
  end
end

# Uso de la clase
cuenta1 = CuentaBancaria.new("Ana García", 1000)
cuenta2 = CuentaBancaria.new("Luis Martín", 500)

puts cuenta1.depositar(200)        # Funciona (método público)
puts cuenta1.retirar(100)          # Funciona (método público)
puts cuenta1.consultar_saldo       # Funciona (método público)

# cuenta1.generar_numero_cuenta    # Error: método privado
# cuenta1.registrar_transaccion("test", 100)  # Error: método privado
```

## 🎯 Ejemplos Prácticos Completos

### 1. Sistema de Biblioteca
```ruby
class Libro
  attr_reader :isbn, :titulo, :autor, :año_publicacion
  attr_accessor :disponible, :ubicacion
  
  def initialize(isbn, titulo, autor, año_publicacion)
    @isbn = isbn
    @titulo = titulo
    @autor = autor
    @año_publicacion = año_publicacion
    @disponible = true
    @ubicacion = "Estantería general"
  end
  
  def info_completa
    estado = @disponible ? "Disponible" : "Prestado"
    "#{@titulo} por #{@autor} (#{@año_publicacion}) - ISBN: #{@isbn} - #{estado}"
  end
  
  def prestar
    return "El libro ya está prestado" unless @disponible
    @disponible = false
    "Libro '#{@titulo}' prestado exitosamente"
  end
  
  def devolver
    return "El libro no estaba prestado" if @disponible
    @disponible = true
    "Libro '#{@titulo}' devuelto exitosamente"
  end
end

class Usuario
  attr_reader :id, :nombre, :libros_prestados
  
  def initialize(nombre)
    @id = self.class.generar_id
    @nombre = nombre
    @libros_prestados = []
    @fecha_registro = Time.now
  end
  
  def prestar_libro(libro)
    return "El usuario ya tiene 3 libros prestados" if @libros_prestados.length >= 3
    
    resultado = libro.prestar
    if resultado.include?("exitosamente")
      @libros_prestados << libro
    end
    resultado
  end
  
  def devolver_libro(libro)
    return "El usuario no tiene este libro" unless @libros_prestados.include?(libro)
    
    resultado = libro.devolver
    if resultado.include?("exitosamente")
      @libros_prestados.delete(libro)
    end
    resultado
  end
  
  def info_usuario
    info = "Usuario: #{@nombre} (ID: #{@id})\n"
    info += "Libros prestados: #{@libros_prestados.length}\n"
    if @libros_prestados.any?
      info += "Títulos:\n"
      @libros_prestados.each { |libro| info += "  - #{libro.titulo}\n" }
    end
    info
  end
  
  private
  
  def self.generar_id
    @@contador_id ||= 0
    @@contador_id += 1
    "USER-#{@@contador_id.to_s.rjust(4, '0')}"
  end
end

class Biblioteca
  def initialize(nombre)
    @nombre = nombre
    @libros = []
    @usuarios = []
  end
  
  def agregar_libro(libro)
    @libros << libro
    "Libro '#{libro.titulo}' agregado a la biblioteca"
  end
  
  def registrar_usuario(usuario)
    @usuarios << usuario
    "Usuario '#{usuario.nombre}' registrado en la biblioteca"
  end
  
  def buscar_libro(termino)
    encontrados = @libros.select do |libro|
      libro.titulo.downcase.include?(termino.downcase) ||
      libro.autor.downcase.include?(termino.downcase)
    end
    
    if encontrados.any?
      "Libros encontrados:\n" + encontrados.map(&:info_completa).join("\n")
    else
      "No se encontraron libros con el término '#{termino}'"
    end
  end
  
  # A partir de acá para abajo es todo privado
  private
  def libros_disponibles
    disponibles = @libros.select(&:disponible)
    if disponibles.any?
      "Libros disponibles:\n" + disponibles.map(&:info_completa).join("\n")
    else
      "No hay libros disponibles"
    end
  end
  
  # Acá vuelve a ser público
  public 
  def estadisticas
    total_libros = @libros.length
    libros_prestados = @libros.count { |libro| !libro.disponible }
    
    "=== Estadísticas de #{@nombre} ===\n" +
    "Total de libros: #{total_libros}\n" +
    "Libros prestados: #{libros_prestados}\n" +
    "Libros disponibles: #{total_libros - libros_prestados}\n" +
    "Usuarios registrados: #{@usuarios.length}"
  end
end

# Uso del sistema
biblioteca = Biblioteca.new("Biblioteca Central")

# Crear libros
libro1 = Libro.new("978-1234567890", "El Quijote", "Miguel de Cervantes", 1605)
libro2 = Libro.new("978-0987654321", "Cien años de soledad", "Gabriel García Márquez", 1967)
libro3 = Libro.new("978-1111111111", "1984", "George Orwell", 1949)

# Agregar libros a la biblioteca
puts biblioteca.agregar_libro(libro1)
puts biblioteca.agregar_libro(libro2)
puts biblioteca.agregar_libro(libro3)

# Crear usuarios
usuario1 = Usuario.new("Ana García")
usuario2 = Usuario.new("Luis Martín")

# Registrar usuarios
puts biblioteca.registrar_usuario(usuario1)
puts biblioteca.registrar_usuario(usuario2)

# Prestar libros
puts usuario1.prestar_libro(libro1)
puts usuario1.prestar_libro(libro2)

# Mostrar información
puts "\n" + usuario1.info_usuario
puts biblioteca.estadisticas
puts "\n" + biblioteca.libros_disponibles
```

## 💡 Mejores Prácticas para Clases y Objetos

1. **Naming conventions**:
   - Clases: `PascalCase` (ej: `MiClase`)
   - Métodos y variables: `snake_case` (ej: `mi_metodo`)
   - Constantes: `SCREAMING_SNAKE_CASE` (ej: `MI_CONSTANTE`)

2. **Responsabilidad única**: Cada clase debe tener una responsabilidad clara

3. **Encapsulación**: Usa `private` y `protected` apropiadamente

4. **DRY (Don't Repeat Yourself)**: Usa herencia para evitar código duplicado

5. **Tell, don't ask**: Los objetos deben hacer cosas, no solo guardar datos

6. **Usar attr_accessor apropiadamente**: No expongas todas las variables de instancia

¡Continúa con el siguiente archivo para aprender sobre mixins y módulos!
