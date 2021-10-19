class SessionsController < ApplicationController

   
   # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
   # rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response


   def create
      user = User.find_by_username(params[:username])
      if user&.authenticate(params[:password])
         session[:user_id] = user.id
         render json: user, status: :created
      else
         render json:{ error: "Invalid username or password" }, status: :unauthorized
       end
   end

   def destroy
      user = User.find_by(id: session[:user_id])
      if user
         session.delete :user_id
         head :no_content
      else
         render json: { error: "Invalid username or password" }, status: :unauthorized
      end
   end

   private
   # def render_not_found_response
   #    render json: { error: "Record Not found" }, status: :not_found
   # end

   # def render_unauthorized_entity_response(invalid)
   #    render json: { errors: invalid.record.errors.full_messages }, status: :unauthorized
   # end

end
