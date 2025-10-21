require_relative './tag'

class TagGenerator
  def initialize
    @current_tag = nil
    @root = nil
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

  def createTag(&block)
    instance_eval(&block) if block
    @root
  end

  ## Refactor serialize
  def getClassAnnotations(object)
    class_ann = object.class.instance_variable_get(:@class_annotations) || []
  end

  def getMethodsAnnotations(object)
    method_ann = object.class.instance_variable_get(:@method_annotations) || {}
  end

  def manageLabelAnnotationInClass(class_ann, object)
    annotation_label = class_ann.find { |ann| ann.is_a?(Label) }
    nombre = annotation_label ? annotation_label.nuevoLabel : object.class.name.downcase # TODO: Contemplar el caso de que dos atributos queden con el mismo nombre
    tag = Tag.with_label(nombre) 
    tag
  end

  def getAttributesModifiedByLabel()
  end
  
  def serialize(object)
    classAnnotations = getClassAnnotations(object)
    # Si alguna de las Annotations de la clase es Ignore no se serializa, entonces retorno nil.
    return nil if class_ann.any? { |ann| ann.is_a?(Ignore) } # TODO: Deberia devolver vacío
    
    tag = manageLabelAnnotationInClass(class_ann, object)
    
    method_ann = getMethodsAnnotations(object)

    atributos_validos = object.instance_variables.map { |atr| atr.to_s.delete('@') }
 
    # Filtrar los que no tienen ignore
    atributos_filtrados = atributos_validos.filter do |attr|
      !(method_ann[attr.to_sym]&.any? { |ann| ann.is_a?(Ignore) }) # el & devuelve nil si el objeto es nil, sino es nil el objeto llama al metodo
    end # el & hace que si method_ann[attr.to_sym] es nil devuelve nil 


    atributos_a_serializar = atributos_filtrados.filter do |attr_name|
      object.respond_to?(attr_name)
    end
    
    
    atributos_modificados_por_label = atributos_a_serializar.map do |attr_name|
      anns = method_ann[attr_name.to_sym] || []
      if anns.count { |a| a.is_a?(Label) } > 1
        raise "Error: no puedes ponerle mas de una Label annotation a un atributo"
      end
      label_ann = anns.find { |a| a.is_a?(Label) }
      nombre_posta = label_ann ? label_ann.nuevoLabel : attr_name
      nombre_posta
    end
    
    verifyRepetition(atributos_modificados_por_label)

    atributos_modificados_por_label.each do |attr_name|
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
    tag
  end

  def verifyRepetition(attributes)
    raise "Annotations duplicadas encontradas" if attributes.uniq.size != attributes.size
  end
end