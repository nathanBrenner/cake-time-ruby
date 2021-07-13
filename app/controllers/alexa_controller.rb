require 'date'
require "json"
require "ostruct"

class AlexaController < ApplicationController
	skip_before_action :verify_authenticity_token

	def create
    message = "Hello! Welcome to Cake time. What is your birthday?"
    session_attributes = {"previous_session": "something"}
    session_end = false

		case params_struct.request.type
		when 'LaunchRequest'
      # fetch user
      # if user, return a different message
			message = hasBirthday? ? birthday_countdown : message
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

  def params_struct
    json_data = params.to_json
    JSON.parse(json_data, object_class: OpenStruct)
  end

  def birthdayIntent?
    params_struct.request.intent.name === 'CaptureBirthdayIntent'
  end

  def birthday
    year = params_struct.request.intent.slots.year.value
    month = params_struct.request.intent.slots.month.value
    day = params_struct.request.intent.slots.day.value
    id = params_struct.session.user.userId

    user = User.new(
      birthday: DateTime.new(
        year.to_i,
        Date::MONTHNAMES.index(month),
        day.to_i
      ),
      alexa_id: id
    )

    if user.save
      "Thanks, I'll remember that you were born #{month} #{day} #{year}."
    else
      "Error"
    end
  end

  def hasBirthday?
    User.exists?(alexa_id: params_struct.session.user.userId)
  end

  def birthday_countdown
    user = User.find_by(alexa_id: params_struct.session.user.userId)
    one_day = 24*60*60*1000;
    today = Date.today
    current_year = today.year
    birthdate = DateTime.parse(user.birthday.to_s)
    next_birthday = DateTime.new(current_year, birthdate.month, birthdate.day)
    
    if today > next_birthday 
      current_year = current_year + 1
      next_birthday = DateTime.new(current_year, birthdate.month, birthdate.day)
    end

    result = "Happy #{current_year - birthdate.year}th birthday!";
    if !birthdate.today?
      day_count = (today - next_birthday).to_i.abs
      result = "Welcome back. It looks like there are #{day_count} days until your #{current_year - birthdate.year}th birthday."
    end
    result
  end
end