module Admin
  class QuestionsController < AdminController
    def index
      @questions = Question.all
    end

    def new
      @question = Question.new
    end

    def create
      Question.create(params_question)
      redirect_to "/admin/questions"
    end

    def edit
      @question = find_question
    end

    def update
      find_question.update(params_question)
      redirect_to "/admin/questions"
    end

    def remove
      find_question.destroy
      redirect_to "/admin/questions"
    end

    private

    def find_question
      Question.find(params[:id])
    end

    def params_question
      params.require(:question).permit(:title, :content)
    end
  end
end