# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Carreras
Career.create!(name: "Administración Pública") #0
Career.create!(name: "Ingeniería Ambiental") #1
Career.create!(name: "Ingeniería Civil en Electricidad") #2
Career.create!(name: "Ingeniería Civil en Geografía") #3
Career.create!(name: "Ingeniería Civil en Industria") #4
Career.create!(name: "Ingeniería Civil en Informática") #5
Career.create!(name: "Ingeniería Civil en Mecánica") #6
Career.create!(name: "Ingeniería Civil en Metalurgia") #7
Career.create!(name: "Ingeniería Civil en Minas") #8
Career.create!(name: "Ingeniería Civil en Obras Civiles") #9
Career.create!(name: "Ingeniería Civil en Química") #10
Career.create!(name: "Ingeniería de Ejecución en Computación e Informática") #11
Career.create!(name: "Ingeniería de Ejecución en Minas") #12
Career.create!(name: "Ingeniería de Ejecución en Electricidad") #13
Career.create!(name: "Ingeniería de Ejecución en Geomensura") #14
Career.create!(name: "Ingeniería de Ejecución en Industria") #15
Career.create!(name: "Ingeniería de Ejecución en Mecánica") #16
Career.create!(name: "Ingeniería de Ejecución en Metalurgia") #17
Career.create!(name: "Ingeniería de Ejecución en Química") #18

# Coordinadores
User.create!(email: 'coordinador@mail.com',name: 'Juan' ,surname: 'Gómez' , rol: 0 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 1)

# Profesores
User.create!(email: 'profesor@mail.com',name: 'Juan' ,surname: 'Araya' , rol: 1 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 1)

# Ayudantes
User.create!(email: 'ayudante@mail.com',name: 'Emma' ,surname: 'Watson' , rol: 2 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 1)

# Estudiantes
User.create!(email: 'estudiante@mail.com',name: 'Franco' ,surname: 'Gotelli' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 1)
User.create!(email: 'jorge.plaza@usach.cl',name: 'Jorge' ,surname: 'Plaza' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 2)
User.create!(email: 'juanmartinez965@gmail.com',name: 'Juan' ,surname: 'Martinez' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 2)
User.create!(email: 'daniel.gomez@usach.cl',name: 'Daniel' ,surname: 'Gomez' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 3)
User.create!(email: 'diego.salazar.se@usach.cl',name: 'Diego' ,surname: 'Salazar' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 3)
User.create!(email: 'franco.labra@usach.cl',name: 'Franco' ,surname: 'Labra' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 2)
User.create!(email: 'jose.mellado@usach.cl',name: 'José' ,surname: 'Mellado' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 3)
User.create!(email: 'marco.opazo@usach.cl',name: 'Marco' ,surname: 'Opazo' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 4)
User.create!(email: 'mauricio.soto.p@usach.cl',name: 'Mauricio' ,surname: 'Soto' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 1)
User.create!(email: 'rafael.segura@usach.cl',name: 'Rafael' ,surname: 'Segura' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 1)
User.create!(email: 'vicente.ortiz@usach.cl',name: 'Vicente' ,surname: 'Ortiz' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 4)
User.create!(email: 'vicente.rivera.r@usach.cl',name: 'Vicente' ,surname: 'Rivera' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111', career_id: 4)

# Secciones
subject = Subject.create!(name: "Demeter", code: "DMT")

type = SectionType.create!(name: "Laboratorio")

Section.create!(subject: subject, section_type: type, code: 'A-1', semester: 2, year: 2017)

# Relaciones: estudiante-sección
UserSection.create(section_id: 1,user_id: 3) # 
UserSection.create(section_id: 1,user_id: 4) # 
UserSection.create(section_id: 1,user_id: 5) # 
UserSection.create(section_id: 1,user_id: 6) # 
UserSection.create(section_id: 1,user_id: 7) # 
UserSection.create(section_id: 1,user_id: 8) # 
UserSection.create(section_id: 1,user_id: 9) # 
UserSection.create(section_id: 1,user_id: 10) # 
UserSection.create(section_id: 1,user_id: 11) # 
UserSection.create(section_id: 1,user_id: 12) # 
UserSection.create(section_id: 1,user_id: 13) # 
UserSection.create(section_id: 1,user_id: 14) # 
UserSection.create(section_id: 1,user_id: 15) # 
UserSection.create(section_id: 1,user_id: 16) # 

