class Transfer < ActiveRecord::Base
  belongs_to :company
  has_many :transfer_items, dependent: :destroy
  default_scope { order("created_at DESC") }

  def magazine_from
    company.magazines.where(id: magazine_id_from).last
  end

  def magazine_to
    company.magazines.where(id: magazine_id_to).last
  end
end
