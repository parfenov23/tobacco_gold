class AdminController < ActionController::Base
  
  def index
    redirect_to "/stock" if current_user.admin rescue false
  end

  def all_categories

  end

  def edit_category

  end

  # save
  def save_category
    category = Category.new if params[:type] == "new"
    category = Category.find(params[:id]) if params[:type] == "edit"
    category.first_name = params[:first_name]
    category.save
    redirect_to "/admin/all_categories"
  end

  def save_question
    question = Question.new if params[:type] == "new"
    question = Question.find(params[:id]) if params[:type] == "edit"
    question.title = params[:title]
    question.content = params[:content]
    question.save
    redirect_to "/admin/all_questions"
  end

  def save_item
    item = Item.new if params[:type] == "new"
    item = Item.find(params[:id]) if params[:type] == "edit"
    item.first_name = params[:first_name]
    item.img_url = params[:img_url]
    item.category_id = params[:category_id]
    item.description = params[:description]
    item.save
    redirect_to "/admin/all_items"
  end

  def create_attachment
    # name = params[:upload][:file].original_filename + SecureRandom.hex(10)
    # directory = "public/images/upload"
    # path = File.join(directory, name)
    # File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
    # attachment = Attachments.build(path)
    # attachment.save
    render json: {id: attachment.id, path: path}
  end


  # destroy
  def destroy_category
    Category.find(params[:id]).destroy
    redirect_to "/admin/all_categories"
  end

  def destroy_item
    Item.find(params[:id]).destroy
    redirect_to "/admin/all_items"
  end

  def destroy_question
    Question.find(params[:id]).destroy
    redirect_to "/admin/all_question"
  end

end
