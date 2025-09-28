class PartialBlock do # Bloque que al llamarlo se ejecuta si los tipos son los que esperabas
  # Recibe un parámetro y el bloque que todo método puede manejar
  # El types siempre se manda, recibe basura o no, solo tengo que checkear el "tipo"
  # El bloque es opcional
    def initialize(types, &block) 
      @types = types # Los tipos deben ser la misma cantidad que lo que sea que está esperando el bloque
      @block = block if block_given?
      raise ArgumentError.new if types.size != block.arity # Checkeo que la cantidad de argumentos que recibe el bloque sea la misma que la lista de tipos
    end

    # Verifica que la cantidad y tipo de los parámetros coincide con la lista y tipos con los que se creó la clase
    def matches?(*parameters) # El * hace referencia a un var args, tantos como se quiera. 
      #Adentro del método parameters es una lista
      # [1,2,3].zip(["a","b"]) => [[1,"a"],[2,"b"],[3,nil]]
      parameters.size == @types.size
      parameters.zip(@types).all? do |parameter, type|
        parameter.is_a? type 
      end
    end

    # Si call tiene que usar matches, llamarlo desde call, no darle esa responsabilidad al usuario
    def call(*parameters)
      raise ArgumentError.new unless matches?(*parameter)
      @block.call(*parameters) # *parameters para que reciba los múltiples parámetros, sino recibe 1 parametro (una lista)
    end

    def call_in_context(context, *parameters)
      context.instance_exec(*parameters, &@block) # Instance exec porque me deja pasar parametros (eval no) y usar el contexto (call no)
    end
end

# Ahora buscamos hacer algo como esto, una definición parcial:

# ------------------------------------------------------------
hola # Si pongo hola acá esto es equivalente a acceder a una variable o un envio de mensaje
# en este caso, si no es variable: self.hola osea main.hola
class A
  # self.partial_def (parametro1(symbol), parametro2(lista), bloque)
  # esto en el contexto de la clase A
  # self es la clase
  partial_def :concat, [String, String] do |s1,s2|
    # Acá todavía la instancia no existe
    s1 + s2
  end

  # Cada nuevo def no pisa, se concatena, permite tener múltiples definiciones
  partial_def :concat, [String, Integer] do |s1,n|
    s1 * n
  end

  partial_def :concat, [Array] do |a|
    a.join
  end
end
# ------------------------------------------------------------
# No lo encaramos con method_missing porque conozco cuál es el nombre del método. Method_missing es cuando no sé
# ¿Quienes deben entender? Todas las clases y los módulos. (Necesito concer el metamodelo)
# ... -> Class -> Module -> Object X 
# Si se lo pongo a Object lo entenderían todos, inclusive, por ejemplo, el nro 7
# Por ende debería agregarselo al Module
# ENCONTRAR EL LUGAR DONDE PONER EL MÉTODO PARA QUE SOLO LO TENGAN LOS QUE LO NECESITAN

# Esto es bastante hostil, en lugar de progrmarlo así podría hacer un mixin
class Module
  def partial_def(symbol, types)

  end
end

# Opción más configurable
module WithPartialBlocks
  # Necesito que la clase a la que se le puso partial_def entienda el método (method_name)
    # Vamos a guardar en alguna estructura el method_name con los argumentos (types) y el bloque asociado


    # También necesito que la clase entienda el método method_name, esto lo puedo hacer con
    #   1. Define method  -> Es más cercano a la forma tradicional de programar
    #   2. Method missing -> Está cambiando la naturaleza, interfaces infinitas a las clases, todos los modulos las tienen. Es innecesario,
    #      method_missing no me dice la interfaz.
    # Cuanto menos me aleje de la forma normal de programar, mejor. 
  def partial_def(method_name, types, &block) # Se comporta como un def en la clase hace aparecer un método que hace el cacho de código que fue asociado
    partial_block = PartialBlock.new(types, &block)
    define_method(method_name) do |*parameters|
      partial_block.call(*parameters)
    end
  end
  # Esto está bien, pero al funcionar como un def, no está guardando las distintas definiciones y permitiendo elegir dependiendo los parámetros
  # ESTO está pisando las definiciones que tengan el mismo nombre. Al llamar, se ejecuta la última definición.

  def partial_def(method_name, types, &block) # Esto se llama cuando se define la clase
    attr_reader :multimethods

    @multimethods || = {}
    @multimethods [method_name]||  = {} # Si la lista asociada al nombre no está la agrego
    @multimethods[method_name].push(partial_block = PartialBlock.new(types, &block))
    # self es un module aca

    # A partir de acá cambia el contexto. El SELF del bloque depende de quién lo ejecuta, al bloque se le puede cambiar el contexto
    define_method(method_name) do |*parameters| # Este bloque se llama cuando alguien le manda el mensaje method_name a una instancia de esa clase
      # Puede pasar mucho tiempo desde que ascié el método a la clase, hasta que llaman a ese mensaje
      # CAMBIO DE SELF -> self es una instancia del module que provee multimethod
      # quien define self es a quien le das el método. 
      partial_blocks = self.class.multimethods[method_name] # Encuentro la lista asociada a ese nombre en la clase
      partial_block = partial_blocks.find(proc { raise NoMethodError.new }) 
        { |partial_block| partial_block.matches?(*parameters) }# Encuentro de los partial blocks, el que matchea con los parámetros
      partial_block.call_in_context(self, *parameters) # Llamo a ese método, partial_block necesita la referencia al self instancia de la clase
    end
  end
end

class Module
  include WithPartialBlocks
end

######################################## CAMBIOS TP INDIVIDUAL ########################################
# Ahora no solo quiero que se reciba el tipo sino también un objeto que pueda responder a ciertos mensajes (una interfaz)
class PartialBlock do 
    def initialize(types, &block) 
      @types = types 
      @block = block if block_given?
      raise ArgumentError.new if types.size != block.arity
    end

    def matches?(*parameters) 
      parameters.size == @types.size
      parameters.zip(@types).all? do |parameter, type|
        if type.is_a? Module # caso donde es un tipo
          parameter.is_a? type

        else
          type.all? { |method_name| parameter.respond_to?(method_name) }
      end
    end

    def call(*parameters)
      raise ArgumentError.new unless matches?(*parameter)
      @block.call(*parameters) 
    end

    def call_in_context(context, *parameters)
      context.instance_exec(*parameters, &@block)
    end
end