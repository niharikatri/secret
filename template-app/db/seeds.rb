# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.where(email: 'admin@example.com').first_or_initialize.tap do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.save
end
BxBlockRolesPermissions::Role.find_or_create_by(name: "Papa")
BxBlockRolesPermissions::Role.find_or_create_by(name: "Mumma")
BxBlockRolesPermissions::Role.find_or_create_by(name: "Child")