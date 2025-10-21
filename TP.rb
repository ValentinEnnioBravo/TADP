require_relative 'annotations'
class String
  def red;    "\033[31m#{self}\033[0m"; end
  def green;  "\033[32m#{self}\033[0m"; end
  def yellow; "\033[33m#{self}\033[0m"; end
  def blue;   "\033[34m#{self}\033[0m"; end
  def bold;   "\033[1m#{self}\033[0m"; end
end


class Tag
  attr_reader :label, :attributes, :children

  def self.with_label(label)
    new(label)
  end

  def initialize(label)
    @label = label
    @attributes = {}
    @children = []
  end

  def with_label(label)
    @label = label
    self
  end

  def with_attribute(label, value)
    @attributes[label] = value
    self
  end

  def with_child(child)
    @children << child
    self
  end

  def xml(level=0)
    if children.empty?
      "#{"\t" * level}<#{label}#{xml_attributes}/>"
    else
      "#{"\t" * level}<#{label}#{xml_attributes}>\n#{xml_children(level + 1)}\n#{"\t" * level}</#{label}>"
    end
  end

  private

  def xml_children(level)
    self.children.map do |child|
      if child.is_a? Tag
        child.xml(level)
      else
        xml_value(child, level)
      end
    end.join("\n")
  end

  def xml_attributes
    self.attributes.map do |name, value|
      "#{name}=#{xml_value(value, 0)}"
    end.xml_join(' ')
  end

  def xml_value(value, level)
    "\t" * level + if value.is_a? String
      "\"#{value}\""
    else
      value.to_s
    end
  end
end

class Array
  def xml_join(separator)
    self.join(separator).instance_eval do
      if !empty?
        "#{separator}#{self}"
      else
        self
      end
    end
  end
end

class TagGenerator
  def initialize
    @current_tag = nil
    @root = nil
  end

  def createTag(&block)
    instance_eval(&block) if block
    @root
  end

  def serialize(object)
    annotations = object.class.instance_variable_get(:@annotations) || []
    annotation_label = annotations.find { |etiqueta| etiqueta.is_a?(Label)}
    nombre = if annotation_label
                annotation_label.nuevoLabel
            else 
              object.class.name.downcase
            end

    #nombre = object.class.name.downcase

    tag = Tag.with_label(nombre)

    object.instance_variables.each do |key|
      attr_name = key.to_s.delete('@')  # Quito el @ a todas los atributos
        
      if object.respond_to?(attr_name) # Consulto al objeto si responde al atributo (si tiene getter)
        value = object.send(attr_name)

        case value
          when String, Numeric, NilClass, TrueClass, FalseClass
            tag.with_attribute(attr_name, value)
          when Array 
            value.each { |child| tag.with_child(serialize(child))}
          else
            tag.with_child(serialize(value))
        end
      end
    end
    tag
  end

  def method_missing(symbol, *args, &block)
    tag = Tag.with_label(symbol.to_s)

    if args.first
      args.first.each do |clave, valor| 
        tag.with_attribute(clave, valor)
      end
    end

    @root ||= tag

    if @current_tag
      @current_tag.with_child(tag)
    end

    if block
      prev = @current_tag
      @current_tag = tag

      result = instance_eval(&block)

      if result && !result.is_a?(Tag)
        tag.with_child(result)
      end
      @current_tag = prev
    end

    tag
  end
end

class Document 
  attr_reader :root
  def initialize(object=nil, &block_definition)
    tagGenerator = TagGenerator.new
    
    if block_definition
      @root = tagGenerator.createTag(&block_definition)
    else 
      @root = tagGenerator.serialize(object)
    end
  end

  def xml()
    puts @root.xml
    @root.xml
  end

  def self.serialize(object)
    Document.new object
  end
end

################################################################################ 3 ################################################################################
class AnnotationManager
  @@pendientes = []

  def self.pendientes
    @@pendientes
  end

  def self.resetPendientes
    @@pendientes = []
  end
  
  def self.createAnnotation(annotation, *attr, &block)
    puts "LOGGER: Creando annotation #{annotation}".green
    annotation_name = annotation.to_s.delete("✨")

    begin
      puts "LOGGER: Buscando clase #{annotation_name}".green
      annotation_class = Object.const_get(annotation_name)
      puts "LOGGER: Encontrada clase #{annotation_class}".green
    rescue NameError => e
      raise "Annotation inexistente: " + annotation_name
    end
    
    # Crear la annotation
    puts "LOGGER: Instanciando annotation".green
    annotation = annotation_class.new(*attr, &block)
    puts "LOGGER: Annotation instanciada: #{annotation}".green

    puts "LOGGER: Guardando annotation en la lista".green
    @@pendientes << annotation
    puts "LOGGER: Annotation instanciada: #{@@pendientes}".green
  end
end

def method_missing(annotation, *attr, &block)
    if annotation.to_s.start_with?("✨") && annotation.to_s.end_with?("✨")
      puts "LOGGER: Method missing #{annotation}".green
      AnnotationManager.createAnnotation(annotation, *attr, &block)
    else
      super
    end
end

class Class
  def inherited(clase)
    puts "LOGGER: Definiendo clase #{clase}".green
    if AnnotationManager.pendientes && !AnnotationManager.pendientes.empty?
      puts "LOGGER: Seteando atributo label a clase #{clase}".green
      clase.instance_variable_set(:@annotations, AnnotationManager.pendientes)
      AnnotationManager.resetPendientes
    end
  end
end

class Object
  # Agregado
  def method_missing(annotation, *attr, &block)
    if annotation.to_s.start_with?("✨") && annotation.to_s.end_with?("✨")
      puts "LOGGER: Class Method missing #{annotation}".green
      AnnotationManager.createAnnotation(annotation, *attr, &block)
    else
      super
    end
  end
end

# no en Class, sino en Module, porque todos los métodos se definen dentro de un Module y Class hereda de Module
# Agregado
class Module
  def method_added(name)
    if AnnotationManager.pendientes && !AnnotationManager.pendientes.empty?
      self.instance_variable_set(:"@#{name}Annotations", AnnotationManager.pendientes)
      AnnotationManager.resetPendientes
    end
  end
end

✨Label✨("estudiante")
class Alumno
  attr_reader :nombre
  def initialize(nombre)
    @nombre = nombre
  end
  
  ✨Label✨
  def hola()
    puts "Hola"
  end
end

unAlumno = Alumno.new("alumno") 
puts "LOGGER: Alumno con annotations #{unAlumno.class.instance_variable_get(:@annotations)}".green
# Document.serialize(unAlumno).xml