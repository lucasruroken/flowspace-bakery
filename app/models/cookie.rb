class Cookie < ActiveRecord::Base
  include AASM

  belongs_to :storage, polymorphic: :true
  
  validates :storage, presence: true

  after_commit :prepare, on: :create

  aasm column: 'state' do
    state :created, initial: true
    state :cooked

    event :cook do
      transitions from: :created, to: :cooked
    end
  end

  alias_method :ready?, :cooked?

  private

  def prepare
    ::Cookies::CookWorker.perform_in(1.minute, id)
  end
end
