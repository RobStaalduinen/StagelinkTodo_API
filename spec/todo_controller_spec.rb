require 'rails_helper'
require 'json'

RSpec.describe TodosController, type: :request do
	before(:each) do
		#Create new Category
		json_params = {category: {name: "Uncategorized"}}
		post "/categories", params: json_params, as: :json

		json_response = JSON.parse(response.body)
		@category_id = json_response["id"]
		expect(response).to be_success

		#Create new User

		json_params = {username: "Test", email: "test@email.com", password: "TESTPASS", password_confirmation: "TESTPASS"}
		post "/users", params: json_params, as: :json

		json_response = JSON.parse(response.body)
		@user_id = json_response["id"]
		expect(response).to be_success
	end

	describe 'Create', :type => :request do
		it "creates new todo" do
			#Create ToDo
			json_params = {task: "Test", description: "Test TODO", priority: "1", category_id: @category_id, user_id: @user_id}
			post "/todos", params: json_params, as: :json

			json_response= JSON.parse(response.body)
			expect(response).to be_success
			expect(json_response["task"]) == "Test"
		end

		it "creates todo without category" do
			json_params = {task: "Test No Category", description: "Should fail", priority: "1", user_id: @user_id}
			post "/todos", params: json_params, as: :json

			expect(response.response_code) == 401
		end

		it "creates todo without user" do
			json_params = {task: "Test No User", description: "Should fail", priority: "1", category_id: @category_id}
			post "/todos", params: json_params, as: :json

			expect(response.response_code) == 401
		end
	end

	describe 'Retrieve', :type => :request do
		before(:each) do
			#Create new Todo
			json_params = {task: "Test", description: "Test TODO", priority: "1", category_id: @category_id, user_id: @user_id}
			post "/todos", params: json_params, as: :json

			json_response= JSON.parse(response.body)
			@todo_id = json_response["id"]
			expect(response).to be_success
		end

		it "finds single todo" do
			get "/todos/#{@todo_id}", as: :json
			json_response = JSON.parse(response.body)

			expect(response).to be_success
			expect(json_response["id"]) == @todo_id
		end

		it "gets todo index" do
			get "/todos"
			json_response = JSON.parse(response.body)

			expect(response).to be_success
			expect(json_response.length) == 1
		end
		it "gets nonexistant todo" do
			get "/todos/-1"
			expect(response).to be_not_found
		end

		it "gets todos by category" do
			get "/todos/find_by_category/#{@category_id}"
			json_response = JSON.parse(response.body)

			expect(response).to be_success
			expect(json_response.length) == 1
			expect(json_response[0]["category_id"]) == @category_id
		end

		it "gets todos by user" do
			get "/todos/find_by_user/#{@user_id}"
			json_response = JSON.parse(response.body)

			expect(response).to be_success
			expect(json_response.length) == 1
			expect(json_response[0]["user_id"]) == @user_id
		end
	end

	describe "Delete", :type => :request do
		before(:each) do
			#Create new Todo
			json_params = {task: "Test", description: "Test TODO", priority: "1", category_id: @category_id, user_id: @user_id}
			post "/todos", params: json_params, as: :json

			json_response= JSON.parse(response.body)
			@todo_id = json_response["id"]
			expect(response).to be_success
		end

		it "deletes single todo" do
			delete "/todos/#{@todo_id}"
			expect(response).to be_success

			get "/todos/#{@todo_id}", params: {}, as: :json
			expect(response).to be_not_found
		end
	end

end
