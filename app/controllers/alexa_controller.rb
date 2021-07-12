class AlexaController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create
    message = "hello test"
    session_attributes = {"previous_session": "something"}
    session_end = params[:request][:type] != 'LaunchRequest'

		case params[:request][:type]
		when 'LaunchRequest'
			message = 'Hello! Welcome to Cake time. What is your birthday?'
    when 'IntentRequest'
      if (birthdayIntent?)
        message = birthday
      end
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

  private

  def birthdayIntent?
    params[:request][:intent][:name] === 'CaptureBirthdayIntent'
  end

  def birthday
    year = params[:request][:intent][:slots][:year][:value];
    month = params[:request][:intent][:slots][:month][:value];
    day = params[:request][:intent][:slots][:day][:value];
    

    user = User.new(
      birthday: DateTime.new(
        year.to_i,
        Date::MONTHNAMES.index(month),
        day.to_i
      )
    )

    if user.save()
      "Thanks, I'll remember that you were born #{month} #{day} #{year}."
    else
      "Error"
    end
  end
end
