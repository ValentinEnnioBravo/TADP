# 06 - Mixins y Módulos

## 📦 ¿Qué son los Módulos?

Los módulos en Ruby sirven para dos propósitos principales:
1. **Namespaces** - Agrupar clases y métodos relacionados
2. **Mixins** - Compartir código entre clases sin herencia

```ruby
# Módulo básico
module Saludos
  def decir_hola
    "¡Hola!"
  end
  
  def decir_adios
    "¡Adiós!"
  end
end

# Los módulos no se pueden instanciar directamente
# saludos = Saludos.new  # Error!
```

## 🎭 Mixins con Include

### Include - Agregar métodos de instancia
```ruby
module Habilidades
  def caminar
    "#{self.class} está caminando 🚶"
  end
  
  def correr
    "#{self.class} está corriendo 🏃"
  end
  
  def velocidad_maxima
    "Velocidad máxima: 30 km/h"
  end
end

class Persona
  include Habilidades  # Incluir el módulo
  
  attr_accessor :nombre
  
  def initialize(nombre)
    @nombre = nombre
  end
  
  def presentarse
    "Soy #{@nombre}"
  end
end

class Robot
  include Habilidades  # El mismo módulo en otra clase
  
  attr_accessor :modelo
  
  def initialize(modelo)
    @modelo = modelo
  end
  
  # Sobrescribir método del módulo
  def velocidad_maxima
    "Velocidad máxima: 100 km/h"
  end
end

# Uso
persona = Persona.new("Ana")
robot = Robot.new("R2D2")

puts persona.presentarse    # "Soy Ana"
puts persona.caminar       # "Persona está caminando 🚶"
puts persona.correr        # "Persona está corriendo 🏃"

puts robot.caminar         # "Robot está caminando 🚶"
puts robot.velocidad_maxima # "Velocidad máxima: 100 km/h"
```

## 🏗 Extend - Agregar métodos de clase

```ruby
module Utilidades
  def formatear_fecha(fecha)
    fecha.strftime("%d/%m/%Y")
  end
  
  def generar_id
    "ID-#{rand(10000..99999)}"
  end
end

class Documento
  extend Utilidades  # Extend agrega métodos a la clase, no a las instancias
  
  attr_reader :titulo, :fecha_creacion, :id
  
  def initialize(titulo)
    @titulo = titulo
    @fecha_creacion = Time.now
    @id = self.class.generar_id  # Llamar método de clase
  end
  
  def info
    fecha_formateada = self.class.formatear_fecha(@fecha_creacion)
    "#{@titulo} (#{@id}) - Creado: #{fecha_formateada}"
  end
end

# Uso
documento = Documento.new("Mi Documento")
puts documento.info

# Los métodos están disponibles en la clase
puts Documento.formatear_fecha(Time.now)
puts Documento.generar_id

# documento.generar_id  # Error! No está en las instancias
```

## 🔍 Include vs Extend vs Prepend

```ruby
module MiModulo
  def saludar
    "Hola desde el módulo"
  end
end

class MiClase
  def saludar
    "Hola desde la clase"
  end
end

# === INCLUDE ===
class ConInclude < MiClase
  include MiModulo
end

obj_include = ConInclude.new
puts obj_include.saludar  # "Hola desde la clase" (la clase tiene prioridad)

# === PREPEND ===
class ConPrepend < MiClase
  prepend MiModulo  # Prepend da prioridad al módulo
end

obj_prepend = ConPrepend.new
puts obj_prepend.saludar  # "Hola desde el módulo" (el módulo tiene prioridad)

# === EXTEND ===
class ConExtend < MiClase
  extend MiModulo  # Los métodos van a la clase, no a las instancias
end

puts ConExtend.saludar   # "Hola desde el módulo"
# ConExtend.new.saludar  # Error! No está en las instancias

# Verificar la cadena de herencia
puts ConInclude.ancestors  # [ConInclude, MiModulo, MiClase, Object, ...]
puts ConPrepend.ancestors  # [ConPrepend, MiModulo, MiClase, Object, ...]
```

## 🏛 Namespaces - Organizar Código

```ruby
# Definir un namespace
module Geometria
  PI = 3.14159
  
  module Figuras2D
    class Circulo
      attr_reader :radio
      
      def initialize(radio)
        @radio = radio
      end
      
      def area
        Geometria::PI * @radio ** 2
      end
      
      def perimetro
        2 * Geometria::PI * @radio
      end
    end
    
    class Rectangulo
      attr_reader :ancho, :alto
      
      def initialize(ancho, alto)
        @ancho = ancho
        @alto = alto
      end
      
      def area
        @ancho * @alto
      end
      
      def perimetro
        2 * (@ancho + @alto)
      end
    end
  end
  
  module Figuras3D
    class Esfera
      attr_reader :radio
      
      def initialize(radio)
        @radio = radio
      end
      
      def volumen
        (4.0/3) * Geometria::PI * @radio ** 3
      end
      
      def superficie
        4 * Geometria::PI * @radio ** 2
      end
    end
  end
  
  # Métodos del módulo principal
  def self.convertir_grados_a_radianes(grados)
    grados * PI / 180
  end
end

# Uso de namespaces
circulo = Geometria::Figuras2D::Circulo.new(5)
puts "Área del círculo: #{circulo.area}"

rectangulo = Geometria::Figuras2D::Rectangulo.new(4, 6)
puts "Área del rectángulo: #{rectangulo.area}"

esfera = Geometria::Figuras3D::Esfera.new(3)
puts "Volumen de la esfera: #{esfera.volumen}"

# Acceder a constantes y métodos del módulo
puts "PI: #{Geometria::PI}"
puts "45 grados en radianes: #{Geometria.convertir_grados_a_radianes(45)}"
```

## 🔧 Module Callbacks y Hooks

```ruby
module Rastreable
  # Hook que se ejecuta cuando el módulo es incluido
  def self.included(clase)
    puts "#{self} fue incluido en #{clase}"
    clase.extend(MetodosDeClase)
  end
  
  # Hook que se ejecuta cuando el módulo es extendido
  def self.extended(objeto)
    puts "#{self} fue extendido en #{objeto}"
  end
  
  # Métodos de instancia
  def rastrear_accion(accion)
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    puts "[#{timestamp}] #{self.class}: #{accion}"
  end
  
  # Módulo anidado con métodos de clase
  module MetodosDeClase
    def objetos_rastreables
      @objetos_rastreables ||= []
    end
    
    def registrar_objeto(objeto)
      objetos_rastreables << objeto
    end
  end
end

class Usuario
  include Rastreable
  
  attr_reader :nombre
  
  def initialize(nombre)
    @nombre = nombre
    self.class.registrar_objeto(self)
    rastrear_accion("Usuario creado: #{@nombre}")
  end
  
  def login
    rastrear_accion("#{@nombre} hizo login")
  end
  
  def logout
    rastrear_accion("#{@nombre} hizo logout")
  end
end

# Uso
usuario1 = Usuario.new("Ana")
usuario2 = Usuario.new("Luis")

usuario1.login
usuario2.login
usuario1.logout

puts "Usuarios registrados: #{Usuario.objetos_rastreables.length}"
```

## 🎯 Ejemplos Prácticos Avanzados

### 1. Sistema de Autenticación con Módulos
```ruby
module Autenticable
  def self.included(clase)
    clase.extend(MetodosDeClase)
  end
  
  module MetodosDeClase
    def autenticar(email, password)
      usuario = encontrar_por_email(email)
      return nil unless usuario
      
      if usuario.password_valida?(password)
        usuario.actualizar_ultimo_acceso
        usuario
      else
        nil
      end
    end
    
    def encontrar_por_email(email)
      @usuarios ||= []
      @usuarios.find { |usuario| usuario.email == email }
    end
    
    def registrar_usuario(usuario)
      @usuarios ||= []
      @usuarios << usuario
    end
  end
  
  def password_valida?(password)
    @password == hash_password(password)
  end
  
  def cambiar_password(password_actual, password_nueva)
    return false unless password_valida?(password_actual)
    
    @password = hash_password(password_nueva)
    true
  end
  
  def actualizar_ultimo_acceso
    @ultimo_acceso = Time.now
  end
  
  private
  
  def hash_password(password)
    # En una aplicación real usarías bcrypt u otro algoritmo seguro
    password.reverse + "salt123"
  end
end

module Autorizable
  ROLES = {
    admin: [:leer, :escribir, :eliminar, :administrar],
    editor: [:leer, :escribir],
    viewer: [:leer]
  }.freeze
  
  def asignar_rol(rol)
    @rol = rol if ROLES.key?(rol)
  end
  
  def tiene_permiso?(accion)
    return false unless @rol
    ROLES[@rol].include?(accion)
  end
  
  def puede_leer?
    tiene_permiso?(:leer)
  end
  
  def puede_escribir?
    tiene_permiso?(:escribir)
  end
  
  def puede_eliminar?
    tiene_permiso?(:eliminar)
  end
  
  def es_admin?
    @rol == :admin
  end
end

class Usuario
  include Autenticable
  include Autorizable
  
  attr_reader :email, :nombre, :ultimo_acceso, :rol
  
  def initialize(email, nombre, password, rol = :viewer)
    @email = email
    @nombre = nombre
    @password = hash_password(password)
    @ultimo_acceso = nil
    asignar_rol(rol)
    
    self.class.registrar_usuario(self)
  end
  
  def perfil
    ultimo_acceso_str = @ultimo_acceso ? @ultimo_acceso.strftime("%Y-%m-%d %H:%M") : "Nunca"
    
    "Usuario: #{@nombre}\n" +
    "Email: #{@email}\n" +
    "Rol: #{@rol}\n" +
    "Último acceso: #{ultimo_acceso_str}\n" +
    "Permisos: #{ROLES[@rol].join(', ')}"
  end
end

# Uso del sistema
admin = Usuario.new("admin@email.com", "Administrador", "admin123", :admin)
editor = Usuario.new("editor@email.com", "Editor", "edit123", :editor)
viewer = Usuario.new("viewer@email.com", "Viewer", "view123", :viewer)

# Autenticación
puts "=== AUTENTICACIÓN ==="
usuario_autenticado = Usuario.autenticar("admin@email.com", "admin123")
if usuario_autenticado
  puts "✅ Login exitoso"
  puts usuario_autenticado.perfil
else
  puts "❌ Login fallido"
end

# Autorización
puts "\n=== AUTORIZACIÓN ==="
puts "¿Admin puede eliminar? #{admin.puede_eliminar?}"    # true
puts "¿Editor puede eliminar? #{editor.puede_eliminar?}"  # false
puts "¿Viewer puede escribir? #{viewer.puede_escribir?}"  # false
```

## 💡 Mejores Prácticas con Módulos

### 1. Naming Conventions
```ruby
# ✅ Buenas prácticas
module Comparable      # Adjetivos para comportamientos
module Enumerable     # Adjetivos para comportamientos
module MyApp          # Namespaces con sustantivos
module MyApp::Models  # Namespaces anidados

# ❌ Evitar
module ComparableMethods  # Redundante
module MyAppModule       # Redundante
```

### 2. Estructura de Módulos
```ruby
module MiBuenModulo
  # 1. Constantes primero
  VERSION = "1.0.0"
  
  # 2. Hooks y callbacks
  def self.included(clase)
    clase.extend(MetodosDeClase)
  end
  
  # 3. Métodos de instancia
  def metodo_instancia
    # implementación
  end
  
  # 4. Métodos privados
  private
  
  def metodo_privado
    # implementación
  end
  
  # 5. Módulos anidados al final
  module MetodosDeClase
    def metodo_de_clase
      # implementación
    end
  end
end
```

### 3. Cuándo usar Include vs Extend vs Prepend
- **Include**: Para agregar métodos de instancia (caso más común)
- **Extend**: Para agregar métodos de clase
- **Prepend**: Cuando necesitas que el módulo tenga prioridad sobre la clase

### 4. Evitar Conflictos de Nombres
```ruby
module MiApp
  module Utilities
    module StringHelpers
      def truncate(string, length)
        # implementación específica
      end
    end
  end
end

# Uso
class MiClase
  include MiApp::Utilities::StringHelpers
end
```

¡Continúa con el siguiente archivo para conceptos avanzados de Ruby!
