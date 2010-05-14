# By using the symbol ':user', we get Factory Girl to simulate the User model.

Factory.define :user do |user|
	user.name					          "Maxton Ito"
	user.email					        "maxtonito@gmail.com"
	user.password				        "highschoolmusical"
	user.password_confirmation	"highschoolmusical"
end