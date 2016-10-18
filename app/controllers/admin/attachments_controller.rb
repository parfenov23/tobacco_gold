module Admin
  class AttachmentsController < AdminController
    def remove
      attachment = find_attachment
      attachment.group.destroy_all
      redirect_to :back
    end
    private

    def find_attachment
      Attachment.find(params[:id])
    end
  end
end