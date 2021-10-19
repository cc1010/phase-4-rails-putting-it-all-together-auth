class RecipesController < ApplicationController
   before_action :authorize

   # rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
   # rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

   def index 
      recipes = Recipe.all
      render json: recipes, status: :created
   end

   def create
      user = User.find_by(id: session[:user_id])
      recipe = user.recipes.create(recipe_params)
      # render json: recipe, status: :created

      if recipe.valid?
         recipe.save
         render json: recipe, status: :created
      else
         render json:{ error: "recipe.errors" }, status: :unprocessable_entity
      end

   end

   private

   def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete, :user_id )
   end

   def authorize
     return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
   end

   #   def render_not_found_response
   #    render json: { error: "Record Not found" }, status: :not_found
   # end

   # def render_unprocessable_entity_response(invalid)
   #    render json: { errors: invalid.errors }, status: :unprocessable_entity
   #  end
end
