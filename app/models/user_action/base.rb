class UserAction::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :proposition

  index({ user_id: 1, proposition_id: 1, }, { unique: true, background: true })
  index({ user_id: 1, }, { background: true })
  index({ proposition_id: 1, }, { background: true })

  validates :user, presence: true
  validates :proposition, presence: true

  after_create { proposition.inc(proposition_cache_field, 1) }
  after_destroy { proposition.inc(proposition_cache_field, -1) }


  protected
  def proposition_cache_field; self.class.proposition_cache_field end
  def self.proposition_cache_field
    "#{to_s.demodulize.underscore}_users_count".to_sym
  end
end
