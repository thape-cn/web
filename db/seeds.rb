# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ProjectType.create(id: 1, cn_name: '居住', en_name: 'RESIDENTIAL')
ProjectType.create(id: 2, cn_name: '展示区/示范区', en_name: 'DEMONSTRATION ZONE')
ProjectType.create(id: 3, cn_name: '商务办公', en_name: 'OFFICE')
ProjectType.create(id: 4, cn_name: '超高层', en_name: 'SUPERTALL')
ProjectType.create(id: 5, cn_name: '商业空间', en_name: 'COMMERCIAL')
ProjectType.create(id: 6, cn_name: '综合体/TOD', en_name: 'MIXED-USED/TOD')
ProjectType.create(id: 7, cn_name: '文化空间', en_name: 'CULTURAL')
ProjectType.create(id: 8, cn_name: '医疗康养', en_name: 'MEDICAL CARE')
ProjectType.create(id: 9, cn_name: '旅居/酒店', en_name: 'SOJOURN/HOSPITALITY')
ProjectType.create(id: 10, cn_name: '教育', en_name: 'EDUCATION')
ProjectType.create(id: 11, cn_name: '城市设计/更新', en_name: 'URBAN DESIGN/RENOVATION')
ProjectType.create(id: 12, cn_name: '城市规划', en_name: 'URBAN PLANNING')
ProjectType.create(id: 13, cn_name: '景观', en_name: 'LANDSCAPE')
ProjectType.create(id: 14, cn_name: '室内', en_name: 'INTERIOR')

ResidentialType.create(id: 1, cn_name: '精品住宅', en_name: 'RESIDENCE')
ResidentialType.create(id: 2, cn_name: '综合社区', en_name: 'COMMUNITY')
ResidentialType.create(id: 3, cn_name: '租赁住房', en_name: 'RENTAL')

