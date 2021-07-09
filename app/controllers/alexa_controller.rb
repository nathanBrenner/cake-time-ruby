class AlexaController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create
    message = "hello world"
    session_attributes = {"previous_session": "something"}
    session_end = true

		case params[:request][:type]
		when 'LaunchRequest'
			message = 'Hello! Welcome to Cake time. What is your birthday?'
		end
    render json: {
      "response": {
        "outputSpeech": {
          "type": "PlainText",
          "text": message,
        },
        "shouldEndSession": session_end
      },
      "sessionAttributes": session_attributes
    }
	end

	def index
		render json: { "data": "todo: documentation on how to use the skill"}
	end
end
