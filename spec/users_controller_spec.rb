require 'rails_helper'
require 'json'

RSpec.describe UsersController, type: :request do
	describe "Create" do
		it "creates new user successfully" do
			json_params = {user: {username: "Test", email: "test@email.com", password: "TESTPASS", password_confirmation: "TESTPASS"}}
			post '/users', params: json_params, as: :json

			json_response = JSON.parse(response.body)
			expect(response).to be_success
		end

		it "creates with mismatched passwords" do
			json_params = {user: {username: "Test", email: "test@email.com", password: "TESTPASS", password_confirmation: "WRONG"}}
			post '/users', params: json_params, as: :json

			json_response = JSON.parse(response.body)
			expect(response.response_code) == 422
		end

	end

	describe "Login" do
		before(:each) do
			#Create new user
			json_params = {user: {username: "Test", email: "test@email.com", password: "TESTPASS", password_confirmation: "TESTPASS"}}
			post '/users', params: json_params, as: :json

			json_response = JSON.parse(response.body)
			@user_id = json_response["id"]
			expect(response).to be_success
		end

		it "logs in successfully" do
			json_params = {password: "TESTPASS"}

			get "/users/login/#{@user_id}", params: json_params, as: :json
			expect(response).to be_success
		end

		it "fails to log in" do
			json_params = {id: @user_id, password: "WRONGPASS"}

			get "/users/login/#{@user_id}", params: json_params, as: :json
			json_response = JSON.parse(response.body)
			expect(json_response["login_status"]) == false
		end
	end

	describe "Delete" do
		before(:each) do
			#Create new user
			json_params = {user: {username: "Test", email: "test@email.com", password: "TESTPASS", password_confirmation: "TESTPASS"}}
			post '/users', params: json_params, as: :json

			json_response = JSON.parse(response.body)
			@user_id = json_response["id"]
			expect(response).to be_success

			#Create new Category
			json_params = {category: {name: "Uncategorized"}}
			post "/categories", params: json_params, as: :json

			json_response = JSON.parse(response.body)
			@category_id = json_response["id"]
			expect(response).to be_success


			#Create new Todo
			json_params = {task: "Test", description: "Test TODO", priority: "1", category_id: @category_id, user_id: @user_id}
			post "/todos", params: json_params, as: :json

			json_response= JSON.parse(response.body)
			@todo_id = json_response["id"]
			expect(response).to be_success
		end

		it "deletes user and todos" do
			json_params = {}
			delete "/users/#{@user_id}", params: json_params, as: :json

			expect(response).to be_success

			#Check that todos were cleaned up
			get "/todos/#{@todo_id}", params: {}, as: :json
			json_response = JSON.parse(response.body)
			expect(json_response["error"]) == "Todo not found"

		end
	end
end
