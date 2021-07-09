class AlexaController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create
		render json: {"data": "hello world"}
	end

	def index
		render json: { "data": "todo: documentation on how to use the skill"}
	end
end
