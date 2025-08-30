# 04 - Métodos y Funciones

## 🔧 Definición Básica de Métodos

### Sintaxis Básica
```ruby
# Método simple sin parámetros
def saludar
  puts "¡Hola mundo!"
end

# Llamar al método
saludar  # ¡Hola mundo!

# Método con parámetros
def saludar_persona(nombre)
  puts "¡Hola, #{nombre}!"
end

saludar_persona("Ana")  # ¡Hola, Ana!

# Método con valor de retorno
def sumar(a, b)
  a + b  # Ruby retorna automáticamente la última expresión
end

resultado = sumar(5, 3)  # 8
```

### Valores de Retorno
```ruby
# Retorno implícito (más común en Ruby)
def multiplicar(a, b)
  a * b  # Se retorna automáticamente
end

# Retorno explícito
def dividir(a, b)
  return "Error: División por cero" if b == 0
  a / b
end

# Método que retorna múltiples valores
def operaciones(a, b)
  [a + b, a - b, a * b, a / b]
end

suma, resta, mult, div = operaciones(10, 2)
```

## 📝 Parámetros y Argumentos

### Parámetros Opcionales (con valores por defecto)
```ruby
def saludar(nombre, apellido = "")
  if apellido.empty?
    "Hola, #{nombre}"
  else
    "Hola, #{nombre} #{apellido}"
  end
end

puts saludar("Ana")              # "Hola, Ana"
puts saludar("Ana", "García")    # "Hola, Ana García"

# Múltiples parámetros opcionales
def crear_perfil(nombre, edad = 18, ciudad = "No especificada")
  "#{nombre}, #{edad} años, vive en #{ciudad}"
end

puts crear_perfil("Luis")                    # "Luis, 18 años, vive en No especificada"
puts crear_perfil("Luis", 25)                # "Luis, 25 años, vive en No especificada"
puts crear_perfil("Luis", 25, "Madrid")      # "Luis, 25 años, vive en Madrid"
```

### Parámetros Variables (*args)
```ruby
# Método que acepta cualquier cantidad de argumentos
def sumar_todos(*numeros)
  numeros.sum
end

puts sumar_todos(1, 2, 3)           # 6
puts sumar_todos(1, 2, 3, 4, 5)     # 15

# Combinando parámetros normales con variables
def presentar(nombre, *apellidos)
  apellidos_str = apellidos.join(" ")
  "Me llamo #{nombre} #{apellidos_str}"
end

puts presentar("Ana", "García", "López")  # "Me llamo Ana García López"

# Parámetros con nombre (keyword arguments)
def crear_usuario(nombre:, email:, edad: 18, activo: true)
  {
    nombre: nombre,
    email: email,
    edad: edad,
    activo: activo
  }
end

usuario = crear_usuario(nombre: "Pedro", email: "pedro@email.com")
puts usuario  # {:nombre=>"Pedro", :email=>"pedro@email.com", :edad=>18, :activo=>true}

# Keyword arguments variables (**kwargs)
def configurar(**opciones)
  opciones.each { |clave, valor| puts "#{clave}: #{valor}" }
end

configurar(host: "localhost", puerto: 3000, debug: true)
```

### Métodos con Bloques
```ruby
# Método que acepta un bloque
def procesar_numeros(array)
  resultado = []
  array.each do |numero|
    if block_given?  # Verificar si se pasó un bloque
      resultado << yield(numero)  # yield ejecuta el bloque
    else
      resultado << numero
    end
  end
  resultado
end

numeros = [1, 2, 3, 4, 5]

# Sin bloque
puts procesar_numeros(numeros)  # [1, 2, 3, 4, 5]

# Con bloque
cuadrados = procesar_numeros(numeros) { |n| n ** 2 }
puts cuadrados  # [1, 4, 9, 16, 25]

# Método más sofisticado con bloques
def medir_tiempo
  inicio = Time.now
  resultado = yield if block_given?
  fin = Time.now
  puts "Tiempo transcurrido: #{fin - inicio} segundos"
  resultado
end

resultado = medir_tiempo do
  (1..1000000).sum
end
```

## 🎭 Métodos Especiales

### Métodos de Predicado (terminan en ?)
```ruby
def par?(numero)
  numero.even?
end

def vacio?(array)
  array.empty?
end

def adulto?(edad)
  edad >= 18
end

puts par?(4)        # true
puts vacio?([])     # true
puts adulto?(17)    # false
```

### Métodos Destructivos (terminan en !)
```ruby
def procesar_texto(texto)
  texto.upcase  # No modifica el original
end

def procesar_texto!(texto)
  texto.upcase!  # Modifica el original
end

original = "hola mundo"
copia = procesar_texto(original)
puts original  # "hola mundo" (sin cambios)
puts copia     # "HOLA MUNDO"

texto = "hola mundo"
procesar_texto!(texto)
puts texto     # "HOLA MUNDO" (modificado)
```

## 🔍 Scope y Variables

### Variables Locales en Métodos
```ruby
variable_global = "global"

def ejemplo_scope
  variable_local = "local en método"
  puts variable_local
  # puts variable_global  # Error: variable no definida en este scope
end

ejemplo_scope  # "local en método"
# puts variable_local  # Error: variable no definida fuera del método
```

### Métodos que Modifican el Estado
```ruby
class Contador
  def initialize
    @valor = 0  # Variable de instancia
  end
  
  def incrementar(cantidad = 1)
    @valor += cantidad
  end
  
  def valor
    @valor
  end
  
  def reset!
    @valor = 0
  end
end

contador = Contador.new
contador.incrementar(5)
puts contador.valor     # 5
contador.reset!
puts contador.valor     # 0
```

## 🎯 Ejemplos Prácticos

### 1. Calculadora Modular
```ruby
module Calculadora
  def self.sumar(*numeros)
    numeros.sum
  end
  
  def self.restar(a, b)
    a - b
  end
  
  def self.multiplicar(*numeros)
    numeros.reduce(1) { |producto, num| producto * num }
  end
  
  def self.dividir(a, b)
    return "Error: División por cero" if b == 0
    a.to_f / b
  end
  
  def self.potencia(base, exponente = 2)
    base ** exponente
  end
  
  def self.operacion_compleja(a, b)
    resultado = yield(a, b) if block_given?
    "Resultado: #{resultado}"
  end
end

# Uso
puts Calculadora.sumar(1, 2, 3, 4)           # 10
puts Calculadora.multiplicar(2, 3, 4)        # 24
puts Calculadora.potencia(5)                 # 25
puts Calculadora.potencia(2, 8)              # 256

# Con bloque
puts Calculadora.operacion_compleja(10, 3) { |a, b| a % b }  # "Resultado: 1"
```

### 2. Validador de Datos
```ruby
module Validador
  def self.email_valido?(email)
    email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
  end
  
  def self.telefono_valido?(telefono)
    telefono.match?(/\A\d{3}-\d{3}-\d{4}\z/)
  end
  
  def self.edad_valida?(edad, minima: 0, maxima: 120)
    edad.between?(minima, maxima)
  end
  
  def self.validar_usuario(datos)
    errores = []
    
    errores << "Email inválido" unless email_valido?(datos[:email])
    errores << "Teléfono inválido" unless telefono_valido?(datos[:telefono])
    errores << "Edad inválida" unless edad_valida?(datos[:edad])
    
    if errores.empty?
      "Usuario válido"
    else
      "Errores: #{errores.join(', ')}"
    end
  end
end

# Pruebas
usuario = {
  email: "usuario@email.com",
  telefono: "123-456-7890",
  edad: 25
}

puts Validador.validar_usuario(usuario)  # "Usuario válido"

usuario_invalido = {
  email: "email_malo",
  telefono: "123456",
  edad: 150
}

puts Validador.validar_usuario(usuario_invalido)  # "Errores: Email inválido, Teléfono inválido, Edad inválida"
```

### 3. Generador de Reportes
```ruby
class GeneradorReportes
  def self.reporte_ventas(ventas, formato: :texto)
    case formato
    when :texto
      generar_reporte_texto(ventas)
    when :html
      generar_reporte_html(ventas)
    else
      "Formato no soportado"
    end
  end
  
  private
  
  def self.generar_reporte_texto(ventas)
    total = ventas.sum
    promedio = total.to_f / ventas.length
    
    reporte = "REPORTE DE VENTAS\n"
    reporte += "=" * 20 + "\n"
    reporte += "Total de ventas: #{ventas.length}\n"
    reporte += "Venta total: $#{total}\n"
    reporte += "Promedio: $#{promedio.round(2)}\n"
    reporte += "Venta máxima: $#{ventas.max}\n"
    reporte += "Venta mínima: $#{ventas.min}\n"
    
    reporte
  end
  
  def self.generar_reporte_html(ventas)
    total = ventas.sum
    promedio = total.to_f / ventas.length
    
    html = "<h2>Reporte de Ventas</h2>\n"
    html += "<ul>\n"
    html += "  <li>Total de ventas: #{ventas.length}</li>\n"
    html += "  <li>Venta total: $#{total}</li>\n"
    html += "  <li>Promedio: $#{promedio.round(2)}</li>\n"
    html += "  <li>Venta máxima: $#{ventas.max}</li>\n"
    html += "  <li>Venta mínima: $#{ventas.min}</li>\n"
    html += "</ul>\n"
    
    html
  end
end

ventas = [1500, 2300, 1800, 2750, 1200, 3100, 1900]

puts GeneradorReportes.reporte_ventas(ventas)
puts "\n" + "=" * 50 + "\n"
puts GeneradorReportes.reporte_ventas(ventas, formato: :html)
```

### 4. Sistema de Autenticación Simple
```ruby
class SistemaAuth
  @@usuarios = {}  # Variable de clase para almacenar usuarios
  
  def self.registrar_usuario(nombre, password, email: nil)
    return "Usuario ya existe" if @@usuarios.key?(nombre)
    return "Password muy corta" if password.length < 6
    
    @@usuarios[nombre] = {
      password: password,
      email: email,
      activo: true,
      ultimo_acceso: nil
    }
    
    "Usuario #{nombre} registrado exitosamente"
  end
  
  def self.autenticar(nombre, password)
    return false unless @@usuarios.key?(nombre)
    return false unless @@usuarios[nombre][:activo]
    
    if @@usuarios[nombre][:password] == password
      @@usuarios[nombre][:ultimo_acceso] = Time.now
      true
    else
      false
    end
  end
  
  def self.cambiar_password(nombre, password_actual, password_nueva)
    return "Usuario no encontrado" unless @@usuarios.key?(nombre)
    return "Password actual incorrecta" unless @@usuarios[nombre][:password] == password_actual
    return "Password nueva muy corta" if password_nueva.length < 6
    
    @@usuarios[nombre][:password] = password_nueva
    "Password cambiada exitosamente"
  end
  
  def self.info_usuario(nombre)
    return "Usuario no encontrado" unless @@usuarios.key?(nombre)
    
    usuario = @@usuarios[nombre]
    info = "Usuario: #{nombre}\n"
    info += "Email: #{usuario[:email] || 'No especificado'}\n"
    info += "Activo: #{usuario[:activo] ? 'Sí' : 'No'}\n"
    info += "Último acceso: #{usuario[:ultimo_acceso] || 'Nunca'}\n"
    
    info
  end
end

# Uso del sistema
puts SistemaAuth.registrar_usuario("ana", "password123", email: "ana@email.com")
puts SistemaAuth.registrar_usuario("luis", "123456")

puts SistemaAuth.autenticar("ana", "password123")  # true
puts SistemaAuth.autenticar("ana", "wrong")        # false

puts SistemaAuth.info_usuario("ana")
```

## 💡 Mejores Prácticas

1. **Usa nombres descriptivos** para métodos y parámetros
2. **Mantén métodos pequeños** - máximo 10-15 líneas idealmente
3. **Un método debe hacer una sola cosa**
4. **Usa ? para métodos que retornan boolean**
5. **Usa ! para métodos que modifican el objeto**
6. **Prefiere keyword arguments** para métodos con muchos parámetros
7. **Documenta métodos complejos** con comentarios
8. **Usa yield y bloques** para hacer métodos más flexibles

¡Continúa con el siguiente archivo para aprender sobre clases y objetos!
