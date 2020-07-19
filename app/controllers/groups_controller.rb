class GroupsController < ApplicationController
  
  def index
    # 1.CONVERSION DE DATOS DEL MODELO PSICOSOCIAL
    require 'matrix'
    @sections_show = Section.all
    if params[:seccion] 
      @sections_show = [Section.find(params[:seccion])]
    end
    @grupos = []
    @section_title = []
    @status_seccion = ''
    if params[:porGrupo] &&  params[:porGrupo].to_i != 0
      @sections_show.each_with_index do |seccion, indice|
        #seccion = Section.first 
        estudiantes = seccion.users.where(rol: 3)
        @total_estudiantes = estudiantes.count
        @personas = []
        indexUser = 0
        @show = 0
        valido = true
        estudiantes.each do |e|
          if Test.exists?(user_id: e.id, kind: 1) 
            if e.tests.find(e.tests.where(kind: 1)).answered? && e.tests.find(e.tests.where(kind: 2)).answered? && e.tests.find(e.tests.where(kind: 3)).answered?
              @personas << e
              @show = 1
            end 
          end
        end 

        @Mp = Matrix.build(9, @personas.size){ 0 }
        @personas.each_with_index do |p, index|
          @Mp.send(:[]=, p.eneatype.number-1, index, 1)
        end

        @Mscod = Matrix.build(@personas.size, @personas.size){ '!!!!' }
        @personas.each_with_index do |p, index|
          positivo = p.tests.find(p.tests.where(kind: 2)).answers
          negativo = p.tests.find(p.tests.where(kind: 3)).answers
          
          positivo.each do |creeAceptacion|
            if creeAceptacion.answer == 0 # si cree
              @personas.each_with_index do |person, indexa|
                if person.id == creeAceptacion.number
                  indexUser = indexa
                end
              end
              if @Mscod[index, indexUser][@Mscod[index, indexUser].length-4] == '!'
                @Mscod.send(:[]=, index, indexUser, '(' + @Mscod[index, indexUser][1..3])
                @Mscod.send(:[]=, indexUser, index, '(' + @Mscod[index, indexUser][1..3])
              elsif @Mscod[index, indexUser][@Mscod[index, indexUser].length-1] == '!'
                @Mscod.send(:[]=, index, indexUser, @Mscod[index, indexUser][0..2] + ')')
                @Mscod.send(:[]=, indexUser, index, @Mscod[index, indexUser][0..2] + ')')
              end
            end
          end
        
          negativo.each do |creeRechazo|
            if creeRechazo.answer == 0 # no cree
              @personas.each_with_index do |person, index|
                if person.id == creeRechazo.number
                  indexUser = index
                end
              end
              if @Mscod[index, indexUser][@Mscod[index, indexUser].length-4] == '!'
                @Mscod.send(:[]=, index, indexUser, '[' + @Mscod[index, indexUser][1..3])
                @Mscod.send(:[]=, indexUser, index, '[' + @Mscod[index, indexUser][1..3])
              elsif @Mscod[index, indexUser][@Mscod[index, indexUser].length-1] == '!'
                @Mscod.send(:[]=, index, indexUser, @Mscod[index, indexUser][0..2] + ']')
                @Mscod.send(:[]=, indexUser, index, @Mscod[index, indexUser][0..2] + ']')
              end
            end
          end

          positivo.each do |creeAceptacion|
            if creeAceptacion.answer == 1 # si ELIGE
              @personas.each_with_index do |person, indexa|
                if person.id == creeAceptacion.number
                  indexUser = indexa
                end
              end
              if @Mscod[index, indexUser][@Mscod[index, indexUser].length-3] == '!'
                @Mscod.send(:[]=, index, indexUser, @Mscod[index, indexUser][0] + 'E' + @Mscod[index, indexUser][2..3])
                @Mscod.send(:[]=, indexUser, index, @Mscod[index, indexUser][0] + 'E' + @Mscod[index, indexUser][2..3])
              elsif @Mscod[index, indexUser][@Mscod[index, indexUser].length-2] == '!'
                @Mscod.send(:[]=, index, indexUser, @Mscod[index, indexUser][0..1] + 'e' + @Mscod[index, indexUser][3])
                @Mscod.send(:[]=, indexUser, index, @Mscod[index, indexUser][0..1] + 'e' + @Mscod[index, indexUser][3])
              end
            end
          end

          negativo.each do |creeRechazo|
            if creeRechazo.answer == 1 # no ELIGE
              @personas.each_with_index do |person, index|
                if person.id == creeRechazo.number
                  indexUser = index
                end
              end
              if @Mscod[index, indexUser][@Mscod[index, indexUser].length-3] == '!'
                @Mscod.send(:[]=, index, indexUser, @Mscod[index, indexUser][0] + 'R' + @Mscod[index, indexUser][2..3])
                @Mscod.send(:[]=, indexUser, index, @Mscod[index, indexUser][0] + 'R' + @Mscod[index, indexUser][2..3])
              elsif @Mscod[index, indexUser][@Mscod[index, indexUser].length-2] == '!'
                @Mscod.send(:[]=, index, indexUser, @Mscod[index, indexUser][0..1] + 'r' + @Mscod[index, indexUser][3])
                @Mscod.send(:[]=, indexUser, index, @Mscod[index, indexUser][0..1] + 'r' + @Mscod[index, indexUser][3])
              end
            end
          end
        end

        # Matriz de relaciones interpersonales (Mr)
        @Mr = Matrix[]
        @Mr = Matrix.rows(@Mr.to_a << [0,1,0,1,1,1,1,0,0])
        @Mr = Matrix.rows(@Mr.to_a << [1,1,1,1,1,0,1,1,0])
        @Mr = Matrix.rows(@Mr.to_a << [0,1,1,0,1,0,1,0,1])
        @Mr = Matrix.rows(@Mr.to_a << [1,1,0,1,0,0,0,1,0])
        @Mr = Matrix.rows(@Mr.to_a << [1,1,1,0,1,1,1,0,0])
        @Mr = Matrix.rows(@Mr.to_a << [1,0,0,0,1,0,1,0,1])
        @Mr = Matrix.rows(@Mr.to_a << [1,1,1,0,1,1,1,1,0])
        @Mr = Matrix.rows(@Mr.to_a << [0,1,0,1,0,0,1,0,1])
        @Mr = Matrix.rows(@Mr.to_a << [0,0,1,0,0,1,0,1,1])

        # Matriz eneagramatica Me = Mp^t(Mr*Mp)
        @Me = Matrix[]
        @Me = @Mp.transpose * (@Mr * @Mp)

        # Compatibilidad eneagramatica con uno mismo = 1
        for i in 1..@Me.row_size
          @Me.row(i-1).each_with_index do |e, index|
            if i-1 == index
              @Me.send(:[]=, i-1, index, 1)
            end
          end
        end

        # Matriz social decodificada
        @Ms = @Mscod.clone
        socioValor = 0.0
        for i in 1..@Ms.row_size
          @Ms.row(i-1).each_with_index do |e, index|
            if e[0] == '('
              socioValor = socioValor + 0.2
            elsif e[0] == '['
              socioValor = socioValor - 0.2
            end
            if e[1] == 'E'
              socioValor = socioValor + 0.3
            elsif e[1] == 'R'
              socioValor = socioValor - 0.3
            end
            if e[2] == 'e'
              socioValor = socioValor + 0.3
            elsif e[2] == 'r'
              socioValor = socioValor - 0.3
            end
            if e[3] == ')'
              socioValor = socioValor + 0.2
            elsif e[3] == ']'
            elsif i-1 == index
              socioValor = 1
            end

            # Normalización
            socioValor = (socioValor + 1)/2


            @Ms.send(:[]=, i-1, index, socioValor.round(3))
            socioValor = 0.0
            #if e == '(Ee)' || e == '-'
            #  @Ms.send(:[]=, i-1, index, 1)
            #elsif e == '(Ee!' || e == '!Ee)'
            #  @Ms.send(:[]=, i-1, index, 0.93)
            #elsif e == '!Ee!'
            #  @Ms.send(:[]=, i-1, index, 0.86)
            #elsif e == '[Ee!' || e == '!Ee]'
            #  @Ms.send(:[]=, i-1, index, 0.78)
            #elsif e == '[Ee]'
            #  @Ms.send(:[]=, i-1, index, 0.71)  
            #elsif e == '(Er)' || e == '(Re)'
            #  @Ms.send(:[]=, i-1, index, 0.64)
            #elsif e == '(Er!' || e == '!Er)' || e == '(Re!' || e == '!Re)'
            #  @Ms.send(:[]=, i-1, index, 0.57)
            #elsif e == '!Er!' || e == '!Re!'
            #  @Ms.send(:[]=, i-1, index, 0.5)
            # elsif e == '[Er!'   || e == '!Er]' || e == '[Re!' || e == '!Re]'
            #  @Ms.send(:[]=, i-1, index, 0.43)
            #elsif e == '[Er]' || e == '[Re]'
            #  @Ms.send(:[]=, i-1, index, 0.36)
            #elsif e == '(Rr)'
            #  @Ms.send(:[]=, i-1, index, 0.29)
            #elsif e == '(Rr!' || e == '!Rr)'
            #  @Ms.send(:[]=, i-1, index, 0.21)
            #elsif e == '!Rr!'
            #  @Ms.send(:[]=, i-1, index, 0.14)
            #elsif e == '[Rr!' || e == '!Rr]'
            #  @Ms.send(:[]=, i-1, index, 0.07)
            #elsif e == '[Rr]'
            #  @Ms.send(:[]=, i-1, index, 0)
            #elsif i-1 == index
            #  @Ms.send(:[]=, i-1, index, 1)
            #else
            #  @Ms.send(:[]=, i-1, index, 0)
            #end
          end
        end

        @program_matrix = Matrix.build(@personas.size) { 0 } 

        @personas.each_with_index do |p1, index1|
          @personas.each_with_index do |p2, index2|
            if p1.programs.first != p2.programs.first 
              @program_matrix.send(:[]=, index1, index2, 1)
            end
          end
        end
        puts "test: #{@program_matrix}"
        puts "Dims 1: #{@Me}"
        puts "Dims 2: #{@Ms}"
        # Matriz social codificada 
        @Mes = Matrix[]
        @Mes = @Me + @Ms + @program_matrix
        puts "Dims 3: #{@Ms}"
        @totalEstudiantes = @Mes.row_size
        # Correccion de decimales
        for i in 1..@Mes.row_size
          @Mes.row(i-1).each_with_index do |e, index|
            @Mes.send(:[]=, i-1, index, e.round(2))
          end
        end

        # 2.ALGORITMO GENETICO
        
        @Map        = @Mes.clone             # Matriz de aptitud
        min         = @Map.min               # Mínimo valor de la matriz enea-social
        max         = @Map.max               # Máximo valor de la matriz enea-social
        # Normalizar matriz de aptitud
        for i in 1..@Map.row_size
          @Map.row(i-1).each_with_index do |e, index|
            @Map.send(:[]=, i-1, index, ((e-min)/(max-min)).round(2))
          end
        end
          
         

        ################################













        # Parametros de entrada
        estudiantes    = @Map.row_size          # @Mes.row_size   # Total de estudiantes
        porGrupo       = params[:porGrupo].to_i # Cantidad de genes por cromosomas (o estudiantes por grupo)      
        generation     = 10                     # Generaciones o iteraciones del algoritmo
        guys           = 100                    # Población inicial de individuos
        n_children     = cantidad_hijos(guys)   # Cantidad de hijos (para la ruleta)
        p              = []                     # Población de individuos
        pt             = []                     # Promedio total medida de aptitud
        pi             = []                     # Promedio_por_individuo
        d              = []                     # Fitness por individuo
        f              = []                     # Selección para ruleta
        solutions      = []                     # Soluciones guardadas por generación
        d_solutions    = []                     # Soluciones fitness guardadas por generación
        p_children     = []                     # Población de hijos
        p_children_fix = []                     # Población de hijos fixiada
        # Parametros contruidos
        grupos      = estudiantes/porGrupo
        residuo     = estudiantes%porGrupo
        # Auxiliares
        porGrupoAux = porGrupo
        totalAux    = estudiantes

        if residuo > grupos
          grupos += 1
        end

        if porGrupo - residuo == 1 || residuo < grupos
          valido = true
        else
          valido = false
        end

        if estudiantes > 0 && 100*porGrupo/estudiantes <= 60 && porGrupo >= 3 && estudiantes > 2 && valido == true 
          if estudiantes.round(2)/porGrupo.round(2) > grupos
            porGrupo += 1
          end

          # Genera individuos aleatorios de la población
          p = generar_Individuos(guys, grupos, porGrupo, estudiantes,totalAux).clone
          ##puts " "
          ##puts "1. Población inicial:"
          ##for j in 1..guys
          ##  for i in 1..p[j-1].row_size
          ##    aux = ''
          ##    p[j-1].row(i-1).each do |e|
          ##      aux = aux + " " + e.to_s
          ##    end
          ##    puts aux.to_s
          ##  end
          ##    puts " "
          ##end

          for x in 1..generation
            # Calcular promedio de los atributos (PT) de la medida de aptitud
            # @Map y p[guys]
            pt             = promedio_atributos
            pi             = promedio_por_individuo(p,guys,grupos,pt.count,porGrupo).clone
            d              = fitness_por_individuo(pt,pi,guys)
            f              = ruleta(guys,n_children,d) 
            p_children     = cruce(f,porGrupo,p)
            p_children_fix = childrens_fix(f,p_children,estudiantes)

            #pt.each do |e|
            #  puts e.to_s
            #end

            #for j in 1..guys
            #  puts "PI " + (j-1).to_s
            #  for i in 1..pi[j-1].row_size
            #    aux = ''
            #    pi[j-1].row(i-1).each do |e|
            #      aux = aux + " " + e.to_s
            #    end
            #    puts aux.to_s
            #  end
            #end

            ##puts "2. D de funciones"
            ##d.each_with_index do |e, index|
            ##  puts "Individuo: " + index.to_s + " valor: " + e.to_s
            ##end
            ##puts " "
            d.each_with_index do |e, index|
              if d.min == e
                d_solutions[x-1] = d.min
                ##puts "3. Individuo: " + index.to_s + " es optimo con fitness mínimo de: " + d.min.to_s
                solutions[x-1] = p[index].clone
                for i in 1..p[index].row_size
                  aux = ''
                  p[index].row(i-1).each do |e|
                    aux = aux + " " + e.to_s
                  end
                  ##puts aux.to_s
                end
                ##puts " "
              end
            end

            ##puts " "
            ##puts "4. Selección de individuos para la reproducción"
            ##f.each_with_index do |e, index|
            ##  puts "Individuo: " + e.to_s
            ##    for i in 1..p[e].row_size
            ##      aux = ''
            ##      p[e].row(i-1).each do |e|
            ##        aux = aux + " " + e.to_s
            ##      end
            ##      puts aux.to_s
            ##    end
            ##    puts " "
            ##end

            ##puts "5. Genes mutados..."
            ##puts " "
            ##puts "6. Hijos nueva generación: " + x.to_s
            ##f.each_with_index do |e, index|
            ##    for i in 1..p_children_fix[index].row_size
            ##      aux = ''
            ##      p_children_fix[index].row(i-1).each do |e|
            ##        aux = aux + " " + e.to_s
            ##      end
            ##      puts aux.to_s
            ##    end
            ##    puts " "
            ##end
            p    = p_children_fix.clone
            guys = n_children
          end
          # Mostrando resultados por generación
          for x in 1..generation
            if d_solutions[x-1] == d_solutions.min
              min = x-1
            end
          end
          ##puts "MIN INDICE " + min.to_s + " : " + d_solutions.min.to_s

          ##for i in 1..solutions[min].row_size
          ##  aux = ''
          ##  solutions[min].row(i-1).each do |e|
          ##    aux = aux + " " + e.to_s
          ##    seccion.users.where(rol: 3).each do |estu|
          ##      if Eneatype.exists?(user_id: estu.id) 
          ##        puts "seccion: " + seccion.section.to_s + " numero: " + (indice+1).to_s + " estudiante: " + estu.email.to_s
          ##      end
          ##    end
          ##  end
          ##  ##puts aux.to_s
          ##end
          ##puts " "
          @status = '¡GRUPOS GENERADOS CON ÉXITO!'
          @grupos[indice] = solutions[min].clone
          @section_title[indice] = seccion.code.to_s

          if UserSection.where(section_id: seccion.id).groups_formed.count > 0
            grupadelete = UserSection.where(section_id: seccion.id).groups_formed
            grupadelete.destroy_all
          end
          for i in 1..@grupos[indice].row_size 
            @grupos[indice].row(i-1).each do |element| 
              if element != 'x' 
                integrantes = []
                seccion.users.where(rol: 3).each do |e|
                  if e.tests.exists? && e.tests.first.answered? && e.tests.second.answered? && e.tests.last.answered?
                    integrantes << e
                  end
                end
                integrantes.each_with_index do |estu, idd|
                  if (idd+1) == element
                    puts "seccion: " + seccion.code.to_s + " numero: " + (i).to_s + " estudiante: " + estu.email.to_s 
                    actualData = UserSection.where(section_id: seccion.id, user_id: estu.id)
                    actualData.group_number = i
                    actualData.save
                  end
                end
              end 
            end 
          end
         
 
        else
          ##puts " "
          ##puts  "No es posible calcular grupos"
          @status = 'NO ES POSIBLE GENERAR LOS EQUIPOS DE:'
          @status_seccion = @status_seccion + ' / ' + seccion.code.to_s
          ##if grupos < residuo
          ##  puts  "Grupos de mínimo " + porGrupo.to_s + " estudiantes generaran grupos sobrantes desiguales"
          ##end
          ##puts " "
        end

      end #ciclo
    end # condicion de busqueda
  end # fin index


  def childrens_fix(f,p_children,estudiantes)
    #puts "FIIIIIIX"
    f.each_with_index do |e, index|
      #puts "Individuo: " + e.to_s
        for i in 1..p_children[index].row_size
          #aux = ''
          p_children[index].row(i-1).each_with_index do |e, indexa|
            #aux = aux + " " + e.to_s
            if e != 'x'
              if p_children[index].count(e) > 1
                #puts e.to_s + "esta " + p_children[index].count(e).to_s
                val = true
                acum = 0
                while val do
                  ran = rand(1..estudiantes)
                  p_children[index].each { |e| 
                    if ran == e
                      acum += 1
                    end
                  }
                  if acum > 0
                    val = true
                    acum = 0
                  else
                    val = false
                  end
                end
                #puts "x: " + (i-1).to_s + " y " + indexa.to_s
                p_children[index].send(:[]=, i-1, indexa, ran)
              end
            end
          end
          #puts aux.to_s
        end
        #puts " "
    end
    return p_children
  end

  def cruce(f,porGrupo,p)
    p_children = []
    padres     = 0
    corte      = rand(1..(porGrupo-1))
    hijos      = Matrix.build(p[0].row_size, p[0].column_size){ nil }
    hijos2     = Matrix.build(p[0].row_size, p[0].column_size){ nil }
    id         = 0
    id2        = 0
    indexa     = 0
    #puts "corte en " + corte.to_s + " porgrupo:" + p[0].row_size.to_s

    f.each_with_index do |e, index|
      if padres < 1
        #puts "PARTE: " + f[index].to_s + " y " + f[index+1].to_s
        for i in 1..p[e].row_size
          #aux = ''
          #aux2 = ''
          p[e].row(i-1).each_with_index do |e, index|
            if index < corte
              #aux = aux + " " + e.to_s
              #puts "id: " + id.to_s + " indexa " + indexa.to_s
              hijos.send(:[]=, indexa, id, e)
              id +=1
            end
          end
          #aux = aux + " | "
          p[f[index+1]].row(i-1).each_with_index do |e, index|
            if index >= corte
              #aux = aux + " " + e.to_s
              #puts "id: " + id.to_s + " indexa " + indexa.to_s
              hijos.send(:[]=, indexa, id, e)
              id +=1
            end
          end

          p[f[index+1]].row(i-1).each_with_index do |e, index|
            if index < corte
              #aux2 = aux2 + " " + e.to_s
              #puts "id: " + id.to_s + " indexa " + indexa.to_s
              hijos2.send(:[]=, indexa, id2, e)
              id2 +=1
            end
          end
          #aux2 = aux2 + " - "
          p[e].row(i-1).each_with_index do |e, index|
            if index >= corte
              #aux2 = aux2 + " " + e.to_s
              #puts "id: " + id.to_s + " indexa " + indexa.to_s
              hijos2.send(:[]=, indexa, id2, e)
              id2 +=1
            end
          end
          #puts aux.to_s
          #puts aux2.to_s
          id = 0 # fin column
          id2 = 0 # fin column
          indexa +=1
        end
        #puts " "
        indexa = 0
        padres +=1
        #puts "index " +  index.to_s + " sigindex " +  (index+1).to_s
        p_children[index]   = hijos.clone
        p_children[index+1] = hijos2.clone
      else
        padres = 0
      end
    end
    return p_children
  end

  def ruleta(guys,childrens,d)
    f          = []
    porcentaje = []
    dPorcion   = []
    acum  = 0
    turno = 0


    d.each_with_index do |e, index|
      dPorcion[index] = (d.max/e).round(0)
      #puts "d Porcion " + e.to_s + " con " + index.to_s + ": " + dPorcion[index].to_s
    end
  
    total = dPorcion.sum

    dPorcion.each_with_index do |e, index|
      porcentaje[index] = (e*100/total).round(0)
      if porcentaje[index] == 0
        porcentaje[index] = 1
      end
      #puts "%: " + index.to_s + ": " + porcentaje[index].to_s
    end

    porcentaje.each do |e|
      acum = acum + e
    end

    ruleta = []
    acum2 = 0

    for index in 0..(acum-1)
      if turno == 0
        turno = porcentaje[acum2]
        acum2 +=1
      end
      ruleta[index] = acum2-1
      turno -=1
    end

    for i in 1..childrens
      val = true
      acuma = 0
      while val do
        ran = ruleta[rand(0..(acum-1))]
        f.each { |e| 
          if ran == e
            acuma += 1
          end
        }
        if acuma > 0
          val = true
          acuma = 0
        else
          val = false
        end
      end
      f[i-1] = ran
    end
    return f
  end

  def cantidad_hijos(guys)
    hijos = guys/2
    if hijos%2 != 0
      hijos +=1
    end
    return hijos
  end

  def fitness_por_individuo(pt,pi,guys)
    d     = []
    for j in 1..guys
      acum  = 0.0
      for i in 1..pi[j-1].row_size
        pi[j-1].row(i-1).each_with_index do |e, index|
          acum  = acum + (pt[index]-e)**2
        end
      end
      d[j-1] = (acum).round(2)
      acum  = 0.0
    end
    return d
  end

  def promedio_por_individuo(p,guys,grupos,largo,porGrupo)
    pi    = []
    grupo = []
    acum  = 0.0
    count = 0
    #puts "grupos: " + grupos.to_s + ", largo " + largo.to_s
    pg = Matrix.build(grupos, largo){ nil }
    for j in 1..guys
      for i in 1..p[j-1].row_size
        p[j-1].row(i-1).each_with_index do |e, index|
          if e =='x'
            grupo[index] = -1
          else
            grupo[index] = e-1
          end
        end
        pg.row(i-1).each_with_index do |h, index|
          grupo.each do |g|
            if g == -1
              count = count +=1
            else
              acum = acum + @Map[g,index]
            end
          end
          if count == 0
            pg.send(:[]=, i-1, index, (acum/(porGrupo)).round(2))
          else
            pg.send(:[]=, i-1, index, (acum/(porGrupo-1)).round(2))
          end
          acum = 0.0
          count = 0
        end
      end
      pi[j-1] = pg.clone
    end
    return pi
  end

  def promedio_atributos
    pt = [] 
    for i in 1..@Map.column_size
      auxPt = 0
      @Map.column(i-1).each do |e|
        auxPt = auxPt + e
      end
      pt[i-1] = (auxPt/@Map.column_size)#.round(2)
    end  
    return pt
  end

  def generar_Individuos (guys, grupos, porGrupo, estudiantes, totalAux)
    p = []                     # Población de individuos
    for j in 1..guys           # Se generan los individuos de form aleatoria
      @Guy = Matrix.build(grupos, porGrupo){ 'x' }
      for i in 1..@Guy.column_size
        @Guy.column(i-1).each_with_index do |e, index|
          if totalAux > 0
            val = true
            acum = 0
            while val do
              ran = rand(1..estudiantes)
              @Guy.each { |e| 
                if ran == e
                  acum += 1
                end
              }
              if acum > 0
                val = true
                acum = 0
              else
                val = false
              end
            end
            @Guy.send(:[]=,index, i-1 , ran)
            totalAux -= 1
          end
        end
      end
      p[j-1] = @Guy.clone
      totalAux = estudiantes
    end
    return p
  end

  def my_group
    if current_user.group != nil
      group = UserSection.where(group_number: current_user.group.number, section_id: current_user.sections.first.id )
      my_group = []

      group.each_with_index do |estudiante, index|
        @my_group[index] = estudiante
    end
  end
  
end
end
