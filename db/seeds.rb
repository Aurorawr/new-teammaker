# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Carreras
inst = Institution.create(name: "Universidad de Santiago de Chile")

Program.create!(name: "Administración Pública", institution: inst)#0
Program.create!(name: "Ingeniería Ambiental", institution: inst) #1
Program.create!(name: "Ingeniería Civil en Electricidad", institution: inst) #2
Program.create!(name: "Ingeniería Civil en Geografía", institution: inst) #3<
Program.create!(name: "Ingeniería Civil en Industria", institution: inst) #4
Program.create!(name: "Ingeniería Civil en Informática", institution: inst) #5
Program.create!(name: "Ingeniería Civil en Mecánica", institution: inst) #6
Program.create!(name: "Ingeniería Civil en Metalurgia", institution: inst) #7
Program.create!(name: "Ingeniería Civil en Minas", institution: inst) #8
Program.create!(name: "Ingeniería Civil en Obras Civiles", institution: inst) #9
Program.create!(name: "Ingeniería Civil en Química", institution: inst) #10
program = Program.create!(name: "Ingeniería de Ejecución en Computación e Informática", institution: inst) #11
Program.create!(name: "Ingeniería de Ejecución en Minas", institution: inst) #12
Program.create!(name: "Ingeniería de Ejecución en Electricidad", institution: inst) #13
Program.create!(name: "Ingeniería de Ejecución en Geomensura", institution: inst) #14
Program.create!(name: "Ingeniería de Ejecución en Industria", institution: inst) #15
Program.create!(name: "Ingeniería de Ejecución en Mecánica", institution: inst) #16
Program.create!(name: "Ingeniería de Ejecución en Metalurgia", institution: inst) #17
Program.create!(name: "Ingeniería de Ejecución en Química", institution: inst) #18

# Coordinadores
program.users.create!(email: 'coordinador@mail.com',name: 'Juan' ,surname: 'Gómez' , rol: 0 ,status: true ,password: '111111',password_confirmation: '111111')

# Profesores
program.users.create!(email: 'profesor@mail.com',name: 'Juan' ,surname: 'Araya' , rol: 1 ,status: true ,password: '111111',password_confirmation: '111111')

# Ayudantes
program.users.create!(email: 'ayudante@mail.com',name: 'Emma' ,surname: 'Watson' , rol: 2 ,status: true ,password: '111111',password_confirmation: '111111')

# Estudiantes
program.users.create!(email: 'estudiante@mail.com',name: 'Franco' ,surname: 'Gotelli' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'jorge.plaza@usach.cl',name: 'Jorge' ,surname: 'Plaza' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'juanmartinez965@gmail.com',name: 'Juan' ,surname: 'Martinez' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'daniel.gomez@usach.cl',name: 'Daniel' ,surname: 'Gomez' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'diego.salazar.se@usach.cl',name: 'Diego' ,surname: 'Salazar' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'franco.labra@usach.cl',name: 'Franco' ,surname: 'Labra' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'jose.mellado@usach.cl',name: 'José' ,surname: 'Mellado' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'marco.opazo@usach.cl',name: 'Marco' ,surname: 'Opazo' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'mauricio.soto.p@usach.cl',name: 'Mauricio' ,surname: 'Soto' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'rafael.segura@usach.cl',name: 'Rafael' ,surname: 'Segura' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'vicente.ortiz@usach.cl',name: 'Vicente' ,surname: 'Ortiz' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')
program.users.create!(email: 'vicente.rivera.r@usach.cl',name: 'Vicente' ,surname: 'Rivera' , rol: 3 ,status: true ,password: '111111',password_confirmation: '111111')

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

